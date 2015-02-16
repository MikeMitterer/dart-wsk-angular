library wsk_angular.example.wsk_textfield;

import 'dart:html' as html;
import "dart:math" as Math;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_textfield/wsk_textfield.dart';
import 'package:wsk_angular/wsk_checkbox/wsk_checkbox.dart';
import 'package:wsk_angular/wsk_button/wsk_button.dart';


@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_textfield.AppController');

    AppController() {
        _logger.fine("AppController");
    }

    bool disableInputField = true;
    void onSubmit(final html.Event event) {
        event.preventDefault();
        //_logger.info(event.target);
        final html.FormElement form = html.document.querySelector("form");
        if(form != null) {
            final Map<String,String> data = new Map<String,String>();

            // Form elements to extract {name: value} from
            final String formElementSelectors = "select, input, button, textarea";
            form.querySelectorAll(formElementSelectors).forEach((final html.HtmlElement element) {
                if(element is html.InputElement) {
                    data[element.attributes["name"]] = (element as html.InputElement).value;

                } else if(element is html.TextAreaElement) {
                    data[element.attributes["name"]] = (element as html.TextAreaElement).value;
                }

            });

            _logger.info("FormData: $data");
        }
    }
}


 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskTextfieldModule());
        install(new WskCheckboxModule());
        install(new WskButtonModule());

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