import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Logviewer 1.0

import "libs/pastebin.js" as PasteBin

Page {
    id: logPage
    property string logname
    property alias path: mLogViewer.filePath
    property string username
    property alias filter: mLogViewer.logFilter
    property bool readingLog: true
    property bool autoscroll: true
    property alias buffer: mLogViewer.logBuffer
    property bool doselection: false
    property alias fontSize: logText.font.pixelSize
    property int maxTitle: 14
    property int iconSize: units.gu(4)
    property bool logDie: false
    property var __popover: null
    property bool dialogError: false
    property string dialogText

    header: PageHeader {
        title: logname.length > maxTitle
               ? ".."+logname.slice(logname.length-maxTitle-1,logname.length)
               : logname

        leadingActionBar.actions: Action {
            text: i18n.tr("Back")
            iconName: "back"
            onTriggered: {
                if (readingLog) {
                    // Page gets closed by mLogViewer.onLogStopped slot,
                    // after we have cleaned all the threads.
                    logDie = true;
                    mLogViewer.stopLog()
                } else {
                    pageStack.pop()
                }
            }
        }

        trailingActionBar.actions: [
            Action {
                id: pauseaction
                text: readingLog ? i18n.tr("Pause") : i18n.tr("Start")
                onTriggered: {
                    readingLog ? mLogViewer.stopLog() : mLogViewer.openLog()
                    readingLog = !readingLog
                    console.log("Action is " + pauseaction.text)
                }
                iconName: readingLog ? "media-playback-pause" : "media-playback-start"
            },
            Action {
                text: i18n.tr("Clear")
                onTriggered: mLogViewer.clearLog()
                iconName: "edit-clear"
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
                iconName: "external-link"
                onTriggered: {
                    __popover=PopupUtils.open(progress)
                    var uploadText = logText.selectedText

                    if (uploadText === "") {
                        console.log("Text to upload is empty. Pasting the whole text...")
                        uploadText = logText.text
                    }

                    PasteBin.post(i18n.tr("From file ")+ path + ":\n" + uploadText, username,
                                  function on_success(url) {
                                      console.log("url is "+url)
                                      Clipboard.push(url)
                                      logText.select(0,0)
                                      PopupUtils.close(__popover)
                                      __popover=null
                                      logPage.dialogError = false;
                                      logPage.dialogText = "<a href=\""+url+"\">"+url+"</a>"
                                      PopupUtils.open(resultsD)
                                  },
                                  function on_failure(why ){
                                      console.log("error is " + why)
                                      logText.select(0,0)
                                      PopupUtils.close(__popover)
                                      __popover=null
                                      logPage.dialogError = true;
                                      PopupUtils.open(resultsD)
                                  })
                }
            }
        ]
    }

    visible: false

    LogViewer {
        id: mLogViewer
        onLogStopped: if (logDie) pageStack.pop()
        onLogTextChanged: {
            if(autoscroll) flickArea.contentY= logText.height-scrollView.height
        }
    }

    ListModel {  id:logsList  }

    Component {
        id: progress
        Popover {
            id: mpopover
            autoClose: false
            anchors.centerIn: parent

            ListItemLayout {
                anchors.verticalCenter: parent.verticalCenter

                title.text: i18n.tr("Sending to Pastebin..")

                ActivityIndicator {
                    running: true
                    SlotsLayout.position: SlotsLayout.Leading
                }
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
                text: i18n.tr("OK")
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            top: logPage.header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
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
                console.log("log text is "+ logText.height + " and scrollview is " + scrollView.height)
                if (flickArea.contentY > logText.height-scrollView.height*2) autoscroll=true
            }

            TextEdit {
                id: logText
                wrapMode: TextEdit.Wrap
                width: scrollView.width
                text: mLogViewer.logText
                readOnly: true
                font.pointSize: 12
                selectByMouse: doselection
                mouseSelectionMode: TextEdit.SelectWords
                persistentSelection: true
                color: theme.palette.normal.fieldText
                selectedTextColor: theme.palette.selected.selectionText
                selectionColor: theme.palette.selected.selection
            }
        }
    }

    Component.onCompleted: mLogViewer.openLog()
}
