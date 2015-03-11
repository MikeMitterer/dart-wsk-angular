library wsk_angular.example.wsk_toast;

import "dart:html" as html;
import "dart:async";
import "dart:js" as js;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import "package:validate/validate.dart";
import 'package:wsk_angular/wsk_button/wsk_button.dart';
import 'package:wsk_angular/wsk_toast/wsk_toast.dart';


@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_toast.AppController');

    int _messageCounter = 1;
    final WskToast wskToast;

    AppController(this.wskToast) {
        Validate.notNull(wskToast);

        _logger.info("AppController");

    }

    //-----------------------------------------------------------------------------
    // private

    void showSimpleToast() {
        wskToast("Message #${_messageCounter++}",confirmButton: "OK").show().then((final WskDialogStatus status) {
            _logger.info("Status: $status");
        });

//        wskToast("Message #${_messageCounter++}").show().then((final WskDialogStatus status) {
//            _logger.info("Status: $status");
//        });
    }
}


class SampleModule extends Module {
    SampleModule() {
        install(new WskButtonModule());
        install(new WskToastModule());

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
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}

