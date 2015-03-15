library wsk_angular.example.wsk_textfield;

import 'dart:html' as html;
import "dart:math" as Math;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

// only for sample
import 'package:wsk_angular/wsk_button/wsk_button.dart';
import 'package:wsk_angular/wsk_checkbox/wsk_checkbox.dart';

import 'package:wsk_angular/wsk_dialog/wsk_dialog.dart';
import 'package:wsk_angular_dialog_sample/custom_dialog/custom_dialog.dart';


@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_textfield.AppController');

    final WskAlertDialog _alert;
    final WskConfirmDialog _confirm;
    final CustomDialog _customDialog;

    int mangoCounter = 0;
    String statusMessage = "";
    bool enableEsc = true;
    bool enableBackDropClick = true;

    AppController(this._alert,this._confirm,this._customDialog) {
        _logger.fine("AppController");
    }

    void openAlertDialog() {
        _logger.info("openAlertDialog");

        _alert.config.acceptEscToClose = enableEsc;
        _alert.config.closeOnBackDropClick = enableBackDropClick;
        _alert("This is your message!").show().then((final WskDialogStatus status) {
            statusMessage = "closed AlertDialog with status: ${status}";
        });
    }

    void openAlertDialogWithTitle() {
        _logger.info("openAlertDialogWithTitle");

        _alert.config.acceptEscToClose = enableEsc;
        _alert.config.closeOnBackDropClick = enableBackDropClick;
        _alert("You can specify some description text in here.",
            title: "This is an alert title", okButton: "Got it!").show().then((final WskDialogStatus status) {
            statusMessage = "closed AlertDialog with status: ${status}";
        });
    }

    void openConfirmDialog() {
        _logger.info("openConfirmDialog");

        _confirm.config.acceptEscToClose = enableEsc;
        _confirm.config.closeOnBackDropClick = enableBackDropClick;
        _confirm("All of the banks have agreed to forgive you your debts.",
            title: "Would you like to delete your debt?",
            yesButton: "Do it!", noButton: "No, it's a scam").show().then((final WskDialogStatus status) {
            statusMessage = "closed ConfirmDialog with status: ${status}";
        });
    }

    void openCustomDialog() {
        _logger.info("openCustomDialog");

        _customDialog.config.acceptEscToClose = enableEsc;
        _customDialog.config.closeOnBackDropClick = enableBackDropClick;
        _customDialog("3All of the banks have agreed to forgive you your debts.",
        title: "Mango #${mangoCounter} (Fruit)",
        yesButton: "I buy it!", noButton: "Not now").show().then((final WskDialogStatus status) {
            statusMessage = "closed CustomDialog with status: ${status}";
            mangoCounter++;
        });
    }

}

 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskCheckboxModule());
        install(new WskButtonModule());

        install(new WskDialogModule());

        install(new CustomDialogModule());

        bind(AppController);

        // -- controllers

        // -- services

        // -- decorator

        //factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false));
    }
}

 /// Entry point into app.
main() {
    configLogger();
    applicationFactory().addModule(new SampleModule()).rootContextType(AppController).run();
}


    // Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference
void configLogger() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.FINE;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}