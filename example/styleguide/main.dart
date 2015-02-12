library wsk_angular.example.styleguide;

import 'dart:html' as html;
import 'dart:math' as Math;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

//import 'package:webapp_base_ui_angular/angular/decorators/flexbox_navi_handler.dart';
//import 'package:webapp_base_ui_angular/angular/decorators/navbaractivator.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

// Activates menu
import 'package:wsk_angular/decorators/navactivator.dart';

// Components
import 'package:wsk_angular/wsk_layout/wsk_layout.dart';
import 'package:wsk_angular/wsk_button/wsk_button.dart';
import 'package:wsk_angular/wsk_tabs/wsk_tabs.dart';
import 'package:wsk_angular/wsk_animation/wsk_animation.dart';
import 'package:wsk_angular/wsk_checkbox/wsk_checkbox.dart';
import 'package:wsk_angular/wsk_radio/wsk_radio.dart';
import 'package:wsk_angular/wsk_icon_toggle/wsk_icon_toggle.dart';
import 'package:wsk_angular/wsk_item/wsk_item.dart';
import 'package:wsk_angular/wsk_slider/wsk_slider.dart';

class _SimpleModel {
    final Map<String,dynamic> _model = new Map<String,dynamic>();

    dynamic operator[](final String key) {
        if(_model.containsKey(key)) {
            return _model[key];
        }
        return 0;
    }

    void operator[]=(final String key,final dynamic value) {
        _model[key] = value;
    }
}

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.styleguide.AppController');

    final Router _router;
    final String _classToChange = "active";

    final _SimpleModel model = new _SimpleModel();

    AppController(this._router) {
        _logger.fine("AppController");

        radioData.add(new _RadioData("Lable I","value1",false));
        radioData.add(new _RadioData("Lable II","value2",false));
        radioData.add(new _RadioData("Lable III","value3",true));
        radioData.add(new _RadioData("Lable IV","value4",false));
    }

    String get name {
        String name = "Material Design";
        if (_router.activePath.length > 0) {
            name = _router.activePath[0].name;
        }
        return name;
    }

    void handleEvent(final html.Event e) {
        _logger.info("Event: handleEvent");
    }

    // - Checkboxes ----------------------------------------------------------------------------------------------------
    bool checkOne = false;
    dynamic checkTwo = false;
    bool checkThree = false;

    // - Icon-Toggle ---------------------------------------------------------------------------------------------------
    bool toggleOne = false;
    dynamic toggleTwo = false;
    bool toggleThree = false;
    bool toggleChevron = false;

    // - Radio-Sample --------------------------------------------------------------------------------------------------
    String groupOne;
    String groupTwo = "Never";
    String groupThree;
    String groupAvatar;
    List<_RadioData> radioData = new List<_RadioData>();

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

    //  Slider Sample --------------------------------------------------------------------------------------------------
    int _activeColor = 0;

    int colorRed = 45;
    int colorGreen = 147;
    int colorBlue = 59;

    String get redAsHex => colorRed.toRadixString(16).padLeft(2,"0");
    String get greenAsHex => colorGreen.toRadixString(16).padLeft(2,"0");
    String get blueAsHex => colorBlue.toRadixString(16).padLeft(2,"0");

    String get asHex => "#${redAsHex}${greenAsHex}${blueAsHex}";

    final _Color color = new _Color();

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

/// Radio-Sample-Data
class _RadioData {
    final String label;
    final String value;
    bool isDisabled;

    _RadioData(this.label, this.value, this.isDisabled);
}

/// Slider-Sample-Data
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

void myRouteInitializer(Router router, RouteViewFactory view) {
    // @formatter:on
    router.root
        ..addRoute(

        defaultRoute: true, name: "home", path: "/home", //enter: view("views/first.html"),

            mount: (Route route) => route
                ..addRoute(
                defaultRoute: true, name: 'home', path: '/home', enter: view('views/home.html'))

                ..addRoute(name: 'firstsub', path: '/sub', enter: view('views/firstsub.html'))
        )
        ..addRoute(name: "button", path: "/button", enter: view("views/button.html"))

        ..addRoute(name: "typography", path: "/typography", enter: view("views/typography.html"))

        ..addRoute(name: "list", path: "/list", enter: view("views/list.html"))

        ..addRoute(name: "animation", path: "/animation", enter: view("views/animation.html"))

        ..addRoute(name: "tabs", path: "/tabs", enter: view("views/tabs.html"))

        ..addRoute(name: "cards", path: "/cards", enter: view("views/cards.html"))

        ..addRoute(name: "checkbox", path: "/checkbox", enter: view("views/checkbox.html"))

        ..addRoute(name: "radio", path: "/radio", enter: view("views/radio.html"))

        ..addRoute(name: "dropdown", path: "/dropdown", enter: view("views/dropdown.html"))

        ..addRoute(name: "icon-toggle", path: "/icon-toggle", enter: view("views/icon-toggle.html"))

        ..addRoute(name: "item", path: "/item", enter: view("views/item.html"))

        ..addRoute(name: "pallet", path: "/pallet", enter: view("views/pallet.html"))

        ..addRoute(name: "slider", path: "/slider", enter: view("views/slider.html"))

        ..addRoute(name: "shadow", path: "/shadow", enter: view("views/shadow.html"))

        ..addRoute(name: "footer", path: "/footer", enter: view("views/footer.html")

    );
    // @formatter:on
}

class SampleModule extends Module {
    SampleModule() {
        bind(RouteInitializerFn, toValue: myRouteInitializer);

        bind(AppController);

        // Activate / deactivate menu
        bind(NavActivator);

        // Components
        install(new WskLayoutModule());
        install(new WskTabsModule());
        install(new WskButtonModule());
        install(new WskAnimationModule());
        install(new WskCheckboxModule());
        install(new WskRadioModule());
        install(new WskIconToggleModule());
        install(new WskItemModule());
        install(new WskSliderModule());

        bind(NgRoutingUsePushState, toFactory: () => new NgRoutingUsePushState.value(false));
    }
}

void main() {
    configLogger();
    applicationFactory().addModule(new SampleModule()).rootContextType(AppController).run();
    //applicationFactory().addModule(new SampleModule()).run();
}

//// Weitere Infos: https://github.com/chrisbu/logging_handlers#quick-reference
void configLogger() {
    //hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

    // now control the logging.
    // Turn off all logging first
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen(new LogConsoleHandler());
}