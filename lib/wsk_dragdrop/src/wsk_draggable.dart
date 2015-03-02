// Copyright (C) 2013 - 2014 Angular Dart UI authors. Please see AUTHORS.md.
// https://github.com/akserg/angular.dart.ui
// All rights reserved.  Please see the LICENSE.md file.
part of wsk_angular.wsk_dragdrop;

@Decorator(selector: 'wsk-draggable')
class WskDraggableComponent {
    final Logger _logger = new Logger('wsk_angular.wsk_dragdrop.DraggableComponent');

    final html.Element _component;
    static const _DNDCssClasses _cssClasses = const _DNDCssClasses();

    final DragInfo _dragInfo;

    List<String> allowedDropZones = [];

    Draggable _draggable;

    WskDraggableComponent(this._component, this._dragInfo) {
        Validate.notNull(_component);
        Validate.notNull(_dragInfo);

        _component.classes.add(_cssClasses.WSK_DRAGGABLE);
        _component.classes.add(_cssClasses.DRAGGABLE);

        _draggable = new Draggable( _component,avatarHandler: new AvatarHandler.clone());

        _draggable.onDragStart.listen(_onDragStart);
        _draggable.onDragEnd.listen(_onDragEnd);
    }

    @NgOneWay("drop-zone")
    set dropZone(var dropZone) {
        if (dropZone != null && (dropZone is String)) {
            this.allowedDropZones = [ dropZone ];
        }
        else if (dropZone != null && (dropZone is List<String>)) {
            this.allowedDropZones = dropZone;
        }
    }

    get _isDisabled => WskAngularUtils.hasAttributeOrClass(_component,[ 'disabled', 'is-disabled' ]);

    @NgOneWay("data-to-drag")
    var dataToDrag;


    // -- private ---------------------------------------------------------------------------------

    void _onDragStart(final DraggableEvent event) {
        _logger.info("_onDragStart");
        if (_isDisabled) {
            return;
        }

        _dragInfo.allowedDropZones = allowedDropZones;
        _dragInfo.data = dataToDrag;
    }

    void _onDragEnd(final DraggableEvent event) {

        _dragInfo.data = null;
    }

}

