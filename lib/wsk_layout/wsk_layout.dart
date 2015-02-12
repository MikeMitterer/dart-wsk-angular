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

        bind(WskLayoutHeaderComponent);
        bind(WskHeaderRowComponent);
        bind(WskLayoutTabBarComponent);
        bind(WskTabPanelComponent);
        bind(WskLayoutTabComponent);
        bind(WskLayoutContentComponent);

        bind(WskDrawerComponent);

        //- Services ---------------------------
    }
}

/// LayoutComponent
@Component(selector: 'wsk-layout', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_layout/wsk_layout.html')
class WskLayoutComponent extends WskAngularComponent {
    final _logger = new Logger('wsk_anuglar.wsk_layout.LayoutComponent');

    final html.Element _component;

    WskLayoutComponent(final html.Element component)
        : super(component, materialLayoutConfig(), [ WmaterialRippleConfig() ]),
        this._component = component {
        Validate.notNull(component);
    }

    @NgAttr("drawer")
    String drawer = "";

    @NgAttr("header")
    String header = "";

    @NgAttr("tabs")
    String tabs = "";

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

    @NgOneWay("isTabsFixed")
    bool get isTabsFixed => (tabs != null && tabs != "" && (tabs == "fixed" || tabs == "fix"));

}

/// HeaderComponent
@Decorator(selector: 'wsk-layout-header')
class WskLayoutHeaderComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskHeaderComponent');

    final html.Element _component;

    WskLayoutHeaderComponent(this._component) {
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

/// WskHeaderRowComponent
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

/// WskTabBarComponent
@Decorator(selector: 'wsk-layout-tab-bar')
class WskLayoutTabBarComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskTabBarComponent');

    html.Element _component;

    WskLayoutTabBarComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__tab-bar");
        _component.classes.add("wsk-js-ripple-effect");
    }
}

@Decorator(selector: 'wsk-layout-tab')
class WskLayoutTabComponent extends WskAngularComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskLayoutTabComponent');

    final html.Element _component;

    WskLayoutTabComponent(final html.Element component)
        : super(component,materialRippleConfig(),[],false), _component = component {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__tab");
//        _component.classes.add("wsk-js-ripple-effect");

        upgrade();
    }
}

/// WskTabPanelComponent
@Decorator(selector: 'wsk-layout-tab-panel')
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

/// WskLayoutContentComponent
@Decorator(selector: 'wsk-layout-content')
class WskLayoutContentComponent implements AttachAware {
    final _logger = new Logger('wsk_anuglar.wsk_layout.WskLayoutContentComponent');

    final html.Element _component;

    WskLayoutContentComponent(this._component) {
        Validate.notNull(_component);
    }

    attach() {
        _component.classes.add("wsk-layout__content");
    }
}


/// WskDrawerComponent
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
