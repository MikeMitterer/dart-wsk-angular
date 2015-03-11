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

    final String DIALOG = "wsk-dialog";
    final String CONTENT = "wsk-dialog__content";
    final String ACTIONS = "wsk-dialog__actions";

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
    static const _WskDialogCssClasses _cssClasses = const _WskDialogCssClasses();

    WskDialogComponent(final html.Element component) {
        Validate.notNull(component);
        component.classes.add(_cssClasses.DIALOG);
    }
}

@Decorator(selector: 'wsk-dialog-content')
class WskDialogContentComponent {
    static const _WskDialogCssClasses _cssClasses = const _WskDialogCssClasses();

    WskDialogContentComponent(final html.Element component) {
        Validate.notNull(component);
        component.classes.add(_cssClasses.CONTENT);
    }
}

@Decorator(selector: 'wsk-dialog-actions')
class WskDialogActions {
    static const _WskDialogCssClasses _cssClasses = const _WskDialogCssClasses();

    WskDialogActions(final html.Element component) {
        Validate.notNull(component);
        component.classes.add(_cssClasses.ACTIONS);
    }
}



