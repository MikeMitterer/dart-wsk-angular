library wsk_angular_styleguide.custom_dialog;

import 'dart:html' as html;
import 'dart:async';

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';
import 'package:wsk_angular/wsk_dialog/wsk_dialog.dart';


/**
 * WskDialog Module.
 *    More infos: https://docs.angulardart.org/#di.Module
 */
class CustomDialogModule extends Module {
    CustomDialogModule() {

        bind(CustomDialog);

        //- Services ---------------------------
    }
}

@Component(selector: "custom-dialog" ,useShadowDom: false,
templateUrl: "packages/wsk_angular_styleguide/custom_dialog/custom_dialog.html")
class CustomDialog extends WskDialog {
    static const String SELECTOR = "custom-dialog";

    static const String _DEFAULT_YES_BUTTON = "Useful";
    static const String _DEFAULT_NO_BUTTON = "Not Useful";

    String title = "";
    String text = "";
    String yesButton = _DEFAULT_YES_BUTTON;
    String noButton = _DEFAULT_NO_BUTTON;

    CustomDialog(final Injector injector) : super(SELECTOR) {
        Validate.notNull(injector);
        this.injector = injector;
    }

    CustomDialog call(final String text,{ final String title: "",
        final String yesButton: _DEFAULT_YES_BUTTON, final String noButton: _DEFAULT_NO_BUTTON }) {
        Validate.notBlank(text);
        Validate.notNull(title);
        Validate.notBlank(yesButton);
        Validate.notBlank(noButton);

        this.text = text;
        this.title = title;
        this.yesButton = yesButton;
        this.noButton = noButton;

        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onYes() {
        close(WskDialogStatus.YES);
    }

    void onNo() {
        close(WskDialogStatus.NO);
    }

// - private ----------------------------------------------------------------------------------

}



