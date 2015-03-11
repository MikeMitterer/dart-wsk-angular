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
    final String IS_HIDDEN = 'is-hidden';

    const _WskToastCssClasses();
}

class _ToastConfig extends DialogConfig {
    _ToastConfig() : super(rootTagInTemplate: "wsk-toast", closeOnBackDropClick: false);
}

/// WskToastComponent
@Component(selector: 'wsk-toast-dialog', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_toast/wsk_toast.html')
class WskToast extends WskDialog {
    static const String SELECTOR = "wsk-toast-dialog";
    final Logger _logger = new Logger('wsk_angular.wsk_toast.WskToastComponent');

    static const String DEFAULT_CONFIRM_BUTTON = "OK";

    bool _needsConfirmation = false;

    String text = "";
    String confirmButton = "";

    WskToast(final Injector injector) : super(SELECTOR,new _ToastConfig()) {
        Validate.notNull(injector);
        this.injector = injector;

        config.onCloseCallbacks.add(_onCloseViaEscOrClickOnBackDrop);
    }

    WskToast call(final String text, { final String confirmButton: "" }) {
        Validate.notBlank(text);
        Validate.notNull(confirmButton);
        Validate.isTrue(!_needsConfirmation,"One Toast waits for confirmation, but the next one is already in the queue!");

        this.text = text;
        this.confirmButton = confirmButton;

        _needsConfirmation = hasConfirmButton;
        _logger.info("Confirm: ${this.confirmButton}");
        return this;
    }

    bool get hasConfirmButton => confirmButton != null && confirmButton.isNotEmpty;

    @override
    /// Closes previous Toast if there is one
    Future<WskDialogStatus> show() {
        return close(WskDialogStatus.CLOSED_VIA_NEXT_SHOW).then( (_) => super.show());
    }

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        _logger.info("onClose");
        _needsConfirmation = false;

        close(WskDialogStatus.OK);
    }

    // - private ----------------------------------------------------------------------------------

    void _onCloseViaEscOrClickOnBackDrop(final DialogElement dialogElement, final WskDialogStatus status) {
        _needsConfirmation = false;
    }
}
        