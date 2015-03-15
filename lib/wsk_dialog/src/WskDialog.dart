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
    final Map<String,DialogElement> _dialogElements = new Map<String,DialogElement>();

    /// identifies the Template.
    ///     @Component(selector: <directiveSelector>, templateUrl: ...)
    final String _directiveSelector;

    /// {_injector} returns all the necessary Objects to compile the Scope
    /// into the template
    Injector _injector;

    /// Settings for specific dialog flavor
    final DialogConfig config;

    /// {_directiveSelector} is for example wsk-alert-dialog and will be needed in _getTemplateUrl
    WskDialog(this._directiveSelector,this.config ) {
        Validate.notBlank(_directiveSelector);
        Validate.notNull(config);

        // Lets get informed if the user clicks on ESC or on the backdrop-container
        config.onCloseCallbacks.add(_onCloseCallback);
    }

    /// Must be set in Child-CTOR.
    /// Can't be set automatically via super-param (in Child) is always null if set from super
    void set injector(final Injector injectorObject) {
        Validate.notNull(injectorObject);
        _injector = injectorObject;
    }

    /// The returned Future informs about how the dialog was closed
    /// If {timeout} is set - the corresponding dialog closes automatically after this period
    /// The callback {dialogIDCallback} can be given to find out the dialogID - useful for Toast that needs confirmation
    Future<WskDialogStatus> show({ final Duration timeout,void dialogIDCallback(final String dialogId) }) {

        final DirectiveMap directiveMap = _injector.get(DirectiveMap);
        Validate.notNull(directiveMap);

        final TemplateCache templateCache = _injector.get(TemplateCache);
        Validate.notNull(templateCache);

        final Http http = _injector.get(Http);
        Validate.notNull(http);

        /// Informs the caller about the dialog status
        final Completer<WskDialogStatus> openCompleter = new Completer<WskDialogStatus>();

        final String url = _getTemplateUrl(directiveMap);
        http.get(url, cache: templateCache).then( (final HttpResponse response) {
            Validate.notNull(response);
            Validate.notBlank(response.data);

            final String template = response.data;
            final DialogElement element = new DialogElement.fromString(template, config );
            if(dialogIDCallback != null) { dialogIDCallback(element.id); }

            _dialogElements[element.id] = element;
            _compileScopeIntoHtmlElement(element);
            element.show(openCompleter,timeout: timeout);
        });

        return openCompleter.future;
    }

    /// If the {dialogID} is given - it closes this specific dialog, otherwise all dialog with a timer (autoCloseEnabled)
    /// will be closed. If {onlyIfAutoCloseEnabled} is set to false all Dialogs will be closed regardless if
    /// the have a Timer or not
    Future close(final WskDialogStatus status, { final String dialogID, bool onlyIfAutoCloseEnabled: true }) {
        //Validate.notEmpty(_dialogElements,"You try to close a dialog but they are all already closed???");

        if(dialogID != null && dialogID.isNotEmpty) {
            if(!_dialogElements.containsKey(dialogID)) {
                _logger.warning("Dialog with ID $dialogID should be close but is already closed.");
                return new Future.value();
            }
            final DialogElement dialogElement = _dialogElements.remove(dialogID);
            return dialogElement.close(status);
        }

        final List<Future> futures = new List<Future>();
        _dialogElements.forEach((final String key, final DialogElement element) {
            if(element.isAutoCloseEnabled || onlyIfAutoCloseEnabled == false || config.autoClosePossible == false) {
                _logger.info("Closing Dialog ${element.id}");
                futures.add(element.close(status));
            }
        });

        return Future.wait(futures);
    }

    /// Shortcut to close(status,onlyIfAutoCloseEnabled: false);
    Future closeAll(final WskDialogStatus status) {
        return close(status,onlyIfAutoCloseEnabled: false);
    }

    int get numberOfDialogs => _dialogElements.length;

    // - EventHandler -----------------------------------------------------------------------------

    // - private ----------------------------------------------------------------------------------

    /// DialogElements informs about what's going on
    void _onCloseCallback(final DialogElement dialogElement, final WskDialogStatus status) {
        Validate.notNull(dialogElement);
        Validate.notNull(status);

        _logger.info("DialogElement closed. ID: ${dialogElement.id}, Status: $status");
    }

    /// In the child you specified a templateUrl, this url is used to build the DialogElement
    /// Sample: @Component(selector: 'wsk-toast-dialog', useShadowDom: false,
    ///     templateUrl: 'packages/wsk_angular/wsk_toast/wsk_toast.html')
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

    /// Here the magic happens! The child scope is compiled into the HTML-Template
    void _compileScopeIntoHtmlElement(final DialogElement dialogElement) {
        final Compiler compiler = _injector.get(Compiler);
        Validate.notNull(compiler);

        final DirectiveMap directiveMap = _injector.get(DirectiveMap);
        Validate.notNull(directiveMap);

        final html.Element node = dialogElement._htmlWskDialogNode;
        Validate.notNull(node);

        final ViewFactory viewFactory = compiler.call([ node ],directiveMap);
        Validate.notNull(viewFactory);

        if (dialogElement._scope == null) {
            final Scope scope = _injector.get(Scope);
            Validate.notNull(scope);

            _logger.info("Scope: $scope");

            dialogElement._scope = scope.createChild(this);
            //_childScope = scope.createChild(scope.context);
            //_childScope = scope.createProtoChild();

            final View view = viewFactory.call(dialogElement._scope, null, [ node ]);
            Validate.notNull(view);
        }
    }
}
