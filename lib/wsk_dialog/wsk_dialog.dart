library wsk_angular.wsk_dialog;

import 'dart:html' as html;
import 'dart:async';

import "package:angular/angular.dart";
import 'package:angular/core/annotation_src.dart';

import 'package:logging/logging.dart';
import 'package:validate/validate.dart';

import 'package:wsk_material/wskcomponets.dart';
import 'package:wsk_angular/wsk_angular.dart';

part "utils.dart";

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _WskDialogCssClasses {

    final String WSK_DIALOG_CONTAINER = 'wsk-dialog--container';
    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN = 'is-hidden';

    const _WskDialogCssClasses();
}

/**
 * WskDialog Module.
 *    Weitere Infos: https://docs.angulardart.org/#di.Module
 */
class WskDialogModule extends Module {
    WskDialogModule() {

        bind(WskAlertDialog);

        //- Services ---------------------------
    }
}

enum WskDialogStatus { CLOSED_BY_ESC, CLOSED_BY_BACKDROPCLICK, OK }

class DialogElement {
    final Logger _logger = new Logger('wsk_angular.wsk_dialog._DialogElement');

    static const String _DEFAULT_PARENT = "body";
    static const _WskDialogCssClasses _cssClasses = const _WskDialogCssClasses();

    /// usually the html body
    html.Element _parent;

    /// represents the <wsk-dialog> tag
    html.Element _wskDialogElement;

    /// Wraps wskDialogElement. Darkens the background and
    /// is used for backdrop click
    html.DivElement _wskDialogContainer;

    /// unique ID for dialog-wrapper
    String _containerID;

    /// identifies the container
    String _containerSelector;

    /// Informs about open and close actions
    Completer<WskDialogStatus> _completer;

    /// Listens to Keyboard-Events
    StreamSubscription _keyboardEventSubscription;

    final bool _acceptEscToClose;

    DialogElement.fromString(final String htmlString, { final bool closeDialogOnBackDropClick: true,
        final bool acceptEscToClose: true }) : _acceptEscToClose = acceptEscToClose {

        Validate.notBlank(htmlString);

        _containerID = "dialog${hashCode.toString()}";
        _containerSelector = "#${_containerID}.${_cssClasses.WSK_DIALOG_CONTAINER}";

        _parent = html.document.querySelector(_DEFAULT_PARENT);

        _wskDialogElement = _createDialogElementFromString(htmlString);
        _wskDialogContainer = _wrapInContainer(_wskDialogElement);
        if(closeDialogOnBackDropClick) {
            _addBackDropClickListener(_wskDialogContainer);
        }

        _wskDialogContainer.attributes["id"] = _containerID;
        _wskDialogContainer.classes.add(_cssClasses.IS_HIDDEN);
    }

    void show(final Completer<WskDialogStatus> completer) {
        Validate.notNull(completer);
        Validate.isTrue(!completer.isCompleted);
        Validate.isTrue(_completer == null || _completer.isCompleted);

        _completer = completer;

        if (_parent.querySelector(_containerSelector) == null) {
            _parent.append(_wskDialogContainer);
        }
        _waitForComponentToLoad(_containerSelector).then((_) {
            _wskDialogContainer.classes.remove(_cssClasses.IS_HIDDEN);
            _wskDialogContainer.classes.add(_cssClasses.IS_VISIBLE);
        });

        if(_acceptEscToClose) {
            _addEscListener();
        }
    }

    void close(final WskDialogStatus status) {
        _removeEscListener();
        hide(status);
    }

    void hide(final WskDialogStatus status) {
        _wskDialogContainer.classes.remove(_cssClasses.IS_VISIBLE);
        _wskDialogContainer.classes.add(_cssClasses.IS_HIDDEN);

        _complete(status);
    }

    void destroy(final WskDialogStatus status) {
        final html.Element container = _parent.querySelector(_containerSelector);
        _logger.info("Selector ${_containerSelector} brought: $container");

        if (container != null) {
            container.remove();
            _logger.info("Container removed!");
        }
        _complete(status);
    }

    // - private ----------------------------------------------------------------------------------

    html.DivElement _wrapInContainer(final html.Element dialog) {
        Validate.notNull(dialog);

        final html.DivElement container = new html.DivElement();
        container.classes.add(_cssClasses.WSK_DIALOG_CONTAINER);

        container.append(dialog);
        return container;
    }

    void _addBackDropClickListener(final html.DivElement container) {
        container.onClick.listen((final html.MouseEvent event) {
            _logger.info("click on container");

            event.preventDefault();
            event.stopPropagation();

            if (event.target == container) {
                close(WskDialogStatus.CLOSED_BY_BACKDROPCLICK);
            }
        });
    }

    void _addEscListener() {
        _keyboardEventSubscription = html.document.onKeyDown.listen( (final html.KeyboardEvent event) {
            event.preventDefault();
            event.stopPropagation();

            if(event.keyCode == 27) {
                close(WskDialogStatus.CLOSED_BY_ESC);
            }
        });
    }

    void _complete(final WskDialogStatus status) {
        //Validate.notNull(_completer);
        //Validate.isTrue(_completer.isCompleted == false);
        if(_completer == null) {
            _logger.fine("Completer is null - Status to inform the caller is: $status");
            return;
        }

        if(!_completer.isCompleted) {
            _completer.complete(status);
        }
        _completer = null;
    }

    void _removeEscListener() {
        if(_keyboardEventSubscription != null) {
            _keyboardEventSubscription.cancel();
            _keyboardEventSubscription = null;
        }
    }
}

abstract class WskDialog {
    final Logger _logger = new Logger('wsk_angular.wsk_dialog.WskDialog');

    /// DialogElement in your DOM-Tree
    DialogElement _dialogElement;

    /// identifies the Template.
    ///     @Component(selector: <directiveSelector>, templateUrl: ...)
    final String _directiveSelector;

    /// {_injector} returns all the necessary Objects to compile the Scope
    /// into the template
    Injector _injector;

    Scope _childScope;

    /// Informs the caller about the dialog status
    Completer<WskDialogStatus> _openCompleter;

    WskDialog(this._directiveSelector) {
        Validate.notBlank(_directiveSelector);
    }

    /// Must be set in Child-CTOR.
    /// Can't be set in automatically via super-param (in Child) is always null if set from super
    void set injector(final Injector injectorObject) {
        Validate.notNull(injectorObject);
        _injector = injectorObject;
    }

    Future<WskDialogStatus> show() {

        final DirectiveMap directiveMap = _injector.get(DirectiveMap);
        Validate.notNull(directiveMap);

        final TemplateCache templateCache = _injector.get(TemplateCache);
        Validate.notNull(templateCache);

        final Http http = _injector.get(Http);
        Validate.notNull(http);

        _openCompleter = null;
        _openCompleter = new Completer<WskDialogStatus>();

        final String url = _getTemplateUrl(directiveMap);
        http.get(url, cache: templateCache).then( (final HttpResponse response) {
            Validate.notNull(response);
            Validate.notBlank(response.data);

            _createDialogElement(response.data);
            _compileScopeIntoHtmlElement(_dialogElement._wskDialogElement);

            _dialogElement.show(_openCompleter);
        });

        return _openCompleter.future;
    }

    void close(final WskDialogStatus status) {
       _destroy(status);

    }
    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------

    void _hide(final WskDialogStatus status) {
        _dialogElement.hide(status);
    }

    void _destroy(final WskDialogStatus status) {
        new Future(() {
            _dialogElement.destroy(status);

            _childScope.destroy();
            _childScope = null;

            _dialogElement = null;
        });
    }

    String _getTemplateUrl(final DirectiveMap directiveMap) {
        Validate.notNull(directiveMap);

        // is List<DirectiveTypeTuple>
        final tuples = directiveMap[_directiveSelector];
        Validate.isTrue(tuples[0].directive is Component);

        Component annotation = tuples[0].directive;
        Validate.notBlank(annotation.templateUrl,"WskDialogXX must have a templateUrl!");

        _logger.fine("TemplateUrl for ${_directiveSelector}: ${annotation.templateUrl}");

        return annotation.templateUrl;
    }

    void _createDialogElement(final String template) {
        Validate.notBlank(template);

        if (_dialogElement == null) {
            _dialogElement = new DialogElement.fromString(template);
        }
    }

    void _compileScopeIntoHtmlElement(final html.Element dialog) {
        final Compiler compiler = _injector.get(Compiler);
        Validate.notNull(compiler);

        final DirectiveMap directiveMap = _injector.get(DirectiveMap);
        Validate.notNull(directiveMap);

        final ViewFactory viewFactory = compiler.call([ dialog ],directiveMap);
        Validate.notNull(viewFactory);

        if (_childScope == null) {
            final Scope scope = _injector.get(Scope);
            Validate.notNull(scope);

            _childScope = scope.createChild(this);
            //_childScope = scope.createChild(scope.context);
            //_childScope = scope.createProtoChild();

            Validate.notNull(_dialogElement._wskDialogElement);
            //_childScope = scope.createChild(this);
            final View view = viewFactory.call(_childScope, null, [ dialog ]);
            Validate.notNull(view);
        }
    }
}


@Component(selector: "wsk-alert-dialog" ,useShadowDom: false, templateUrl: "packages/wsk_angular/wsk_dialog/wsk_alert-dialog.html")
class WskAlertDialog extends WskDialog {
    static const String SELECTOR = "wsk-alert-dialog";

    int _counter = 0;

    WskAlertDialog(final Injector injector) : super(SELECTOR) {
        Validate.notNull(injector);
        this.injector = injector;
    }

    String get testmike => "Hallo Mike $_counter";

    @override
    Future show() { _counter++; return super.show(); }

    // - EventHandler -----------------------------------------------------------------------------

    void onClose(final html.Event event) {
        _logger.info("onClose");
        close(WskDialogStatus.OK);
    }

    // - private ----------------------------------------------------------------------------------

}
