library wsk_angular.example.wsk_accordion;

import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_accordion/wsk_accordion.dart';
//import 'package:wsk_angular/wsk_checkbox/wsk_checkbox.dart';
//import 'package:wsk_angular/wsk_button/wsk_button.dart';

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_accordion.AppController');

    AppController() {
        _logger.fine("AppController");
    }

    int rating = 1;
    void setRating(final html.Event event,final int rating) {
        event.stopPropagation();
        event.preventDefault();
        this.rating = rating;
    }
}


 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskAccordionModule());

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