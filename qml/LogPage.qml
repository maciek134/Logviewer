import QtQuick 2.9
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "libs/pastebin.js" as PasteBin

Page {
    id: logPage
    property string logname
    property string path
    property int interval
    property bool doselection: false
    property int fontSize
    property var __popover: null
    property bool dialogError: false
    property string dialogText
    property bool isLogging: true

    header: PageHeader {
        title: i18n.tr("Log")

        height: units.gu(8)

        Label {
            id: lognameString
            width: parent.width - units.gu(5) //subtract the left margin from parent width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: units.gu(1)
            anchors.leftMargin: units.gu(5)
            anchors.left: parent.left
            elide: Text.ElideRight
            text: logname
        }

        leadingActionBar.actions: Action {
            text: i18n.tr("Back")
            iconName: "back"
            onTriggered: pageStack.pop()
        }

        trailingActionBar.numberOfSlots: 5
        trailingActionBar.actions: [
        Action {
            id: pauseaction
            text: updateTimer.running ? i18n.tr("Pause") : i18n.tr("Start")
            iconName: "media-playback-pause"
            onTriggered: {
                isLogging ? viewing() : logging ();
                console.log(pauseaction.text);
            }
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
            text: i18n.tr("Copy all")
            iconName: "edit-copy"
            onTriggered: Clipboard.push(logText.text);
        },
        Action {
            text: i18n.tr("Dpaste")
            iconName: "external-link"
            onTriggered: {
                console.log("try to paste to dpaste");
                __popover=PopupUtils.open(progress);
                var uploadText = logText.selectedText;

                if (uploadText === "") {
                    console.log("Text to upload is empty. Pasting the whole text...");
                    uploadText = logText.text;
                }

                PasteBin.post("Published using Logviewer for Ubuntu Touch\nFrom file " + path + ":\n" + uploadText,
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
        },
        Action {
            text: i18n.tr("Share")
            onTriggered: pStack.push(Qt.resolvedUrl("SharePage.qml"), {"url": path})
            iconName: "share"
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

                title.text: i18n.tr("Sending to dpaste..")

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
            title: logPage.dialogError ? i18n.tr("Dpaste Error") : i18n.tr("Dpaste Successful")

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
            scrollView.flickableItem.contentY = scrollView.flickableItem.contentHeight - scrollView.height
        }
    }

    ScrollView {
        id: scrollView
        anchors {
            top: navigationArea.bottom
            topMargin: units.gu(1)
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

        flickableItem.onMovementStarted: {
            viewing();
            console.log(pauseaction.text);
        }
    }

    Rectangle {
        id: navigationArea
        width: parent.width
        height: 0
        color: theme.palette.normal.base
        anchors.top: header.bottom
        visible: false

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)

            Icon {
                id: topButton
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
                id: pageUpButton
                width: units.gu(2.5)
                height: width
                anchors.bottom: topButton.bottom
                anchors.bottomMargin: units.gu(0.1)
                name: "media-playback-start-rtl"
                rotation: 90
                color: theme.palette.normal.baseText
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        scrollView.flickableItem.contentY = scrollView.flickableItem.contentY - scrollView.height*0.95;
                        scrollView.flickableItem.returnToBounds();
                        //alternative implementation without the flicker of returnToBounds
                        //doesn't give a visual feedback that the top has been reached though
                        // if ((scrollView.flickableItem.contentY - scrollView.height*0.95) > 0) {
                        //     scrollView.flickableItem.contentY = scrollView.flickableItem.contentY - scrollView.height*0.95;
                        // } else {
                        //     scrollView.flickableItem.contentY = 0;
                        // }
                    }
                }
            }

            Label { id: spacer; text: "-"; color: theme.palette.normal.base}

            Icon {
                id: pageDownButton
                width: units.gu(2.5)
                height: width
                anchors.top: bottomButton.top
                anchors.topMargin: units.gu(0.1)
                name: "media-playback-start"
                rotation: 90
                color: theme.palette.normal.baseText
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        scrollView.flickableItem.contentY = scrollView.flickableItem.contentY + scrollView.height*0.95;
                        scrollView.flickableItem.returnToBounds();
                        //alternative implementation without the flicker of returnToBounds
                        //doesn't give a visual feedback that the end has been reached though
                        // if ((scrollView.flickableItem.contentY + scrollView.height*0.95) < (scrollView.flickableItem.contentHeight - scrollView.height)) {
                        //     scrollView.flickableItem.contentY = scrollView.flickableItem.contentY + scrollView.height*0.95;
                        // } else {
                        //     scrollView.flickableItem.contentY = scrollView.flickableItem.contentHeight - scrollView.height
                        // }
                    }
                }
            }

            Icon {
                id: bottomButton
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

    function logging () {
        updateTimer.running = true;
        pauseaction.iconName = "media-playback-pause";
        navigationArea.visible = false;
        navigationArea.height = 0;
        scrollView.flickableItem.contentY = scrollView.flickableItem.contentHeight - scrollView.height;
        isLogging = true;
    }

    function viewing () {
        updateTimer.running = false;
        pauseaction.iconName = "media-playback-start";
        navigationArea.height = units.gu(5);
        navigationArea.visible = true;
        isLogging = false;
    }
}
