// Copyright (C) 2013 - 2014 Angular Dart UI authors. Please see AUTHORS.md.
// https://github.com/akserg/angular.dart.ui
// All rights reserved.  Please see the LICENSE.md file.
part of wsk_angular.wsk_dragdrop;

@Decorator(selector: '[ui-droppable]')
class DroppableComponent implements ScopeAware {
    final _logger = new Logger('wsk_angular.wsk_dragdrop.DroppableComponent');

    final html.Element _component;
    final DragDropDataService _dragDropService;

    DragDropConfig _dragDropConfig;
    List<String> dropZoneNames = [];
    Scope scope;

    DroppableComponent(this._component, this._dragDropService,final DragDropConfigService dragDropConfigService) {
        _dragDropConfig = dragDropConfigService.config;

        _component.onDragEnter.listen(_onDragEnter);

        _component.onDragOver.listen((html.MouseEvent event) {
            _onDragOver(event);
            //workaround to avoid NullPointerException during unit testing
            if (event.dataTransfer != null) {
                event.dataTransfer.dropEffect = _dragDropConfig.dropEffect.name;
            }
        });
        _component.onDragLeave.listen(_onDragLeave);
        _component.onTouchEnter.listen(_onDragEnter);
        _component.onTouchLeave.listen(_onDragLeave);

        _component.onDrop.listen(_onDrop);
    }

    @NgOneWay("drop-zones")
    set dropZones(var dropZoneNames) {
        _logger.info("DropZones: $dropZoneNames");

        if (dropZoneNames != null && (dropZoneNames is String)) {
            this.dropZoneNames = [dropZoneNames];
        }
        else if (dropZoneNames != null && (dropZoneNames is List<String>)) {
            this.dropZoneNames = dropZoneNames;
        }
    }

    @NgCallback("on-drop-success")
    Function onDropSuccessCallback;

    @NgOneWay("dragdrop-config")
    set dragdropConfig(DragDropConfig config) {
        _dragDropConfig = config;
    }

    // -- private ---------------------------------------------------------------------------------

    void _onDragEnter(html.Event event) {
        if (!isAllowedDragZone()) {
            _component.classes.add(_dragDropConfig.onDragEnterInvalidClass);
            return;
        }
        // This is necessary to allow us to drop.
        event.preventDefault();
        _component.classes.add(_dragDropConfig.onDragEnterClass);
    }

    void _onDragOver(html.Event event) {
        if (!isAllowedDragZone()) {
            _component.classes.add(_dragDropConfig.onDragEnterInvalidClass);
            return;
        }
        // This is necessary to allow us to drop.
        event.preventDefault();
        _component.classes.add(_dragDropConfig.onDragOverClass);
    }

    void _onDragLeave(html.Event event) {
        if (!isAllowedDragZone()) {
            _component.classes.remove(_dragDropConfig.onDragEnterInvalidClass);
            return;
        }
        _component.classes.remove(_dragDropConfig.onDragOverClass);
        _component.classes.remove(_dragDropConfig.onDragEnterClass);
    }

    void _onDrop(html.Event event) {
        if (!isAllowedDragZone()) {
            _component.classes.remove(_dragDropConfig.onDragEnterInvalidClass);
            return;
        }
        if (onDropSuccessCallback != null) {
            _logger.info("Call callback");
            onDropSuccessCallback( {
                'data': _dragDropService.draggableData
            });
        }
        if (_dragDropService.onDragSuccessCallback != null) {
            _dragDropService.onDragSuccessCallback();
        }
        _component.classes.remove(_dragDropConfig.onDragOverClass);
        _component.classes.remove(_dragDropConfig.onDragEnterClass);
    }

    bool isAllowedDragZone() {
        if (dropZoneNames.isEmpty && _dragDropService.allowedDropZones.isEmpty) {
            _logger.info("DragZone is allowed because dropZoneNames and allowedDropZones are empty!");
            return true;
        }
        for (String dropZone in _dragDropService.allowedDropZones) {
            if (dropZoneNames.contains(dropZone)) {
                return true;
            }
        }
        _logger.info("DragZone is NOT allowed. $dropZoneNames not found in allowedDropZones (${_dragDropService.allowedDropZones}");

        return false;
    }

}
