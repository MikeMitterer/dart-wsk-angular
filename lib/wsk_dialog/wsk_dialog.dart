library wsk_angular.wsk_dialog;

import 'dart:html' as html;
import 'dart:async';

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

part "src/utils.dart";
part "src/DialogElement.dart";
part "src/WskDialog.dart";

part "src/AlertDialog.dart";
part "src/ConfirmDialog.dart";

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _WskDialogCssClasses {

    final String WSK_DIALOG_CONTAINER = 'wsk-dialog--container';
    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN = 'is-hidden';

    const _WskDialogCssClasses();
}

/**
 * WskDialog Module.
 *    More infos: https://docs.angulardart.org/#di.Module
 */
class WskDialogModule extends Module {
    WskDialogModule() {

        bind(WskAlertDialog);
        bind(WskConfirmDialog);

        bind(WskDialogComponent);
        bind(WskDialogContentComponent);
        bind(WskDialogActions);

        //- Services ---------------------------
    }
}

@Decorator(selector: 'wsk-dialog')
class WskDialogComponent {

    WskDialogComponent(final html.Element component) {
        Validate.notNull(component);
        component.classes.add("wsk-dialog");
    }
}

@Decorator(selector: 'wsk-dialog-content')
class WskDialogContentComponent {

    WskDialogContentComponent(final html.Element component) {
        Validate.notNull(component);
        component.classes.add("wsk-dialog--content");
    }
}

@Decorator(selector: 'wsk-dialog-actions')
class WskDialogActions {

    WskDialogActions(final html.Element component) {
        Validate.notNull(component);
        component.classes.add("wsk-dialog--actions");
    }
}



