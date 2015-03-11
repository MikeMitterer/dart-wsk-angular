part of wsk_angular.wsk_dialog;

/// Called it ESC is pressed or if the user clicks on the backdrop-Container
typedef void OnCloseCallback(final DialogElement dialogElement, final WskDialogStatus status);

//void _internalOnCloseCallback(final DialogElement dialogElement, final WskDialogStatus status) {
//    Validate.notNull(dialogElement);
//    Validate.notNull(status);
//
//    dialogElement.close(status);
//}

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _DialogElementCssClasses {

    /// build something like wsk-dialog-container or wsk-toast-container
    final String CONTAINER_POSTFIX = '-container';

    final String IS_VISIBLE = 'is-visible';
    final String IS_HIDDEN = 'is-hidden';

    final String IS_DELETABLE = "is-deletable";
    final String APPENDING = "appending";

    const _DialogElementCssClasses();
}

/**
 * Configuration for DialogElement
 */
@Injectable()
class DialogConfig {
    static const String _DEFAULT_PARENT_SELECTOR = "body";

    /// In most cases wsk-dialog but can also be wsk-toast
    /// _createDialogElementFromString checks the template if this tag exists
    final String rootTagInTemplate;

    /// If set to true a BackDrop-Container is added
    final bool closeOnBackDropClick;

    /// true
    final bool acceptEscToClose;

    /// Informs the caller about ESC and about onBackDropClick so that the caller can
    /// close this DialogElement an cleanup internal states
    final List<OnCloseCallback> onCloseCallbacks = new List<OnCloseCallback>();

    final String parentSelector;

    DialogConfig({ final String rootTagInTemplate: "wsk-dialog",
                   final bool closeOnBackDropClick: true,
                   final bool acceptEscToClose: true,
                   final String parentSelector: _DEFAULT_PARENT_SELECTOR })

    : this.rootTagInTemplate = rootTagInTemplate,
      this.closeOnBackDropClick = closeOnBackDropClick,
      this.acceptEscToClose = acceptEscToClose,
      this.parentSelector = parentSelector {

        Validate.notBlank(rootTagInTemplate);
    }
}

/// HTML-Part of WskDialog.
class DialogElement {
    final Logger _logger = new Logger('wsk_angular.wsk_dialog._DialogElement');

    static const _DialogElementCssClasses _cssClasses = const _DialogElementCssClasses();

    /// usually the html body
    html.Element _parent;

    /// represents the <wsk-dialog> tag
    html.Element _wskDialogElement;

    /// Wraps wskDialogElement. Darkens the background and
    /// is used for backdrop click
    html.DivElement _wskDialogContainer;

    /// Informs about open and close actions
    Completer<WskDialogStatus> _completer;

    /// Listens to Keyboard-Events
    StreamSubscription _keyboardEventSubscription;

    /// Configuration for this DialogElement
    final DialogConfig _config;

    DialogElement.fromString(final String htmlString,this._config) {
        Validate.notBlank(htmlString);
        Validate.notNull(_config);

        _logger.info("fromString");

        _parent = html.document.querySelector(_config.parentSelector);

        _wskDialogElement = _createDialogElementFromString(htmlString,rootTag: _config.rootTagInTemplate);
        _wskDialogElement.attributes["id"] = _elementID;

        _wskDialogContainer = _prepareContainer();

        if(_config.closeOnBackDropClick) {
            _addBackDropClickListener(_wskDialogContainer);
        }
    }

    void show(final Completer<WskDialogStatus> completer) {
        Validate.notNull(completer);
        Validate.isTrue(!completer.isCompleted);
        Validate.isTrue(_completer == null || _completer.isCompleted);

        _logger.info("show");

        _completer = completer;
        _wskDialogContainer.classes.add(_cssClasses.APPENDING);

        if (_parent.querySelector(_containerSelector) == null) {
            _parent.append(_wskDialogContainer);
        }

        _waitForComponentToLoad(_containerSelector).then((_) {
            _wskDialogContainer.append(_wskDialogElement);

            _waitForComponentToLoad(_elementSelector).then((_) {
                _wskDialogContainer.classes.remove(_cssClasses.IS_HIDDEN);
                _wskDialogContainer.classes.add(_cssClasses.IS_VISIBLE);
                _wskDialogContainer.classes.remove(_cssClasses.APPENDING);
            });
        });

        if(_config.acceptEscToClose) {
            _addEscListener();
        }
        _logger.info("show end");
    }

    Future close(final WskDialogStatus status) {
        _removeEscListener();

        // Hide makes it possible to fade out the dialog
        return _hide(status);
    }


    // - private ----------------------------------------------------------------------------------
    html.HtmlElement get _container => html.document.querySelector(".${_containerClass}");

    html.Element get _element => _wskDialogContainer.querySelector(_elementSelector);

    /// wsk-dialog-container or wsk-toast-container
    String get _containerClass => "${_config.rootTagInTemplate}${_cssClasses.CONTAINER_POSTFIX}";

    /// unique ID for dialog-wrapper
    String get _containerID => "wsk-container-${hashCode.toString()}";

    String get _elementID => "wsk-element-${hashCode.toString()}";

    /// identifies the container
    /// <div class="wsk-toast-container" id="dialog9234848">...</div>
    String get _containerSelector => ".${_containerClass}";

    /// identifies the element
    /// <wsk-dialog id="xxxxx">...</wsk-dialog>
    String get _elementSelector => "#${_elementID}";

    /// Hides the dialog and leaves it in the DOM
    Future _hide(final WskDialogStatus status) {
        _wskDialogContainer.classes.remove(_cssClasses.IS_VISIBLE);
        _wskDialogContainer.classes.add(_cssClasses.IS_HIDDEN);

        //_complete(status);

        return new Future.delayed(new Duration(milliseconds: 200), () {
            _destroy(status);
        });
    }

    /// The dialog gets removed from the DOM
    void _destroy(final WskDialogStatus status) {
        _logger.info("_destroy - selector ${_containerSelector} brought: $_container");

        _container.querySelectorAll(_config.rootTagInTemplate).forEach((final html.Element element) {
            _logger.info("Element ${element} removed!");
            element.remove();
        });

        if (_container != null &&
                !_container.classes.contains(_cssClasses.APPENDING) &&
                _container.classes.contains(_cssClasses.IS_DELETABLE)) {

            _container.remove();
            _logger.info("Container removed!");
        }

        _complete(status);
    }

    /// If there is a container class {dialog} will be added otherwise a container is created
    /// Container class sample: wsk-dialog-container, wsk-toast-container
    html.DivElement _prepareContainer() {

        html.HtmlElement container = _container;;
        if(container == null) {
            _logger.info("Container ${_containerClass} not found, create a new one...");
            container = new html.DivElement();
            container.classes.add(_containerClass);
            container.classes.add(_cssClasses.IS_DELETABLE);
        }
        container.classes.add(_cssClasses.IS_HIDDEN);
        container.classes.remove(_cssClasses.IS_VISIBLE);

        //container.attributes["id"] = _containerID;

        return container;
    }

    void _addBackDropClickListener(final html.DivElement container) {
        container.onClick.listen((final html.MouseEvent event) {
            _logger.info("click on container");

            event.preventDefault();
            event.stopPropagation();

            if (event.target == container) {
                _config.onCloseCallbacks.forEach((final OnCloseCallback callback) {
                    callback(this,WskDialogStatus.CLOSED_BY_BACKDROPCLICK);
                });
            }
        });
    }

    void _addEscListener() {
        _keyboardEventSubscription = html.document.onKeyDown.listen( (final html.KeyboardEvent event) {
            event.preventDefault();
            event.stopPropagation();

            if(event.keyCode == 27) {
                _config.onCloseCallbacks.forEach((final OnCloseCallback callback) {
                    callback(this,WskDialogStatus.CLOSED_BY_ESC);
                });

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
