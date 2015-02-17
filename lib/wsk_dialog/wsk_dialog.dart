library wsk_angular.wsk_dialog;

import 'dart:html' as html;
import 'dart:async';

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _WskDialogCssClasses {

    final String WSK_DIALOG_CONTAINER = 'wsk-dialog--container';
    final String IS_VISIBLE = 'is-visible';

    const _WskDialogCssClasses();
}

/**
 * WskDialog Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskDialogModule extends Module {
    WskDialogModule() {
        bind(WskDialogComponent);
        bind(WskDialog);
        bind(WskAlertDialog);

        //- Services ---------------------------
    }
}

/// WskDialogComponent
@Component(selector: 'wsk-dialog-xx', useShadowDom: false, templateUrl: 'packages/wsk_angular/wsk_dialog/wsk_dialog.html')
class WskDialogComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_dialog.WskDialogComponent');

    final html.Element _component;

    WskDialogComponent(final html.Element component) : _component = component {
        Validate.notNull(component);
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}

html.Element _createDialogElementFromString(final String htmlString) {
    Validate.notBlank(htmlString);

    final html.HtmlElement baseElement = new html.DivElement();
    baseElement.setInnerHtml(htmlString, treeSanitizer: new NullTreeSanitizer());

    final List<html.Node> nodes = new List<html.Node>();
    for(final html.Node node in baseElement.nodes) {
        if(node is html.Element) {
            if( (node as html.Element).tagName.toLowerCase() == WskDialog.TAG ) {
                return node as html.Element;
            }
        }
    }
    throw new ArgumentError("Could not find <${WskDialog.TAG}>...</${WskDialog.TAG}> in '$htmlString'!");
}

final Logger _logger = new Logger('wsk_angular.wsk_dialog._waitForComponentToLoad');
Future<html.HtmlElement> _waitForComponentToLoad(final String selector,{ Completer completer, html.Element parent, final int inMilliSeconds: 10,final int TIMEOUT_IN_MS: 1000 } ) {
    Validate.notBlank(selector);

    if(completer == null) {
        completer = new Completer<html.HtmlElement>();
    }
    if(parent == null) {
        parent = html.document.querySelector("body");
    }

    if (inMilliSeconds >= TIMEOUT_IN_MS) {
        throw new TimeoutException("Could not find an element with: ${selector} as selector!");
    }

    _logger.finer("Next check for component - in: ${inMilliSeconds}ms");
    new Future.delayed(new Duration(milliseconds: inMilliSeconds), () {
        _logger.finer(" - Selector: .${selector}");

        html.HtmlElement component = parent.querySelector(selector);
        if (component == null) {
            throw "Element with ${selector} not ready yet, try it again...";
        }
        _logger.fine("Found: $component with selector: ${selector}");
        return component;

    }).then( (final html.HtmlElement component) {
        completer.complete(component);

    }).catchError((_) {
        _waitForComponentToLoad(selector,completer: completer,parent: parent, inMilliSeconds: inMilliSeconds < 100 ? inMilliSeconds + 5 : inMilliSeconds * 2);
    });

    return completer.future;
}



/// WskDialog - Service
@Injectable()
abstract class WskDialog  {
    final Logger _logger = new Logger('wsk_angular.wsk_dialog.WskDialog');

    static const String TAG = "wsk-dialog";

    WskDialog() {
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
}

class _DialogElement {
    final Logger _logger = new Logger('wsk_angular.wsk_dialog._DialogElement');

    static const String _DEFAULT_PARENT = "body";
    static const _WskDialogCssClasses _cssClasses = const _WskDialogCssClasses();

    String _ID;
    html.Element _parent;
    html.Element _dialog;
    html.DivElement _container;
    String _containerSelector;

    _DialogElement.fromString(final String htmlString) {
        Validate.notBlank(htmlString);

        _parent = html.document.querySelector(_DEFAULT_PARENT);
        _ID = "dialog${hashCode.toString()}";
        _containerSelector = "#${_ID}.${_cssClasses.WSK_DIALOG_CONTAINER}";

        _dialog = _createDialogElementFromString(htmlString);
        _container = _wrapInContainer(_dialog);
        _container.attributes["id"] = _ID;
    }

    void show() {
        if(_parent.querySelector(_containerSelector) == null) {
            _parent.append(_container);
        }
        _waitForComponentToLoad(_containerSelector).then((_) {
            _container.classes.add(_cssClasses.IS_VISIBLE);
        });
    }

    void hide() { _container.classes.remove(_cssClasses.IS_VISIBLE); }

    void dismiss() {
        final html.Element container = _parent.querySelector(_containerSelector);
        _logger.info("Selector ${_containerSelector} brought: $container");
        if(container != null) {
            container.remove();
            _logger.info("Container removed!");
        }
    }
    // - private ----------------------------------------------------------------------------------

    html.DivElement _wrapInContainer(final html.Element dialog) {
        Validate.notNull(dialog);

        final html.DivElement container = new html.DivElement();
        container.classes.add(_cssClasses.WSK_DIALOG_CONTAINER);
//        container.onClick.listen( ( final html.MouseEvent event) {
//            _logger.info("click on container");
//            event.preventDefault();
//            event.stopPropagation();
//            if(event.target == container) {
//                //hide();
//                dismiss();
//            }
//        });

        container.append(dialog);
        return container;
    }

}

//@Component(selector: "wsk-alert-dialog",useShadowDom: false)
@Injectable()
class WskAlertDialog  {
    static _DialogElement _dialog;

    Scope scope;
    View view;
    Compiler _compiler;
    Injector _injector;
    DirectiveMap _directiveMap;
    Http _http;
    Scope _childScope;
    int counter = 0;
    Completer completer;

    WskAlertDialog(this._injector,this._compiler) {
        Validate.notNull(_injector);
        Validate.notNull(_compiler);

        //_directiveMap = _injector.getByKey(Injector.DIRECTIVE_MAP_KEY);
        //Validate.notNull(_directiveMap);
    }

    String get testmike => "Hallo Mike $counter";

    Future show() {
        if(_dialog == null) {
            _dialog = new _DialogElement.fromString(_createTemplate());
        }

        DirectiveMap _directiveMap = _injector.get(DirectiveMap);
        DirectiveInjector _directiveInjector = _injector.get(DirectiveInjector);
        _http = _injector.get(Http);
        Validate.notNull(_http);

        scope = _injector.get(Scope);

        Validate.notNull(_directiveMap);
        //Validate.notNull(_directiveInjector);

        ViewFactory viewFactory = _compiler.call([_dialog._dialog], _directiveMap); //(scope,_directiveInjector,[_dialog._dialog]);
        Validate.notNull(viewFactory);

        //_childScope = scope.createChild(scope.context);
        //_childScope = scope.createProtoChild();
        if (_childScope == null) {
            //_childScope.destroy();
            _childScope = scope.createChild(this);

            Validate.notNull(_dialog._dialog);
            //_childScope = scope.createChild(this);
            view = viewFactory.call(_childScope, null, [_dialog._dialog]);
        }

        _dialog.show();
        counter++;

        completer = null;
        completer = new Completer();
        return completer.future;
    }

    void hide() => _dialog.hide();

    void dismiss() {
        new Future( () {
            _dialog.dismiss();

            _childScope.destroy();
            _childScope = null;
            view = null;

            _dialog = null;

            completer.complete();
        });
    }

    void onClose(final html.Event event) {
        _logger.info("onClose");
        dismiss();
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------

    String _createTemplate() {
        return """
               <wsk-dialog>
                    <wsk-content>
                        <h2>This is an alert title</h2>
                        <p>You can >{{testmike}}< specify some description text in here.</p>
                    </wsk-content>
                    <div class="wsk-actions" layout="row">
                        <div class="button-block">
                            <wsk-button ng-click="onClose(\$event)">Got it!</wsk-button>
                        </div>
                    </div>
               </wsk-dialog>
               """.trim();
    }
}