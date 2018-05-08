import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.folderlistmodel 1.0

Page {
    id: mainPage

    header: PageHeader {
        title: i18n.tr("Ubuntu Logs")
        flickable: scrollView.flickableItem

        trailingActionBar.actions: [
        Action {
            text: i18n.tr("Reload")
            onTriggered: logs.loadLogs()
            iconName: "reload"
        },
        Action {
            text: i18n.tr("Settings")
            onTriggered: mainView.showSettings()
            iconName: "settings"
        },
        Action {
            text: i18n.tr("About")
            onTriggered: pStack.push(Qt.resolvedUrl("AboutPage.qml"))
            iconName: "info"
        }
        ]
    }

    FolderListModel {
        id: logsList
        folder: preferences.dir
        nameFilters: [ preferences.filter ]
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: logsListView
            anchors.fill: parent
            model: logsList
            delegate: logDelegate
            focus: true

            Label {
                id: emptyLabel
                anchors.centerIn: parent
                text: i18n.tr("No logs found for the set filter")
                visible: logsListView.count === 0 && !logsList.loading
            }
        }
    }

    Component{
        id:logDelegate

        ListItem {
            id: logItemDelegate
            property var pageDelegate

            onClicked:{
                console.log("creating page");

                //remove the file extension if any
                var lastpos = model.fileName.lastIndexOf(".");
                if (lastpos === -1) lastpos = model.fileName.length;

                //remove path
                var startpos = model.fileName.lastIndexOf("/");

                //iname is now the title page
                var iname= model.fileName.slice(startpos + 1, lastpos);
                console.log("title is " + iname);
                console.log("file is " + preferences.dir + model.fileName);

                //create page
                var pref = {
                    logname: iname,
                    path: preferences.dir + model.fileName,
                    fontSize: FontUtils.sizeToPixels("medium") * preferences.dpFontSize / 10,
                    interval: preferences.interval,
                    username: preferences.username
                }

                pageStack.push(Qt.resolvedUrl("LogPage.qml"), pref);

                console.log("page loaded");
            }

            ListItemLayout {
                anchors.centerIn: parent

                title.text:model.fileName.slice(model.fileName.lastIndexOf("/")+1,model.fileName.length)

                Icon {
                    width: units.gu(2); height: width
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Last
                }
            }
        }
    }
}
