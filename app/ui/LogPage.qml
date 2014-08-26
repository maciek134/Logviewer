import QtQuick 2.0
import Ubuntu.Components 1.1
import Logviewer 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0
import "../libs/pastebin.js" as PasteBin


Page {
    id: logPage
    property string logname
    property alias path: mLogViewer.filePath
    property string username
    property alias filter: mLogViewer.logFilter
    property bool readingLog : true
    property bool autoscroll: true
    property alias buffer: mLogViewer.logBuffer
    property bool doselection: false
    property alias fontsize: logText.font.pointSize
    property int maxTitle: 14
    property int iconSize: units.gu(4)
    property bool logDie: false
    property var __popover: null
    property bool dialogError: false
    property string dialogText

    title: logname.length > maxTitle? ".."+logname.slice(logname.length-maxTitle-1,logname.length) :
                                     logname
    visible: false

    LogViewer {
        id: mLogViewer
        onLogTextChanged: {
            if(autoscroll) flickArea.contentY= logText.height-logPage.height
        }
        onLogStopped: {
            if(logDie) logPage.destroy()
        }
    }
    ListModel {  id:logsList  }

    Connections {
        target: head.backAction
        onTriggered: {
            toolbar.pageStack.pop()
            logDie=true
            mLogViewer.stopLog()
        }
    }

    head.actions: [
        Action {
            id: pauseaction
            text: readingLog ? i18n.tr("Pause") : i18n.tr("Start")
            onTriggered: {
                if (readingLog){
                    mLogViewer.stopLog()
                } else {
                    mLogViewer.openLog()
                }
                readingLog = !readingLog
                console.log("Action is " + pauseaction.text)
            }
            iconName: readingLog ? "media-playback-pause" : "media-playback-start"
        },
        Action {
            text: i18n.tr("Clear")
            onTriggered: mLogViewer.clearLog()
            iconName: "clear"
        },
        Action {
            text: doselection? i18n.tr("Copy") : i18n.tr("Select")
            onTriggered: {
                if (doselection) {
                    Clipboard.push(logText.selectedText)
                    logText.select(0,0)

                }
                doselection =!doselection
            }
            iconName: doselection ? "browser-tabs" : "edit"
        },
        Action {
            text: i18n.tr("PasteBin")
            onTriggered: {
                __popover=PopupUtils.open(progress)
                var uploadText = logText.selectedText
                if (uploadText === "") uploadText = logText.text
                PasteBin.post(i18n.tr("From file ")+ path+ ":\n" + uploadText, username,
                              function on_success(url){
                                  console.log("url is "+url)
                                  Clipboard.push(url)
                                  logText.select(0,0)
                                  PopupUtils.close(__popover)
                                  __popover=null
                                  logPage.dialogError = false;
                                  logPage.dialogText = "<a href=\""+url+"\">"+url+"</a>"
                                  PopupUtils.open(resultsD)
                              },
                              function on_failure(why){
                                  console.log("error is " + why)
                                  logText.select(0,0)
                                  PopupUtils.close(__popover)
                                  __popover=null
                                  logPage.dialogError = true;
                                  PopupUtils.open(resultsD)
                              })
                doselection =!doselection

            }
            iconName: "keyboard-caps-disabled"
        }
    ]

    Component {
        id: progress
        Popover {
            id: mpopover
            autoClose: false
            anchors.centerIn: parent

            ActivityIndicator {
                id: spinner_pastebin
                running: true
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: units.gu(1)
                anchors.left: parent.left

            }
            ListItem.Standard {
                anchors.verticalCenter: parent.verticalCenter
                text: i18n.tr("Sending to Pastebin..")
                anchors.left: spinner_pastebin.right
                anchors.leftMargin: units.gu(1)
            }
        }
    }

    Component {
        id: resultsD
        Dialog {
            id: dialogue
            title: logPage.dialogError ? i18n.tr("Pastebin Error") : i18n.tr("Pastebin Successful")

            Label {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: logPage.dialogError ? i18n.tr("Error ocurred uploading to Pastebin") : logPage.dialogText +
                                            i18n.tr("<br>(Copied to clipboard)")

                onLinkActivated: Qt.openUrlExternally(link)
            }

            Button {
                text: "OK"
                onClicked: PopupUtils.close(dialogue)
            }

        }
    }


    Flickable {
        id: flickArea
        anchors.fill: parent
        contentWidth: logText.width; contentHeight: logText.height
        flickableDirection: Flickable.VerticalFlick
        clip: true
        onFlickStarted: autoscroll =false;
        onFlickEnded:{
            console.log("contenty is " + flickArea.contentY)
            console.log("log text is "+ logText.height + " and page is " + logPage.height)
            if (flickArea.contentY > logText.height-logPage.height*2) autoscroll=true

        }
        TextEdit {
            id: logText
            wrapMode: TextEdit.Wrap
            width: logPage.width
            text: mLogViewer.logText
            readOnly: true
            font.pointSize: 12
            selectByMouse: doselection
            mouseSelectionMode: TextEdit.SelectWords

        }

    }
    Scrollbar {
        flickableItem: flickArea
        align: Qt.AlignTrailing
    }
    Component.onCompleted: mLogViewer.openLog()
}
