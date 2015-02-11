part of wsk_angular;

/// Utils-class used as "namespace"
abstract class WskAngularUtils {

    static bool isDisabled(final dynamic value) {
        if(value == null) {
            return false;
        }
        if(value is bool) {
            return value;
        }
        if(value.toString().isEmpty || value.toString() == "true") {
            return true;
        }

        return false;
    }
}
