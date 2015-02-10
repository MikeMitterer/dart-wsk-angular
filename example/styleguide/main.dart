library wsk_angular.example.styleguide;

import 'dart:html' as html;

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

@Injectable()
class AppController {
    final _logger = new Logger('wsk_angular.example.styleguide.AppController');

    final Router _router;
    final String _classToChange = "active";

    @NgOneWay('name') // only for demonstration!!!
    String get name {
        String name = "Material Design";
        if(_router.activePath.length > 0) {
            name = _router.activePath[0].name;
        }
        return name;
    }

    AppController(this._router) {
        _logger.fine("AppController");
    }

    bool isActive(final String link) {
        //_logger.fine("Location: ${_router.activePath[0].name} : Link: $link");
        return link != null && _router.activePath[0].name == link;
    }

    void handleEvent(final html.Event e) {
        _logger.info("Event: handleEvent");
    }

    // Checkboxes
    bool checkOne = false;
    dynamic checkTwo = false;
    bool checkThree = false;
}

void myRouteInitializer(Router router, RouteViewFactory view) {
    // @formatter:off
    router.root
        ..addRoute(

            name: "home",
            path: "/home",
            //enter: view("views/first.html"),
            defaultRoute: true,

            mount: (Route route) => route
                ..addRoute(
                    defaultRoute: true,
                    name: 'home',
                    path: '/home',
                    enter: view('views/home.html'))
                ..addRoute(
                    name: 'firstsub',
                    path: '/sub',
                    enter: view('views/firstsub.html'))
        )
        ..addRoute(
            name: "button",
            path: "/button",
            enter: view("views/button.html")
        )

        ..addRoute(
           name: "typography",
            path: "/typography",
            enter: view("views/typography.html")
        )

        ..addRoute(
           name: "animation",
            path: "/animation",
            enter: view("views/animation.html")
        )

        ..addRoute(
            name: "tabs",
            path: "/tabs",
            enter: view("views/tabs.html")

        )
            ..addRoute(
            name: "cards",
            path: "/cards",
            enter: view("views/cards.html")
        )
            ..addRoute(
            name: "checkbox",
            path: "/checkbox",
            enter: view("views/checkbox.html")
        )

            ..addRoute(
            name: "dropdown",
            path: "/dropdown",
            enter: view("views/dropdown.html")

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