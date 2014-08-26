import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Pickers 1.0
import Ubuntu.Components.ListItems 1.0 as ListItem


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

    head.backAction: Action {
        id: cancelAction
        text: i18n.tr("Cancel")
        iconName: "close"
        onTriggered: cancelChanges()
    }

    head.actions: [
        Action {
            id: applyAction
            text: i18n.tr("Apply")
            iconName: "ok"
            onTriggered: applyChanges()
        }
    ]

    Flickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            anchors {
                right: parent.right
                left: parent.left
                rightMargin: units.gu(2)
                leftMargin: anchors.rightMargin
            }
            height: childrenRect.height

            property real mSpacing: units.gu(2)

            ListItem.Empty {
                height: dirlabel.height + dirPath.height + 2 * column.mSpacing
                Label {
                    id: dirlabel
                    text: i18n.tr("Directory:")
                    fontSize: "medium"
                    anchors.top: parent.top
                    anchors.topMargin: column.mSpacing
                }
                TextField {
                    id: dirPath
                    width: parent.width
                    anchors.top: dirlabel.bottom
                }

            }

            ListItem.Empty {
                height: filterlabel.height + filterText.height + 2 * column.mSpacing
                Label {
                    id: filterlabel
                    text: i18n.tr("Filter:")
                    fontSize: "medium"
                    anchors.top: parent.top
                    anchors.topMargin: column.mSpacing

                }
                TextField {
                    id: filterText
                    width: parent.width
                    anchors.top: filterlabel.bottom

                }

            }

            ListItem.Empty {
                height: bufferlabel.height + bufferslider.height + column.mSpacing
                Label {
                    id:bufferlabel
                    text: i18n.tr("Buffer:")
                    fontSize: "medium"
                    anchors.top: parent.top
                    anchors.topMargin: column.mSpacing

                }

                Slider {
                    id:bufferslider
                    function formatValue(v) { return v.toFixed(0) }
                    minimumValue: 5000
                    maximumValue: 30000
                    value: 8000
                    live: true
                    width: parent.width
                    anchors.top: bufferlabel.bottom
                }

            }

            ListItem.Empty {
                height: fontlabel.height + fontslider.height + column.mSpacing
                Label {
                    id:fontlabel
                    text: i18n.tr("Font Size:")
                    fontSize: "medium"
                    anchors.top: parent.top
                    anchors.topMargin: column.mSpacing

                }

                Slider {
                    id:fontslider
                    function formatValue(v) { return v.toFixed(0) }
                    minimumValue: 8
                    maximumValue: 38
                    value: 24
                    live: true
                    width: parent.width
                    anchors.top: fontlabel.bottom
                }

            }

            ListItem.Empty {
                height: userlabel.height + userText.height + 2 * column.mSpacing
                divider.visible: false //No divider at the end of the list
                Label {
                    id:userlabel
                    text: i18n.tr("Pastebin user:")
                    fontSize: "medium"
                    anchors.top: parent.top
                    anchors.topMargin: column.mSpacing

                }
                TextField {
                    id:userText
                    maximumLength: 30
                    width: parent.width
                    anchors.top: userlabel.bottom

                }
            }

        }
    }
}
