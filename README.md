# wsk_angular

The base-module for wsk_angular is [wsk_material][wskmaterial]<br>
Running sample can be found on [wsk.angular.mikemitterer.at][live]

###AngularDart-Bug###
I you want to build the JS-Version you have to
```bash
    rm -rf web
    ln -s example/wsk_button/ web
    pub build web
```

Or if you want to check out the styleguide you need
```bash
    rm -rf web
    ln -s example/styleguide/ web
    pub build web
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MikeMitterer/dart-wsk-angular/issues
[wskmaterial]: https://github.com/MikeMitterer/dart-wsk-material
[live]: http://wsk.angular.mikemitterer.at/
