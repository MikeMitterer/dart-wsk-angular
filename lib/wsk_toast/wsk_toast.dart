library wsk_angular.wsk_toast;

import 'dart:html' as html;
import "dart:async";

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';
import 'package:wsk_angular/wsk_dialog/wsk_dialog.dart';
export 'package:wsk_angular/wsk_dialog/wsk_dialog.dart' show WskDialogStatus;

/**
 * WskToast Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskToastModule extends Module {
    WskToastModule() {
        install(new WskDialogModule());

        bind(WskToast);

        //- Services ---------------------------
    }
}

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _WskToastCssClasses {

    final String WSK_TOAST_CONTAINER = 'wsk-toast__container';

    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN  = 'is-hidden';

    const _WskToastCssClasses();
}

class _ToastConfig extends DialogConfig {
    _ToastConfig() : super(rootTagInTemplate: "wsk-toast",
        closeOnBackDropClick: false,
        autoClosePossible: true);
}

/// Position on Screen or in container
class ToastPosition {
    bool _top = true;
    bool _right = true;
    bool _bottom = false;
    bool left = false;

    bool get top => _top || bottom ? _top : true;
    bool get right => _right || left ? _right : true;
    bool get bottom => _bottom && _top ? false : _bottom;

    set top(bool value) => _top = value;
    set bottom(bool value) => _bottom = value;
    set right(bool value) => _right = value;
}

/// WskToastComponent
@Component(selector: 'wsk-toast-dialog', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_toast/wsk_toast.html')
class WskToast extends WskDialog {
    static const String SELECTOR = "wsk-toast-dialog";
    final Logger _logger = new Logger('wsk_angular.wsk_toast.WskToastComponent');

    static const String DEFAULT_CONFIRM_BUTTON = "OK";

    static const int LONG_DELAY = 3500;
    static const int SHORT_DELAY = 2000;

    /// If Toast has a confirmButton this is set to a valid dialog-ID
    String _confirmationID = "";

    /// Position on Screen or in container
    final ToastPosition position = new ToastPosition();

    String text = "";
    String confirmButton = "";

    int timeout = SHORT_DELAY;

    WskToast(final Injector injector) : super(SELECTOR,new _ToastConfig()) {
        Validate.notNull(injector);
        this.injector = injector;

        config.onCloseCallbacks.add(_onCloseCallback);
    }

    WskToast call(final String text, { final String confirmButton: "" }) {
        Validate.notBlank(text);
        Validate.notNull(confirmButton);
        Validate.isTrue(_confirmationID.isEmpty,"One Toast waits for confirmation, but the next one is already in the queue! ($_confirmationID)");

        this.text = text;
        this.confirmButton = confirmButton;

        _logger.info("Confirm: ${this.confirmButton}");
        return this;
    }

    /// The current Toast waits for user interaction
    bool get waitingForConfirmation => _confirmationID.isNotEmpty;

    /// The template checks it it should show a button or not
    bool get hasConfirmButton => confirmButton != null && confirmButton.isNotEmpty;

    @override
    /// if there is already a Toast open - it will be closed
    Future<WskDialogStatus> show() {
        Validate.isTrue(!waitingForConfirmation,"There is alread a Toast waiting for confirmation!!!!");

        return close(WskDialogStatus.CLOSED_VIA_NEXT_SHOW).then( (_) {

            if(!hasConfirmButton) {
                return super.show(timeout: new Duration(milliseconds: timeout));
            }

            return super.show(dialogIDCallback: _setConfirmationID );
        });
    }

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        Validate.notBlank(_confirmationID, "onClose must have a _confirmationID set - but was blank");

        _logger.info("onClose");
        close(WskDialogStatus.CONFIRMED,dialogID: _confirmationID);
    }

    // - private ----------------------------------------------------------------------------------

    void _onCloseCallback(final DialogElement dialogElement, final WskDialogStatus status) {
        _logger.info("onCloseCallback, ID: ${dialogElement.id}, $status, ConfirmationID: $_confirmationID");
        if(_confirmationID.isNotEmpty && dialogElement.id == _confirmationID) {
            _clearConfirmationCheck();
        }
    }

    /// Its important to know the ID of the dialog that needs a confirmation - otherwise another
    /// dialog could reset the {_needsConfirmation} flag
    void _setConfirmationID(final String id) {
        Validate.notBlank(id);
        _confirmationID = id;
    }

    void _clearConfirmationCheck() {
        _confirmationID = "";
    }
}
        