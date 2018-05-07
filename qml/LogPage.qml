import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "libs/pastebin.js" as PasteBin

Page {
    id: logPage
    property string logname
    property string path
    property string username
    property bool autoscroll: true
    property bool doselection: false
    property int fontSize
    property var __popover: null
    property bool dialogError: false
    property string dialogText

    header: PageHeader {
        title: logname

        leadingActionBar.actions: Action {
            text: i18n.tr("Back")
            iconName: "back"
            onTriggered: pageStack.pop()
        }

        trailingActionBar.actions: [
        Action {
            id: pauseaction
            text: autoscroll ? i18n.tr("Pause") : i18n.tr("Start")
            onTriggered: {
                autoscroll = !autoscroll;
                console.log("Action is " + pauseaction.text);
            }
            iconName: autoscroll ? "media-playback-pause" : "media-playback-start"
        },
        Action {
            text: doselection ? i18n.tr("Copy") : i18n.tr("Select")
            iconName: doselection ? "browser-tabs" : "edit"
            onTriggered: {
                if (doselection) {
                    Clipboard.push(logText.selectedText);
                    logText.select(0,0);
                }
                doselection = !doselection;
            }
        },
        Action {
            text: i18n.tr("PasteBin")
            iconName: "external-link"
            onTriggered: {
                console.log("try to paste to pastebin");
                __popover=PopupUtils.open(progress);
                var uploadText = logText.selectedText;

                if (uploadText === "") {
                    console.log("Text to upload is empty. Pasting the whole text...");
                    uploadText = logText.text;
                }

                PasteBin.post("Published using Logviewer for Ubuntu Touch\nFrom file " + path + ":\n" + uploadText, username,
                function on_success(url) {
                    console.log("url is " + url);
                    Clipboard.push(url);
                    logText.select(0, 0);
                    PopupUtils.close(__popover);
                    __popover=null;
                    logPage.dialogError = false;
                    logPage.dialogText = "<a href=\"" + url + "\">" + url + "</a>";
                    PopupUtils.open(resultsD);
                },
                function on_failure(why) {
                    console.log("error is " + why);
                    logText.select(0, 0);
                    PopupUtils.close(__popover);
                    __popover = null;
                    logPage.dialogError = true;
                    PopupUtils.open(resultsD);
                })
            }
        }]
    }

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
                text: logPage.dialogError ?
                      i18n.tr("Error ocurred uploading to Pastebin") :
                      logPage.dialogText + i18n.tr("<br>(Copied to clipboard)");

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

        TextEdit {
            id: logText
            wrapMode: TextEdit.Wrap
            width: scrollView.width
            readOnly: true
            font.pointSize: fontSize
            font.family: "Ubuntu Mono"
            selectByMouse: doselection
            mouseSelectionMode: TextEdit.SelectWords
            persistentSelection: true
            color: theme.palette.normal.fieldText
            selectedTextColor: theme.palette.selected.selectionText
            selectionColor: theme.palette.selected.selection
            Component.onCompleted: {
                var xhr = new XMLHttpRequest;
                xhr.open("GET", path);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == XMLHttpRequest.DONE)
                        logText.text = xhr.responseText;
                };
                xhr.send();
            }
        }
    }
}
