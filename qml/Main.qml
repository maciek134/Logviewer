import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import Logviewer 1.0

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "logviewer.neothethird"
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
        property int buffer: 8000
        property int dpFontSize: 10
        property string username: "Guest"
    }

    ListModel {
        id: logsList
        property bool loading: false
    }

    LogViewer {
        id: logs
        logDir: preferences.dir
        logFilter: preferences.filter

        onLogListChanged: {
            logsList.loading = true;

            //this signal indicates that the directory files where loaded
            console.log("logs are: " + logs.logList);

            //clear any old list
            logsList.clear();

            var tmplogs = logs.logList;
            var alogs = {}
            alogs = tmplogs.split("\n");
            var itemtmp = {}
            for (var logitem in alogs){
                if(alogs[logitem].trim()!== "") {
                    itemtmp["iLogPath"] = alogs[logitem];
                    logsList.append(itemtmp);
                }
            }

            logsList.loading = false;
        }

        Component.onCompleted: {
            logs.loadLogs();
        }
    }

    PageStack {
        id: pStack
    }

    function showSettings() {
        var prop = {
            dpFontSize: preferences.dpFontSize,
            bufferSize: preferences.buffer,
            directory: preferences.dir,
            filter: preferences.filter,
            username: preferences.username
        }

        var slot_applyChanges = function(msettings) {
            console.log("Save changes...")
            preferences.dpFontSize = msettings.dpFontSize;
            preferences.buffer = msettings.bufferSize;
            preferences.dir = msettings.directory;
            logs.logDir = msettings.directory;
            logs.logFilter = msettings.filter;
            preferences.username = msettings.username;
            preferences.filter = msettings.filter;
            logs.loadLogs();
        }

        var settingPage = pStack.push(Qt.resolvedUrl("PrefPage.qml"), prop);

        settingPage.applyChanges.connect(function() { slot_applyChanges(settingPage) });
    }
}
