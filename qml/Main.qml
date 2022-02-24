import QtQuick 2.9
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "logviewer.ruditimmer"
    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(75)

    Component.onCompleted: {
        pStack.push(Qt.resolvedUrl("MainPage.qml"));
    }

    Settings {
        id: preferences
        property string dir: "/home/phablet/.cache/upstart/"
        property string filter: "*.log"
        property int interval: 100
        property int dpFontSize: 10
        property int commonMargin: units.gu(2)
    }

    PageStack {
        id: pStack
    }

    function showSettings() {
        var prop = {
            dpFontSize: preferences.dpFontSize,
            interval: preferences.interval,
            directory: preferences.dir,
            filter: preferences.filter,
        }

        var slot_applyChanges = function(msettings) {
            console.log("Save changes...")
            preferences.dpFontSize = msettings.dpFontSize;
            preferences.interval = msettings.interval;
            preferences.dir = msettings.directory;
            preferences.filter = msettings.filter;
        }

        var settingPage = pStack.push(Qt.resolvedUrl("PrefPage.qml"), prop);

        settingPage.applyChanges.connect(function() { slot_applyChanges(settingPage) });
    }
}
