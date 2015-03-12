library wsk_angular.pretty_print;

import 'dart:html' as html;

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

import 'package:prettify/prettify.dart';

/**
 * PrettyPrintModule Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class PrettyPrintModule extends Module {
    PrettyPrintModule() {

        bind(PrettyPrintComponent);

        //- Services ---------------------------
    }
}

@Decorator( selector: '[pretty-print]' )
class PrettyPrintComponent implements ScopeAware, AttachAware {

    final html.Element _component;
    final ViewFactoryCache viewFactoryCache;
    final DirectiveInjector directiveInjector;
    final DirectiveMap directives;

    Scope scope;

    View _view;
    Scope _childScope;

    PrettyPrintComponent(final html.Element component, this.viewFactoryCache,
              this.directiveInjector, this.directives) : _component = component {
        Validate.notNull(component);
    }

    @NgAttr("url")
    set url(value) {
        _cleanUp();
        if (value != null && value != '') {
            viewFactoryCache.fromUrl(value, directives, Uri.base).then(_updateContent);
        }
    }

    @override
    void attach() {
        if(!_component.attributes.containsKey("url")) {
            prettyPrint();
        }
    }

    // - private ----------------------------------------------------------------------------------

    _cleanUp() {
        if (_view == null) return;
        _view.nodes.forEach((node) => node.remove);
        _childScope.destroy();
        _childScope = null;
        _component.innerHtml = '';
        _view = null;
    }

    _updateContent(ViewFactory viewFactory) {
        // create a new scope
        _childScope = scope.createProtoChild();
        _view = viewFactory(_childScope, directiveInjector);
        _view.nodes.forEach((node) => _component.append(node));

        prettyPrint();
    }
}