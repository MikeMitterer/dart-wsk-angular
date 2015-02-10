library wsk_angular.example.wsk_checkbox;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_icon_toggle/wsk_icon_toggle.dart';

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_checkbox.AppController');

    final Router _router;
    final String _classToChange = "active";

    bool toggleOne = false;
    dynamic toggleTwo = false;
    bool toggleThree = false;

    AppController() {
        _logger.fine("AppController");
    }
}


 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskIconToggleModule());

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
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}