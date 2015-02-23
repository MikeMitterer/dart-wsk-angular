part of wsk_angular.wsk_dialog;

/// Called it ESC is pressed or if the user clicks on the backdrop-Container
typedef void OnCloseCallback(final DialogElement dialogElement, final WskDialogStatus status);

void _internalOnCloseCallback(final DialogElement dialogElement, final WskDialogStatus status) {
    Validate.notNull(dialogElement);
    Validate.notNull(status);

    dialogElement.close(status);
}

/// HTML-Part of WskDialog.
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

    /// Informs the caller about ESC and about onBackDropClick so that the caller can
    /// close this DialogElement an cleanup internal states
    final OnCloseCallback _onCloseCallback;

    DialogElement.fromString(final String htmlString, { final bool closeDialogOnBackDropClick: true,
    final bool acceptEscToClose: true, final OnCloseCallback onCloseCallback: _internalOnCloseCallback }) :
        _acceptEscToClose = acceptEscToClose, _onCloseCallback = onCloseCallback {

        Validate.notBlank(htmlString);
        Validate.notNull(onCloseCallback);

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

        // Hide makes it possible to fade out the dialog
        _hide(status);
    }


    // - private ----------------------------------------------------------------------------------

    /// Hides the dialog and leaves it in the DOM
    void _hide(final WskDialogStatus status) {
        _wskDialogContainer.classes.remove(_cssClasses.IS_VISIBLE);
        _wskDialogContainer.classes.add(_cssClasses.IS_HIDDEN);

        _complete(status);
    }

    /// The dialog get removed from the DOM
    void _destroy(final WskDialogStatus status) {
        final html.Element container = _parent.querySelector(_containerSelector);
        _logger.info("Selector ${_containerSelector} brought: $container");

        if (container != null) {
            container.remove();
            _logger.info("Container removed!");
        }
        _complete(status);
    }

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
                //close(WskDialogStatus.CLOSED_BY_BACKDROPCLICK);
                _onCloseCallback(this,WskDialogStatus.CLOSED_BY_BACKDROPCLICK);

            }
        });
    }

    void _addEscListener() {
        _keyboardEventSubscription = html.document.onKeyDown.listen( (final html.KeyboardEvent event) {
            event.preventDefault();
            event.stopPropagation();

            if(event.keyCode == 27) {
                //close(WskDialogStatus.CLOSED_BY_ESC);
                _onCloseCallback(this,WskDialogStatus.CLOSED_BY_ESC);
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
