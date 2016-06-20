import QtQuick 2.0
import Ubuntu.Components 1.1
import "ui"
import "./libs/logviewer.js" as LogViewLib
import Logviewer 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Qt.labs.settings 1.0



MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    id:mainView
    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.vtuson.logviewer"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(100)
    height: units.gu(75)

    useDeprecatedToolbar: false
    anchorToKeyboard: true

    Settings { //This will also save the settings as soon as this patch gets merged into the UI Toolkit trunk repo: https://bugs.launchpad.net/ubuntu-ui-toolkit/+bug/1354321
        id: preferences
        property string dir: "/home/phablet/.cache/upstart/"
        property string filter: "*.log"
        property int buffer: 8000
        property int fontSize: 24
        property string username: "Guest"
    }

    PageStack {
        id: pStack

        Component.onCompleted: push(page0)

        PrefPage {
            id:msettings
            onCancelChanges: {
                loadStandardSettings()
                pStack.pop()
            }
            onApplyChanges: {
                preferences.fontSize=msettings.fontSize
                preferences.buffer=msettings.bufferSize
                preferences.dir=msettings.directory
                logs.logDir=msettings.directory
                logs.logFilter=msettings.filter
                preferences.username =msettings.username
                preferences.filter=msettings.filter
                pStack.pop()
                logs.loadLogs()
            }


            Component.onCompleted:loadStandardSettings()

            function loadStandardSettings(){
                msettings.fontSize=preferences.fontSize
                msettings.bufferSize=preferences.buffer
                msettings.directory=preferences.dir
                msettings.filter=preferences.filter
                msettings.username=preferences.username
            }
        }

        AboutPage {
            id: aboutPage
        }

        Page {
            id: page0
            title: i18n.tr("Ubuntu Logs")
            visible: false
            ListModel {  id:logsList  }

            head.actions: [
                Action {
                    text: i18n.tr("Reload")
                    onTriggered: {
                        emptyLabel.text = ""
                        logsList.clear()
                        logs.loadLogs()
                    }
                    iconName: "reload"
                },
                Action {
                    text: i18n.tr("Settings")
                    onTriggered: pStack.push(msettings)
                    iconName: "settings"
                },
                Action {
                    text: i18n.tr("About")
                    onTriggered: pStack.push(aboutPage)
                    iconName: "info"
                }
            ]

            Component{
                id:logDelegate

                ListItem.Empty {
                    id:logItemDelegate
                    property var pageDelegate
                    Label{
                        id:labelDelegate
                        text:iLogPath.slice(iLogPath.lastIndexOf("/")+1,iLogPath.length)
                        anchors.left: parent.left
                        anchors.leftMargin: units.gu(2)
                        anchors.verticalCenter: parent.verticalCenter
                        fontSize: "large"
                        elide: Text.ElideLeft
                        width:logsListView.width -chevron.width -units.gu(4)

                    }
                    Icon {
                        id:chevron
                        width: units.gu(2)
                        anchors.right: parent.right
                        anchors.rightMargin: units.gu(2)
                        height: width
                        name: "chevron"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    MouseArea {
                        anchors.fill: parent
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
                            pageDelegate=createLog(preferences.dir+iLogPath,iname,preferences.buffer)
                            pageDelegate.fontsize=preferences.fontSize
                            pageDelegate.filter=preferences.filter
                            pageDelegate.username=preferences.username
                            console.log("page loaded")

//                            Should be: => Error in createLog()
//                            qml: creating page
//                            qml: in page creation, title is application-click-com.ubuntu.developer.nikwen.logviewer.logviewer_Logviewer_0.1file is /home/phablet/.cache/upstart/application-click-com.ubuntu.developer.nikwen.logviewer.logviewer_Logviewer_0.1.log
//                            readlog called
//                            filed opened succesfully  "/home/phablet/.cache/upstart/application-click-com.ubuntu.developer.nikwen.logviewer.logviewer_Logviewer_0.1.log"
//                            seek of file was  true
//                            qml: page loaded
                        }
                    }

                }
            }
            ListView {
                id: logsListView
                clip: true
                anchors.fill: parent
                model: logsList
                delegate: logDelegate
                focus: true
            }

            Label {
                property string textToShow: i18n.tr("No logs found for the set filter") //Don't show text while (re)loading
                id: emptyLabel
                anchors.centerIn: parent
                visible: logsListView.model.count === 0
            }

            LogViewer {
                id:logs
                logDir: preferences.dir
                logFilter:preferences.filter

                onLogListChanged: {
                    //this signal indicates that the directory files where loaded
                    console.log("logs are: " + logs.logList)

                    //clear any old list
                    logsList.clear()

                    var tmplogs= logs.logList;
                    var alogs = {}
                    alogs = tmplogs.split("\n")
                    var itemtmp= {}
                    for (var logitem in alogs){
                        if(alogs[logitem].trim()!== "") {
                            itemtmp["iLogPath"] =alogs[logitem]
                            logsList.append(itemtmp)
                        }
                    }

                    emptyLabel.text = emptyLabel.textToShow

                }

                Component.onCompleted: {
                    logs.loadLogs()
                }
            }


        }
    }
    function createLog(path,name,buffer){
        var ilog =LogViewLib.addLog(pStack,path,name,buffer)
        pStack.push(ilog)
        return ilog
    }
}

