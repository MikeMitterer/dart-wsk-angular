part of wsk_angular.wsk_dragdrop;

@Decorator(selector: 'wsk-dropzone')
class WskDropZoneComponent {
    final _logger = new Logger('wsk_angular.wsk_dragdrop.DroppableComponent');

    static const _DNDCssClasses _cssClasses = const _DNDCssClasses();

    final html.Element _component;
    final DragInfo _dragInfo;

    final List<String> _zoneNames = [];

    Dropzone _dropzone;

    WskDropZoneComponent(this._component, this._dragInfo) {
        Validate.notNull(_component);
        Validate.notNull(_dragInfo);

        _component.classes.add(_cssClasses.WSK_DROPZONE);

        _dropzone = new Dropzone(_component, overClass: _cssClasses.OVER ,acceptor: new WskAngularAcceptor(_dragInfo,_getZoneNames));
        _dropzone.onDrop.listen(_onDrop);
    }

    @NgOneWay("name")
    set name(var zoneName) {
        _logger.info("DropZones: $zoneName");

        _zoneNames.clear();
        if (zoneName != null && (zoneName is String)) {
            this._zoneNames.add(zoneName);
        }
        else if (zoneName != null && (zoneName is List<String>)) {
            this._zoneNames.addAll(zoneName);
        }
    }

    @NgCallback("on-drop-success")
    Function onDropSuccessCallback;


    // -- private ---------------------------------------------------------------------------------

    void _onDrop(final DropzoneEvent event) {
        _logger.info("OnDrop!");
        _component.classes.remove(_cssClasses.INVALID);

        if (onDropSuccessCallback != null) {
            _logger.info("Call callback");
            onDropSuccessCallback( {
                'data': _dragInfo.data
            });
        }
    }

    List<String> _getZoneNames() {
        return _zoneNames;
    }
}

/**
 * WskAngularAcceptor that accepts [Draggable]s with a valid drop-zone set
 */
class WskAngularAcceptor extends Acceptor {
    final _logger = new Logger('wsk_angular.wsk_dragdrop.WskAngularAcceptor');

    final DragInfo _dragDropService;
    final _getZoneNamesCallback;

    WskAngularAcceptor(this._dragDropService,void getZoneNames())
        : _getZoneNamesCallback = getZoneNames {
        Validate.notNull(_dragDropService);
        Validate.notNull(getZoneNames);
    }

    @override
    bool accepts(final html.Element draggableElement,final int draggableId,final html.Element dropzoneElement) {
        final bool isValid = _isDragZoneValid();

        //if(!isValid) {
        //    dropzoneElement.classes.add("dnd-invalid");
        //} else {
        //    dropzoneElement.classes.remove("dnd-invalid");
        //}

        return isValid;
    }

    // -- private ---------------------------------------------------------------------------------

    bool _isDragZoneValid() {
        final List<String> _dropZoneNames = _getZoneNamesCallback();

        if (_dropZoneNames.isEmpty && _dragDropService.allowedDropZones.isEmpty) {
            _logger.info("DragZone is allowed because dropZoneNames and allowedDropZones are empty!");
            return true;
        }
        for (final String dropZone in _dragDropService.allowedDropZones) {
            if (_dropZoneNames.contains(dropZone)) {
                return true;
            }
        }
        _logger.info("DragZone is NOT allowed. $_dropZoneNames not found in allowedDropZones (${_dragDropService.allowedDropZones})");

        return false;
    }
}