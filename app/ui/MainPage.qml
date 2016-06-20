import QtQuick 2.4
import Ubuntu.Components 1.3

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
            id:logItemDelegate
            property var pageDelegate

            onClicked:{
                console.log("creating page")

                //remove the file extension if any
                var lastpos = iLogPath.lastIndexOf(".")
                if (lastpos ===-1) lastpos=iLogPath.length

                //remove path
                var startpos = iLogPath.lastIndexOf("/")

                //iname is now the title page
                var iname= iLogPath.slice(startpos+1,lastpos)
                console.log("in page creation, title is " +iname + "\nfile is " +preferences.dir+iLogPath)

                //create page
                var pref = {
                    logname: iname,
                    path: preferences.dir + iLogPath,
                    buffer: preferences.buffer,
                    fontSize: FontUtils.sizeToPixels("medium") * preferences.dpFontSize / 10,
                    filter: preferences.filter,
                    username: preferences.username
                }

                pageStack.push(Qt.resolvedUrl("LogPage.qml"), pref)

                console.log("page loaded")

//                            Should be: => Error in createLog()
//                            qml: creating page
//                            qml: in page creation, title is application-click-com.ubuntu.developer.nikwen.logviewer.logviewer_Logviewer_0.1file is /home/phablet/.cache/upstart/application-click-com.ubuntu.developer.nikwen.logviewer.logviewer_Logviewer_0.1.log
//                            readlog called
//                            filed opened succesfully  "/home/phablet/.cache/upstart/application-click-com.ubuntu.developer.nikwen.logviewer.logviewer_Logviewer_0.1.log"
//                            seek of file was  true
//                            qml: page loaded
            }

            ListItemLayout {
                anchors.centerIn: parent

                title.text:iLogPath.slice(iLogPath.lastIndexOf("/")+1,iLogPath.length)

                Icon {
                    width: units.gu(2); height: width
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Last
                }
            }
        }
    }
}
