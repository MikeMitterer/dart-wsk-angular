part of wsk_angular.wsk_dialog;

enum WskDialogStatus {
    CLOSED_BY_ESC, CLOSED_BY_BACKDROPCLICK,
    CLOSED_ON_TIMEOUT, CLOSED_VIA_NEXT_SHOW,
    OK,
    YES, NO,

    // Toast sends a "confirmed"
    CONFIRMED
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

    final DialogConfig config;

    /// {_directiveSelector} is for example wsk-alert-dialog and will be needed in _getTemplateUrl
    WskDialog(this._directiveSelector,this.config ) {
        Validate.notBlank(_directiveSelector);
        Validate.notNull(config);

        // Lets get informed if the user clicks on ESC or on the backdrop-container
        config.onCloseCallbacks.add(_onCloseViaEscOrClickOnBackDrop);
    }

    /// Must be set in Child-CTOR.
    /// Can't be set automatically via super-param (in Child) is always null if set from super
    void set injector(final Injector injectorObject) {
        Validate.notNull(injectorObject);
        _injector = injectorObject;
    }

    /// The returned Future informs about how the dialog was closed
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

    Future close(final WskDialogStatus status) {
        return _destroy(status);
    }

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------
    void _onCloseViaEscOrClickOnBackDrop(final DialogElement dialogElement, final WskDialogStatus status) {
        _destroy(status);
    }

    Future _destroy(final WskDialogStatus status) {
        Future _cleanupScope() {
            return new Future(() {

                if(_childScope != null) {
                    _childScope.destroy();
                }

                _childScope = null;
                _dialogElement = null;
            });
        }

        if(_dialogElement != null) {
            return _dialogElement.close(status).then((_) {
                _dialogElement = null;
                return _cleanupScope();
            });

        } else {
            return _cleanupScope();
        }
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
            _dialogElement = new DialogElement.fromString(template, config );
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

            _logger.info("Scope: $scope");

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
