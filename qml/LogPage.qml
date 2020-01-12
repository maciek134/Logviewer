import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "libs/pastebin.js" as PasteBin

Page {
    id: logPage
    property string logname
    property string path
    property string username
    property int interval
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
            text: updateTimer.running ? i18n.tr("Pause") : i18n.tr("Start")
            onTriggered: {
                console.log(pauseaction.text);
                updateTimer.running = !updateTimer.running;
            }
            iconName: updateTimer.running ? "media-playback-pause" : "media-playback-start"
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

    Timer {
        id: updateTimer
        running: true
        interval: interval
        repeat: true
        onTriggered: {
            var xhr = new XMLHttpRequest;
            xhr.open("GET", path);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == XMLHttpRequest.DONE && xhr.responseText) {
                    var formatedText = xhr.responseText.replace(/\n/g, "\n\n")
                    logText.text = formatedText;
                }
            };
            xhr.send();
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            top: logPage.header.bottom
            left: parent.left
            right: parent.right
            bottom: navigationArea.top
            bottomMargin: units.gu(1)
        }

        TextEdit {
            id: logText
            wrapMode: TextEdit.Wrap
            width: scrollView.width
            readOnly: true
            font.pointSize: fontSize
            font.family: "Ubuntu Mono"
            textFormat: TextEdit.PlainText
            textMargin: preferences.commonMargin
            selectByMouse: doselection
            mouseSelectionMode: TextEdit.SelectWords
            persistentSelection: true
            color: theme.palette.normal.fieldText
            selectedTextColor: theme.palette.selected.selectionText
            selectionColor: theme.palette.selected.selection
            Component.onCompleted: updateTimer.start();
        }
    }

    Rectangle {
        id: navigationArea
        width: parent.width
        height: units.gu(5)
        color: theme.palette.normal.background
        anchors.bottom: parent.bottom

        Rectangle {
            id: dividerRect
            width: parent.width
            height: 1
            color: theme.palette.normal.backgroundSecondaryText
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)

            Icon {
                width: units.gu(3)
                height: width
                name: "media-skip-backward"
                rotation: 90
                color: theme.palette.normal.baseText
                MouseArea {
                    anchors.fill: parent
                    onClicked: scrollView.flickableItem.contentY = 0
                }
            }

            Icon {
                width: units.gu(3)
                height: width
                name: "media-playback-start-rtl"
                color: theme.palette.normal.baseText
                MouseArea {
                    anchors.fill: parent
                    onClicked: scrollView.flickableItem.contentY = scrollView.flickableItem.contentY - scrollView.height*0.95
                }
            }

            Icon {
                width: units.gu(3)
                height: width
                name: "media-playback-start"
                color: theme.palette.normal.baseText
                MouseArea {
                    anchors.fill: parent
                    onClicked: scrollView.flickableItem.contentY = scrollView.flickableItem.contentY + scrollView.height*0.95
                }
            }

            Icon {
                width: units.gu(3)
                height: width
                name: "media-skip-forward"
                rotation: 90
                color: theme.palette.normal.baseText
                MouseArea {
                    anchors.fill: parent
                    onClicked: scrollView.flickableItem.contentY = scrollView.flickableItem.contentHeight - scrollView.height
                }
            }
        }
    }
}
