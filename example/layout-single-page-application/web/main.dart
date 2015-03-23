library wsk_angular.example.layout_header_drawer_footer;

import 'dart:html' as dom;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:wsk_angular/decorators/scrollshadow.dart';
import 'package:wsk_angular/wsk_layout/wsk_layout.dart';
import 'package:wsk_angular/wsk_button/wsk_button.dart';
import 'package:wsk_angular/wsk_panel/wsk_panel.dart';
import 'package:wsk_angular/wsk_item/wsk_item.dart';

@Injectable()
class AppController {

    bool isDropDownVisible = false;

    final _logger = new Logger('wsk_angular.example.styleguide.AppController');

    AppController() {
        //_initEventHandlers();
    }

    // - private ----------------------------------------------------------------------------------

/*
    void _initEventHandlers() {
        final dom.HtmlElement content = dom.querySelector("wsk-layout-content");
        if(content != null) {
            content.onClick.listen((final MouseEvent event) {
                isDropDownVisible = false;
            });
        }
    }
*/
}

void myRouteInitializer(Router router, RouteViewFactory view) {
    // @formatter:on
    router.root
        ..addRoute(

        defaultRoute: true, name: "home", path: "/home", //enter: view("views/first.html"),

        mount: (Route route) => route
            ..addRoute(
            defaultRoute: true, name: 'home', path: '/home', enter: view('views/home.html'))

    )

        ..addRoute(name: "Page 1", path: "/page1", enter: view("views/page1.html"))

        ..addRoute(name: "Page 2", path: "/page2", enter: view("views/page2.html"))

        ..addRoute(name: "About", path: "/about", enter: view("views/about.html")

    );
    // @formatter:on
}

/**
 * Demo Module
 */
class SampleModule extends Module {
    SampleModule() {
        bind(RouteInitializerFn, toValue: myRouteInitializer);

        bind(ScrollShadow);

        install(new WskLayoutModule());
        install(new WskItemModule());
        install(new WskButtonModule());
        install(new WskItemModule());
        install(new WskPanelModule());

        // -- controllers

        // -- services

        // -- decorator

        bind(NgRoutingUsePushState, toFactory: () => new NgRoutingUsePushState.value(false));
    }
}


/**
 * Entry point into app.
 */
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