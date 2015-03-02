library wsk_angular_styleguide;

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

// Services
import 'package:wsk_angular/services/LoadChecker.dart';

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
import 'package:wsk_angular/wsk_spinner/wsk_spinner.dart';
import 'package:wsk_angular/wsk_switch/wsk_switch.dart';
import 'package:wsk_angular/wsk_tooltip/wsk_tooltip.dart';
import 'package:wsk_angular/wsk_textfield/wsk_textfield.dart';

import 'package:wsk_angular/wsk_dialog/wsk_dialog.dart';
import 'package:wsk_angular_styleguide/custom_dialog/custom_dialog.dart';

import 'package:wsk_angular/wsk_accordion/wsk_accordion.dart';
import 'package:wsk_angular/wsk_dragdrop/wsk_dragdrop.dart';

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

    final _SimpleModel model = new _SimpleModel();
    void toggle(final String modelKey) { model[modelKey] = !model[modelKey];}

    AppController(this._router,this._alert,this._confirm,this._customDialog) {
        _logger.fine("AppController");

        radioData.add(new _RadioData("Lable I","value1",false));
        radioData.add(new _RadioData("Lable II","value2",false));
        radioData.add(new _RadioData("Lable III","value3",true));
        radioData.add(new _RadioData("Lable IV","value4",false));

        // Drag&Drop
        languages.add(new _Natural("English"));
        languages.add(new _Natural("German"));
        languages.add(new _Natural("Italian"));
        languages.add(new _Natural("French"));
        languages.add(new _Natural("Spanish"));

        languages.add(new _Programming("CPP"));
        languages.add(new _Programming("Dart"));
        languages.add(new _Programming("Java"));
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

    //  Slider Sample --------------------------------------------------------------------------------------------------
    bool activated = true;

    //  Switch Sample --------------------------------------------------------------------------------------------------
    bool toggleSwitch = false;
    bool flipText = false;

    //  Tooltip Sample --------------------------------------------------------------------------------------------------
    String tooltipText = "Simple tooltip";

    //  TextField Sample --------------------------------------------------------------------------------------------------
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

    //  Dialog Sample --------------------------------------------------------------------------------------------------

    final WskAlertDialog _alert;
    final WskConfirmDialog _confirm;
    final CustomDialog _customDialog;

    int mangoCounter = 0;
    String statusMessage = "";

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

    //  Accordion Sample -----------------------------------------------------------------------------------------------

    int rating = 1;
    void setRating(final html.Event event,final int rating) {
        event.stopPropagation();
        event.preventDefault();
        this.rating = rating;
    }

    //  Drag&Drop Sample -----------------------------------------------------------------------------------------------

    final List<_Language> languages = new List<_Language>();
    final List<_Language> natural = new List<_Language>();
    final List<_Language> programming = new List<_Language>();

    void addToProgrammingLanguages(final _Language language) {
        if(language.type == "programming") {
            if(!programming.contains(language)) {
                programming.add(language);
            }
        }
    }

    void addToNaturalLanguages(final _Language language) {
        if(language.type == "natural") {
            if(!natural.contains(language)) {
                natural.add(language);
            }
        }
    }

    void moveToTrash(final _Language language) {
        if(language.type == "programming" && programming.contains(language)) {
            programming.remove(language);

        } else if(language.type == "natural" && natural.contains(language)) {
            natural.remove(language);
        }
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

/// Drag&Drop-Sample-Data
class _Language {
    final String name;
    final String type;

    _Language(this.name, this.type);
}

class _Programming extends _Language {
    _Programming(final String name) : super(name,"programming");
}
class _Natural extends _Language {
    _Natural(final String name) : super(name,"natural");
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

        ..addRoute(name: "accordion", path: "/accordion", enter: view("views/accordion.html"))

        ..addRoute(name: "button", path: "/button", enter: view("views/button.html"))

        ..addRoute(name: "typography", path: "/typography", enter: view("views/typography.html"))

        ..addRoute(name: "list", path: "/list", enter: view("views/list.html"))

        ..addRoute(name: "animation", path: "/animation", enter: view("views/animation.html"))

        ..addRoute(name: "tabs", path: "/tabs", enter: view("views/tabs.html"))

        ..addRoute(name: "cards", path: "/cards", enter: view("views/cards.html"))

        ..addRoute(name: "checkbox", path: "/checkbox", enter: view("views/checkbox.html"))

        ..addRoute(name: "radio", path: "/radio", enter: view("views/radio.html"))

        ..addRoute(name: "dropdown", path: "/dropdown", enter: view("views/dropdown.html"))

        ..addRoute(name: "dialog", path: "/dialog", enter: view("views/dialog.html"))

        ..addRoute(name: "icon-toggle", path: "/icon-toggle", enter: view("views/icon-toggle.html"))

        ..addRoute(name: "item", path: "/item", enter: view("views/item.html"))

        ..addRoute(name: "pallet", path: "/pallet", enter: view("views/pallet.html"))

        ..addRoute(name: "slider", path: "/slider", enter: view("views/slider.html"))

        ..addRoute(name: "spinner", path: "/spinner", enter: view("views/spinner.html"))

        ..addRoute(name: "tooltip", path: "/tooltip", enter: view("views/tooltip.html"))

        ..addRoute(name: "textfield", path: "/textfield", enter: view("views/textfield.html"))

        ..addRoute(name: "shadow", path: "/shadow", enter: view("views/shadow.html"))

        ..addRoute(name: "switch", path: "/switch", enter: view("views/switch.html"))

        ..addRoute(name: "drag & drop", path: "/draganddrop", enter: view("views/draganddrop.html"))

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
        install(new WskSpinnerModule());
        install(new WskSwitchModule());
        install(new WskTooltipModule());
        install(new WskTextfieldModule());

        install(new WskDialogModule());
        install(new CustomDialogModule());

        install(new WskAccordionModule());
        install(new WskDragDropModule());

        // because the styleguide-app hides ng-view with class="angular-controlled" for preloading
        // we need a LoadChecker-Instance to remove the loadchecker-class from body.
        bind(LoadChecker, toValue: new LoadChecker());

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