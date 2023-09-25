import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.settings 1.0

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "logviewer.ruditimmer"
    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(75)

    property string appVersion : "2.9.0"     

    Component.onCompleted: {
        pStack.push(Qt.resolvedUrl("MainPage.qml"));
    }

    Settings {
        id: preferences
        property string dir: "/home/phablet/.cache/upstart/"
        property string unitFilter: "*.service"
        property int interval: 100
        property int dpFontSize: 10
        property int commonMargin: units.gu(2)
        property bool hidePush: true
    }

    PageStack {
        id: pStack
    }

    function applyChanges(msettings) {
        console.log("Save changes...")
        preferences.dpFontSize = msettings.dpFontSize;
        preferences.interval = msettings.interval;
        preferences.unitFilter = msettings.filter;
        preferences.hidePush = msettings.hidePush;
    }

    function showSettings() {
        const settingsPage = pStack.push(Qt.resolvedUrl("PrefPage.qml"), {
            dpFontSize: preferences.dpFontSize,
            interval: preferences.interval,
            filter: preferences.unitFilter,
            hidePush: preferences.hidePush,
        });

        settingsPage.applyChanges.connect(applyChanges.bind(this, settingsPage));
    }
}
