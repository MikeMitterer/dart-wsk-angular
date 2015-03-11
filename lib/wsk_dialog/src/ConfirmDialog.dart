part of wsk_angular.wsk_dialog;

@Component(selector: "wsk-confirm-dialog" ,useShadowDom: false,
    templateUrl: "packages/wsk_angular/wsk_dialog/wsk_confirm-dialog.html")
class WskConfirmDialog extends WskDialog {
    static const String SELECTOR = "wsk-confirm-dialog";

    static const String _DEFAULT_YES_BUTTON = "Yes";
    static const String _DEFAULT_NO_BUTTON = "No";

    String title = "";
    String text = "";
    String yesButton = _DEFAULT_YES_BUTTON;
    String noButton = _DEFAULT_NO_BUTTON;

    WskConfirmDialog(final Injector injector) : super(SELECTOR,new DialogConfig()) {
        Validate.notNull(injector);
        this.injector = injector;
    }

    WskConfirmDialog call(final String text,{ final String title: "",
        final String yesButton: _DEFAULT_YES_BUTTON, final String noButton: _DEFAULT_NO_BUTTON }) {
        Validate.notBlank(text);
        Validate.notNull(title);
        Validate.notBlank(yesButton);
        Validate.notBlank(noButton);

        this.text = text;
        this.title = title;
        this.yesButton = yesButton;
        this.noButton = noButton;

        return this;
    }

    bool get hasTitle => (title != null && title.isNotEmpty);

    // - EventHandler -----------------------------------------------------------------------------

    void onYes() {
        close(WskDialogStatus.YES);
    }

    void onNo() {
        close(WskDialogStatus.NO);
    }

    // - private ----------------------------------------------------------------------------------

}