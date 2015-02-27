// Copyright (C) 2013 - 2014 Angular Dart UI authors. Please see AUTHORS.md.
// https://github.com/akserg/angular.dart.ui
// All rights reserved.  Please see the LICENSE.md file.
part of wsk_angular.wsk_dragdrop;

@Decorator(selector: '[ui-draggable]')
class DraggableComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_dragdrop.DraggableComponent');

    final html.Element _component;
    final DragDropDataService _dragDropService;

    DraggableElementHandler draggableHandler;
    DragDropConfig _dragDropConfig;
    bool _enabled = true;
    List<String> allowedDropZones = [];

    DraggableComponent(this._component, this._dragDropService,final DragDropConfigService dragDropConfigService) {
        draggableHandler = new DraggableElementHandler(this);
        dragdropConfig = dragDropConfigService.config;

        _component.onDragStart.listen((html.MouseEvent event) {
            _onDragStart(event);

            //workaround to avoid NullPointerException during unit testing
            if (event.dataTransfer != null) {
                event.dataTransfer.effectAllowed = _dragDropConfig.dragEffect.name;
                event.dataTransfer.setData('text/html', '');

                if (_dragDropConfig.dragImage != null) {
                    DragImage dragImage = _dragDropConfig.dragImage;
                    event.dataTransfer.setDragImage(dragImage.imageElement, dragImage.x_offset, dragImage.y_offset);
                }

            }
        });

        _component.onDragEnd.listen(_onDragEnd);
        _component.onTouchStart.listen(_onDragStart);
        _component.onTouchEnd.listen(_onDragEnd);
    }

    @NgOneWay("allowed-drop-zones")
    set dropZones(var dropZones) {
        if (dropZones != null && (dropZones is String)) {
            this.allowedDropZones = [dropZones];
        }
        else if (dropZones != null && (dropZones is List<String>)) {
            this.allowedDropZones = dropZones;
        }
    }

    @NgOneWay("draggable-enabled")
    set draggable(bool value) {
        if (value != null) {
            _enabled = value;
            draggableHandler.refresh();
        }
    }

    @NgOneWay("draggable-data")
    var draggableData;

    @NgOneWay("dragdrop-config")
    set dragdropConfig(DragDropConfig config) {
        _dragDropConfig = config;
        draggableHandler.refresh();
    }

    @NgCallback("on-drag-success")
    Function onDragSuccessCallback;

    // -- private ---------------------------------------------------------------------------------

    void _onDragStart(html.Event event) {
        if (!_enabled) {
            return;
        }

        html.Element dragTarget = event.target;
        dragTarget.classes.add(_dragDropConfig.onDragStartClass);

        _dragDropService.allowedDropZones = allowedDropZones;
        _dragDropService.draggableData = draggableData;
        _dragDropService.onDragSuccessCallback = onDragSuccessCallback;
    }

    void _onDragEnd(html.Event event) {
        html.Element dragTarget = event.target;
        dragTarget.classes.remove(_dragDropConfig.onDragStartClass);

        _dragDropService.draggableData = null;
        _dragDropService.onDragSuccessCallback = null;
    }

}

class DraggableElementHandler {

    String defaultCursor;
    DraggableComponent draggableComponent;

    DraggableElementHandler(this.draggableComponent) {
        defaultCursor = draggableComponent._component.style.cursor;
    }

    void refresh() {
        draggableComponent._component.draggable = draggableComponent._enabled;
        if (draggableComponent._dragDropConfig.dragCursor != null) {
            draggableComponent._component.style.cursor = draggableComponent._enabled ? draggableComponent._dragDropConfig.dragCursor : defaultCursor;
        }
    }
}