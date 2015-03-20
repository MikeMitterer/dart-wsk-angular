library wsk_angular.example.wsk_badge;

import 'dart:html' as html;
import "dart:math" as Math;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_badge/wsk_badge.dart';

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_badge.AppController');

    AppController() {
        _logger.fine("AppController");
    }

    String tooltipText = "Simple tooltip";
}


 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskBadgeModule());

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