library wsk_anuglar.wsk_layout;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/**
 * Layout Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskLayoutModule extends Module {
    WskLayoutModule() {
        // install(new XYModule());

        bind(WskLayoutComponent);
        bind(WskHeaderComponent);
        bind(WskHeaderRowComponent);
        bind(WskDrawerComponent);
        bind(WskTabBarComponent);
        bind(WskTabBarComponent);

        //- Services ---------------------------
    }
}

/// LayoutComponent-Componente
@Component(selector: 'wsk-layout', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_layout/wsk_layout.html')
class WskLayoutComponent extends WskAngularComponent {
    final _logger = new Logger('wsk_anuglar.wsk_layout.LayoutComponent');

    final html.Element _component;

    WskLayoutComponent(final html.Element component)
        : super(component, materialLayoutConfig(), [ materialTextfieldConfig(), materialRippleConfig() ]),
        this._component = component {
        Validate.notNull(component);
    }

    @NgAttr("drawer")
    String drawer = "";

    @NgAttr("header")
    String header = "";

    @NgOneWay("isDrawerFixed")
    bool get isDrawerFixed => (drawer != null && drawer != "" && (drawer == "fixed" || drawer == "fix"));

    @NgOneWay("isHeaderFixed")
    bool get isHeaderFixed {
        final bool isFixed = (header != null && header != "" && (header == "fixed" || header == "fix"));

        /// per default overlay-drawer-button is active, ng-class does not work in this case
        void _removeDrawerButton() {
            final html.HtmlElement element =  _component.querySelector("wsk-layout");
            if(element != null ) {
                if(isFixed) {
                    element.classes.remove("wsk-layout--overlay-drawer-button");
                } else {
                    element.classes.add("wsk-layout--overlay-drawer-button");
                }
            }
        }

        _removeDrawerButton();
        return isFixed;
    }

    // - EventHandler -----------------------------------------------------------------------------

    /**
     * Sample:
     *     <button id="sendButton" name="sendButton" ng-click="handleEvent($event)">Send</button>
     */
    void handleEvent(final html.Event e) {
        _logger.fine("Event: handleEvent");
    }

    // - private ----------------------------------------------------------------------------------
}

/// HeaderComponent-Componente
@Decorator(selector: 'wsk-header')
class WskHeaderComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskHeaderComponent');

    final html.Element _component;

    WskHeaderComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__header");

        if(_component.attributes.containsKey("scroll")) {
            final String value = _component.attributes["scroll"];
            if(value == "true" || value == "yes") {
                _component.classes.add("wsk-layout__header--scroll");
            }
        }

        if(_component.querySelectorAll("wsk-header-row").length > 0) {
            _component.classes.add("wsk-layout__header--multi-row");
        }

        if(_component.attributes.containsKey("waterfall")) {
            _component.classes.add("wsk-layout__header--waterfall");
        }

        if(_component.attributes.containsKey("tall")) {
            _component.classes.add("wsk-layout__header--tall");
        }

        if(_component.attributes.containsKey("transparent")) {
            _component.classes.add("wsk-layout__header--transparent");
        }
    }

}

/// WskHeaderRowComponent-Componente
@Decorator(selector: 'wsk-header-row')
class WskHeaderRowComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskHeaderRowComponent');

    final html.Element _component;

    WskHeaderRowComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__header-row");
    }
}

/// WskTabBarComponent-Componente
@Decorator(selector: 'wsk-tab-bar')
class WskTabBarComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskTabBarComponent');

    final html.Element _component;

    WskTabBarComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__tab-bar");
        _component.classes.add("wsk-js-ripple-effect");

    }
}

/// WskTabBarComponent-Componente
@Decorator(selector: 'wsk-tab-panel')
class WskTabPanelComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskTabPanelComponent');

    final html.Element _component;

    WskTabPanelComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__tab-panel");
    }
}


/// WskDrawerComponent-Componente
@Decorator(selector: 'wsk-drawer')
class WskDrawerComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskDrawerComponent');

    final html.Element _component;

    WskDrawerComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__drawer");
    }

}
