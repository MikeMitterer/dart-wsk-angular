library wsk_angular.example.wsk_radio;

import 'dart:html' as html;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_radio/wsk_radio.dart';
import 'package:wsk_angular/wsk_button/wsk_button.dart';

class _RadioData {
    final String label;
    final String value;
    bool isDisabled;

    _RadioData(this.label, this.value, this.isDisabled);
}

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_radio.AppController');

    final Router _router;
    final String _classToChange = "active";

    String groupOne;
    String groupTwo = "Never";
    String groupThree;
    String groupAvatar;
    List<_RadioData> radioData = new List<_RadioData>();

    AppController() {
        _logger.fine("AppController");
        radioData.add(new _RadioData("Lable I","value1",false));
        radioData.add(new _RadioData("Lable II","value2",false));
        radioData.add(new _RadioData("Lable III","value3",true));
        radioData.add(new _RadioData("Lable IV","value4",false));
    }

    void addRadioData(final html.Event e) {
        _logger.fine("Event: addRadioData");
        final DateTime datetime = new DateTime.now();
        final String timeLabel = "${datetime.hour}:${datetime.minute}:${datetime.second}";
        final String timeValue = "${datetime.hour}:${datetime.minute}:${datetime.second}.${datetime.millisecond}";
        radioData.add(new _RadioData(timeLabel,timeValue,false));
    }

    void removeRadioData(final html.Event e) {
        _logger.fine("Event: removeRadioData");
        if(radioData.length > 0) {
            radioData.removeLast();
        }
    }
}


 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskRadioModule());
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