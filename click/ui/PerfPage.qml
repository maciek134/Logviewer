import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Pickers 0.1


Page {
    id:settingPage
    title:"Settings"
    visible: false
    property alias bufferSize: bufferslider.value
    property alias directory:dirPath.text
    property alias filter:filterText.text
    property alias fontSize:fontslider.value
    property alias username:userText.text

    signal applyChanges
    signal cancelChanges

    Item {
        id:itemSettings
        anchors.fill: parent
        anchors.margins: units.gu(2)
        Grid {
            id:mgrid
            columns: 2
            spacing: units.gu(2)
            property int itemsize: settingPage.width - fontlabel.width -spacing*4

            Label {
                id:dirlabel
                text: i18n.tr("Directory")
                fontSize: "medium"
            }
            TextField {
                id:dirPath
                width:mgrid.itemsize

            }
            Label {
                id:filterlabel
                text: i18n.tr("Filter")
                fontSize: "medium"

            }
            TextField {
                id:filterText
                width:mgrid.itemsize

            }
            Label {
                id:bufferlabel
                text: i18n.tr("Buffer")
                fontSize: "medium"

            }

            Slider {
                id:bufferslider
                function formatValue(v) { return v.toFixed(0) }
                minimumValue: 5000
                maximumValue: 30000
                value: 8000
                live: true
                width:mgrid.itemsize
            }
            Label {
                id:fontlabel
                text: i18n.tr("Font Size")
                fontSize: "medium"

            }

            Slider {
                id:fontslider
                function formatValue(v) { return v.toFixed(0) }
                minimumValue: 8
                maximumValue: 38
                value: 24
                live: true
                width:mgrid.itemsize
            }
            Label {
                id:userlabel
                text: i18n.tr("Pastebin user")
                fontSize: "medium"

            }
            TextField {
                id:userText
                width:mgrid.itemsize
                maximumLength: 30

            }

        }
        Row {
            spacing:units.gu(2)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: mgrid.bottom
            anchors.topMargin: units.gu(2)
            Button {
                text:i18n.tr("Apply")
                onClicked: applyChanges()
            }
            Button{
                text:i18n.tr("Cancel")
                onClicked: cancelChanges()
            }
        }

    }
}
