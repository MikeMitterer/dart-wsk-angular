WSK Angular **Drag&Drop** componets.

The **wsk-draggable** component identifies the draggable object.
Available settings:
 - `drop-zone`: String or array of Strings. Specify the drop-zones to which this component can drop.
 - `enabled`: bool value. whether the object is draggable. Default is true.
 - `data-to-drag`: the data that has to be dragged. It can be any Dart object.

The **wsk-dropzone** component identifies the drop target object.
Available settings:

 - `name`: String or array of Strings. It permits to specify the drop zones associated with this component. By default, if the `name` attribute is not specified, the droppable component accepts drop operations by all the draggable components that do not specify the `drop-zone`
 - `on-drop-success`: callback function called when the drop action completes correctly.

