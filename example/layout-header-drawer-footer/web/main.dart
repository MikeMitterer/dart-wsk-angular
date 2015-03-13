library wsk_angular.example.layout_header_drawer_footer;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/decorators/scrollshadow.dart';
import 'package:wsk_angular/wsk_layout/wsk_layout.dart';


/**
 * Entry point into app.
 */
main() {
    configLogger();
    applicationFactory().addModule(new SampleModule()).run();
}

/**
 * Demo Module
 */
class SampleModule extends Module {
    SampleModule() {
        bind(ScrollShadow);

        install(new WskLayoutModule());

        // -- controllers

        // -- services

        // -- decorator

        //factory(NgRoutingUsePushState, (_) => new NgRoutingUsePushState.value(false));
    }
}

// Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference
void configLogger() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}