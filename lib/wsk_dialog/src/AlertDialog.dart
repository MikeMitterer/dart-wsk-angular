part of wsk_angular.wsk_dialog;

@Component(selector: "wsk-alert-dialog" ,useShadowDom: false, templateUrl: "packages/wsk_angular/wsk_dialog/wsk_alert-dialog.html")
class WskAlertDialog extends WskDialog {
    static const String SELECTOR = "wsk-alert-dialog";

    static const String _DEFAULT_OK_BUTTON = "OK";


    String title = "";
    String text = "";
    String okButton = _DEFAULT_OK_BUTTON;

    WskAlertDialog(final Injector injector) : super(SELECTOR,new DialogConfig()) {
        Validate.notNull(injector);
        this.injector = injector;
    }

    WskAlertDialog call(final String text,{ final String title: "", final String okButton: _DEFAULT_OK_BUTTON }) {
        Validate.notBlank(text);
        Validate.notNull(title);
        Validate.notBlank(okButton);

        this.text = text;
        this.title = title;
        this.okButton = okButton;
        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onClose() {
        _logger.info("onClose");
        close(WskDialogStatus.OK);
    }

    // - private ----------------------------------------------------------------------------------

}