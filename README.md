# Web Starter Kit - Material Theme for AngularDart

The WSK-Angular project is an implementation of Material Design in AngularDart
with Googles Web Starter Kit.
 
This project provides a set of reusable and accessible UI components 
based on the Material Design system.

Web Starter Kit strives to give you a high performance starting point out of the box
Responsive layout is included with the kit that adapts to fit the device your user is viewing it on. 

The base-module for wsk_angular is [wsk_material][wskmaterial]

Running sample can be found on **[wsk.angular.mikemitterer.at][live]**

###pub build + Angular###
If your AngularDart Application is in web - pub build should work out of the box but<br>
if you want to build your samples in "example" pub build fails.<br><br>
Here is my workaround:<br>

```bash
    mv web web.orig
    ln -s example/styleguide/ web
    pub build web
```

Another thing not to forget is to add all your views to pubspec.yaml - otherwise it won't work.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MikeMitterer/dart-wsk-angular/issues
[wskmaterial]: https://github.com/MikeMitterer/dart-wsk-material
[live]: http://wsk.angular.mikemitterer.at/
