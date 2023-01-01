import QtQuick 2.9
import QtQuick.Controls 2.5 as QQC2
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import kjournald 1.0
import "libs/pastebin.js" as PasteBin
import "libs/utils.js" as Utils

Page {
    id: logPage
    property string logname
    property string unit
    property int fontSize
    property bool dialogError: false
    property string dialogText

    QtObject {
        id: d

        property bool isSelecting: false
        property bool isLogging: true
        property var __popover: null
        property int selectionStart: -1
        property int selectionEnd: -1
        property bool hasSelection: selectionStart !== -1 && selectionEnd !== -1

        function logging() {
            updateTimer.running = true;
            pauseaction.iconName = "media-playback-pause";
            navigationArea.visible = false;
            navigationArea.height = 0;
            isLogging = true;
        }

        function viewing() {
            updateTimer.running = false;
            pauseaction.iconName = "media-playback-start";
            navigationArea.height = units.gu(5);
            navigationArea.visible = true;
            isLogging = false;
        }

        function isInSelection(index) {
            return selectionStart <= index && selectionEnd >= index;
        }

        function clearSelection() {
            setSelection(-1, -1);
        }

        function setSelection(start, end) {
            selectionStart = start;
            selectionEnd = end;
        }

        function modelToText(start, end) {
            const lines = [];
            for (let i = start; i <= end; i++) {
                const index = logModel.index(i, 0);
                const datetime = logModel.data(index, Qt.UserRole + 3);
                const message = logModel.data(index, Qt.DisplayRole);
                if (typeof datetime !== 'undefined' && typeof message !== 'undefined') {
                    lines.push(Utils.logLineToString({ datetime, message }));
                }
            }
            return lines.join('\n');
        }

        function selectionToText() {
            return modelToText(selectionStart, selectionEnd);
        }

        function fullModelToText() {
            return modelToText(0, logModel.rowCount());
        }
    }

    JournaldViewModel {
        id: logModel
        systemdUserUnitFilter: [ unit ]

        Component.onCompleted: {
            listView.positionViewAtEnd();
            listView.currentIndex = 0;
            
            // load the full log
            // needed because ScrollView is weird and can't properly load items on demand
            // also makes "copy all" a bit easier
            const parent = logModel.parent(logModel.index(0, 0));
            while (logModel.canFetchMore(parent)) {
                logModel.fetchMore(parent);
                listView.positionViewAtEnd();
                listView.currentIndex = 0;
            }
        }
    }

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
            onTriggered: d.isLogging ? d.viewing() : d.logging()
        },
        Action {
            text: d.isSelecting ? i18n.tr("Copy") : i18n.tr("Select")
            iconName: d.isSelecting ? "browser-tabs" : "edit"
            onTriggered: {
                if (d.isSelecting) {
                    Clipboard.push(d.selectionToText());
                    d.clearSelection();
                }
                d.isSelecting = !d.isSelecting;
            }
        },
        Action {
            text: i18n.tr("Copy all")
            iconName: "edit-copy"
            onTriggered: {
                Clipboard.push(d.fullModelToText());
            }
        },
        Action {
            text: i18n.tr("Dpaste")
            iconName: "external-link"
            onTriggered: {
                console.log("try to paste to dpaste");
                d.__popover = PopupUtils.open(progress);
                const uploadText = d.hasSelection ? d.selectionToText() : d.fullModelToText();

                if (!d.hasSelection) {
                    console.log("Text to upload is empty. Pasting the whole text...");
                }

                PasteBin.post(
                    uploadText,
                    unit,
                    (url) => {
                        console.log("url is", url);
                        Clipboard.push(url);
                        d.clearSelection();
                        PopupUtils.close(d.__popover);
                        d.__popover = null;
                        logPage.dialogError = false;
                        logPage.dialogText = `<a href="${url}">${url}</a>`;
                        PopupUtils.open(resultsD);
                    },
                    (error) => {
                        console.log("error is", error);
                        d.clearSelection();
                        PopupUtils.close(d.__popover);
                        d.__popover = null;
                        logPage.dialogError = true;
                        PopupUtils.open(resultsD);
                    },
                );
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
            const parent = logModel.parent(logModel.index(0, 0));
            logModel.fetchMore(parent);
            listView.positionViewAtEnd();
            listView.currentIndex = 0;
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

        ListView {
            id: listView
            anchors.fill: parent
            model: logModel
            delegate: logLineDelegate
            spacing: fontSize / 2
        }

        flickableItem.onMovementStarted: {
            d.viewing();
        }
    }

    MouseArea {
        anchors.fill: scrollView
        enabled: d.isSelecting
        preventStealing: d.isSelecting

        property int firstIndex: -1
        property int lastIndex: -1
        property bool isSelecting: true

        function doSelection(mouse, first) {
            const index = listView.indexAt(mouse.x, mouse.y + scrollView.flickableItem.contentY);
            if (index === lastIndex || index === -1) {
                return;
            }

            // allow scrolling while selecting
            listView.currentIndex = index;
            if (index > lastIndex) {
                listView.positionViewAtIndex(index + 1, ListView.Visible);
            } else {
                listView.positionViewAtIndex(index - 1, ListView.Visible);
            }

            lastIndex = index;

            if (first) {
                firstIndex = index;
                d.setSelection(index, index);
                return;
            }

            if (index <= firstIndex) {
                d.setSelection(index, firstIndex);
            } else {
                d.setSelection(firstIndex, index);
            }
        }

        onPressed: {
            doSelection(mouse, true);
        }

        onReleased: {
            lastIndex = -1;
            firstIndex = -1;
        }

        onPositionChanged: doSelection(mouse)
    }

    Component {
        id: logLineDelegate

        QQC2.Label {
            property bool selected: d.isInSelection(index)

            text: Utils.logLineToString(model)
            textFormat: Text.PlainText
            font.pointSize: fontSize
            font.family: "Ubuntu Mono"
            color: selected ? theme.palette.selected.selectionText : theme.palette.normal.fieldText
            wrapMode: Text.Wrap
            width: parent.width - preferences.commonMargin * 2
            x: preferences.commonMargin

            background: Rectangle {
                color: selected ? theme.palette.selected.selection : 'transparent'
                x: -preferences.commonMargin
                y: -listView.spacing
                height: parent.height + listView.spacing
                width: parent.width + preferences.commonMargin * 2
            }
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
                    onClicked: {
                        listView.positionViewAtBeginning();
                        listView.currentIndex = listView.count - 1;
                    }
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
                    onClicked: {
                        listView.positionViewAtEnd();
                        listView.currentIndex = 0;
                    }
                }
            }
        }
    }
}
