import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.folderlistmodel 1.0

Page {
    id: mainPage

    header: PageHeader {
        title: i18n.tr("Ubuntu Touch Logs")
        flickable: scrollView.flickableItem

        trailingActionBar.actions: [
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
        showOnlyReadable: true
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
                    logname: iname.replace("application-click-",""),
                    path: preferences.dir + model.fileName,
                    fontSize: FontUtils.sizeToPixels("medium") * preferences.dpFontSize / 10,
                    interval: preferences.interval,
                }

                pageStack.push(Qt.resolvedUrl("LogPage.qml"), pref);

                console.log("page loaded");
            }

            ListItemLayout {
                anchors.centerIn: parent
                //extract app name and version from log filename
                //distinguish between app logs and other logs because they do have different name structures
                title.text: model.fileName.lastIndexOf("_") > 1 ? "v" + model.fileName.split("_")[2].replace(".log","") + " " + model.fileName.split("_")[1] : model.fileName.replace(".log","")
                subtitle.text: i18n.tr("file") + ": " + model.fileName.slice(model.fileName.lastIndexOf("/")+1,model.fileName.length)

                Icon {
                    width: units.gu(2); height: width
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Last
                }
            }
        }
    }
}
