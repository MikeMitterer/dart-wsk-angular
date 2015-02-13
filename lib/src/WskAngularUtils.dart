part of wsk_angular;

/// Utils-class used as "namespace"
abstract class WskAngularUtils {

    /// turns value into a boolean, if value is an empty string
    /// it returns tru. This is for the case if disabled is set as attribute without value
    /// If {value} is null means no "disabled" state found so it returns false (not disabled)
    static bool isDisabled(final dynamic value) {
        if(value == null) {
            return false;
        }
        return asBool(value,handleEmptyStringAs: true);
    }

    /// turns value into a boolean
    /// {handleEmptyString} defines how an empty String should be treated
    static bool asBool(final dynamic value, { final bool handleEmptyStringAs: false }) {
        if(value == null) {
            return false;

        } else  if(value is num) {
            return (value as num).toInt() == 1;

        } else  if(value is bool) {
            return value;

        // IntelliJ needs the as String...
        } else if((value.toString() as String).toLowerCase() == "true" ||
            value.toString() == "1" || value.toString() == "yes" ) {
            return true;

        } else if((value.toString() as String).isEmpty) {
            return handleEmptyStringAs;
        }

        return false;
    }

    /// turns value into int - default
    static int asInt(final dynamic value,{ final int defaultValue: 0 }) {
        if(value is num) {
            return (value as num).toInt();

        } else if(value is String) {
            return int.parse(value);

        }

        return defaultValue;
    }

    /// Checks if the component has either the class set or if the attribute is available
    /// {attributeVarInComponent} is a WskXXXComponent variable set via @Ngxxx()
    static bool hasAttributeOrClass(final html.Element component,final List<String> classesOrAttributes,{ final dynamic attributeVarInComponent }) {
        Validate.notNull(component);
        Validate.notNull(classesOrAttributes);

        for(final String classOrAttribute in classesOrAttributes) {
            final bool hasClass = component.classes.contains(classOrAttribute);
            if(hasClass) {
                return true;
            }
            final bool isAttributeSet = component.attributes.containsKey(classOrAttribute);
            if(isAttributeSet) {
                return true;
            }
        }
        if(attributeVarInComponent == null) {
            return false;
        }
        return hasAttribute(attributeVarInComponent);
    }

    /// Checks if the component has the attribute set.
    /// Set means if {attribute} is not null
    static bool hasAttribute(final dynamic attributeVarInComponent) {
        return asBool(attributeVarInComponent,handleEmptyStringAs: true);
    }

    static bool hasClass(final html.Element component,final String cssClass) {
        return component.classes.contains(cssClass);
    }
}
