import QtQuick 2.0
import Ubuntu.Components 0.1
import "ui"
import "./libs/logviewer.js" as LogViewLib
import logviewer 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem



/*!
    \brief MainView with Tabs element.
           First Tab has a single Label and
           second Tab has a single ToolbarAction.
*/

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
    property var preferences: {"dir":"/home/phablet/.cache/upstart/", "filter":"*.log", "buffer":8000, "username":"Guest"}


    PageStack {
        id: pStack
        Component.onCompleted: push(page0)
        PerfPage {
            id:msettings
            onCancelChanges: {
                loadStandardSettings()
                pStack.pop()
            }
            onApplyChanges: {
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
                msettings.bufferSize= preferences.buffer
                msettings.directory=preferences.dir
                msettings.filter=preferences.filter
                msettings.username=preferences.username
            }
        }
        Page {
            id:page0
            title: "Ubuntu Logs"
            visible: false
            ListModel {  id:logsList  }
            tools: ToolbarItems {
                ToolbarButton {
                    action: Action {
                        text: i18n.tr("Settings")
                        onTriggered: pStack.push(msettings)
                        iconSource: Qt.resolvedUrl("image://theme/properties")
                    }
                }

                ToolbarButton {
                    action: Action {
                        text: "Reload"
                        onTriggered:logs.loadLogs()
                        iconSource:Qt.resolvedUrl("image://theme/reload")
                    }
                }
            }
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
                            console.log("in page creation, title is " +iname + "file is " +preferences.dir+iLogPath)
                            //create page
                            pageDelegate=createLog(preferences.dir+iLogPath,iname,preferences.buffer)
                            pageDelegate.fontsize=msettings.fontSize
                            pageDelegate.filter=preferences.filter
                            pageDelegate.username=preferences.username
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

