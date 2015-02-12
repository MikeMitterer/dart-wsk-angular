library wsk_angular.example.wsk_checkbox;

import 'dart:html' as html;
import "dart:math" as Math;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/wsk_slider/wsk_slider.dart';

class _Color {
    final List<String> _colors = new List<String>();

    _Color() {
        _colors.add("#123456");  // 00C4B3
        _colors.add("#22D3C5");
        _colors.add("#0075C9");
        _colors.add("#0075C9");
        _colors.add("#00A8E1");
        _colors.add("#00C4B3");
    }

    String operator [](int index) => _colors[Math.max(0,Math.min(5,index))];
    void operator []=(int index,final String value) { _colors[Math.max(0,Math.min(5,index))] = value; }
}

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.wsk_checkbox.AppController');

    int _activeColor = 0;

    int colorRed = 45;
    int colorGreen = 147;
    int colorBlue = 59;

    String get redAsHex => colorRed.toRadixString(16).padLeft(2,"0");
    String get greenAsHex => colorGreen.toRadixString(16).padLeft(2,"0");
    String get blueAsHex => colorBlue.toRadixString(16).padLeft(2,"0");

    String get asHex => "#${redAsHex}${greenAsHex}${blueAsHex}";

    final _Color color = new _Color();

    AppController() {
        _logger.fine("AppController");
    }

    void colorChanged() {
        color[_activeColor] = asHex;
    }

    void activateColor(final int index) {
        final String currentColor = color[index];
        _logger.fine("CC $currentColor ${currentColor.substring(1,3)},${currentColor.substring(3,5)},${currentColor.substring(5)}");

        colorRed   = int.parse(currentColor.substring(1,3),radix: 16);
        colorGreen = int.parse(currentColor.substring(3,5),radix: 16);
        colorBlue  = int.parse(currentColor.substring(5),radix: 16);

        _activeColor = index;
    }
}


 /// Demo Module
class SampleModule extends Module {
    SampleModule() {
        install(new WskSliderModule());

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