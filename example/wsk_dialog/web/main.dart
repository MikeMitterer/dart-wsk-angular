library wsk_angular.example.wsk_textfield;

import 'dart:html' as html;
import "dart:math" as Math;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_dialog/wsk_dialog.dart';
import 'package:wsk_angular/wsk_button/wsk_button.dart';

import 'package:wsk_angular_dialog_sample/custom_dialog/custom_dialog.dart';


@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_textfield.AppController');

    final WskAlertDialog _alert;
    final WskConfirmDialog _confirm;
    final CustomDialog _customDialog;

    int mangoCounter = 0;
    String statusMessage = "";

    AppController(this._alert,this._confirm,this._customDialog) {
        _logger.fine("AppController");
    }

    void openAlertDialog() {
        _logger.info("openAlertDialog");

        _alert("This is your message!").show().then((final WskDialogStatus status) {
            statusMessage = "closed AlertDialog with status: ${status}";
        });
    }

    void openAlertDialogWithTitle() {

        _logger.info("openAlertDialogWithTitle");

        _alert("You can specify some description text in here.",
            title: "This is an alert title", okButton: "Got it!").show().then((final WskDialogStatus status) {
            statusMessage = "closed AlertDialog with status: ${status}";
        });
    }

    void openConfirmDialog() {

        _logger.info("openConfirmDialog");

        _confirm("All of the banks have agreed to forgive you your debts.",
            title: "Would you like to delete your debt?",
            yesButton: "Please do it!", noButton: "Sounds like a scam").show().then((final WskDialogStatus status) {
            statusMessage = "closed ConfirmDialog with status: ${status}";
        });
    }

    void openCustomDialog() {

        _logger.info("openCustomDialog");

        _customDialog("3All of the banks have agreed to forgive you your debts.",
        title: "Mango #${mangoCounter} (Fruit)",
        yesButton: "Please do it!", noButton: "Sounds like a scam").show().then((final WskDialogStatus status) {
            statusMessage = "closed ConfirmDialog with status: ${status}";
            mangoCounter++;
        });
    }

}

 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskDialogModule());
        install(new WskButtonModule());

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