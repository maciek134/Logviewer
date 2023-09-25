import QtQuick 2.9
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3

Page {
    id: settingPage

    property alias interval: intervalSlider.value
    property alias hidePush: hidePushHelper.checked
    property alias filter: filterText.text
    property alias dpFontSize: fontslider.value

    signal applyChanges
    signal cancelChanges

    header: PageHeader {
        title: i18n.tr("Settings")
        flickable: scrollView.flickableItem

        leadingActionBar.actions: Action {
            text: i18n.tr("Cancel")
            iconName: "close"
            onTriggered: {
                settingPage.cancelChanges();
                pageStack.pop();
            }
        }

        trailingActionBar.actions: Action {
            text: i18n.tr("Apply")
            iconName: "ok"
            onTriggered: {
                settingPage.applyChanges();
                pageStack.pop();
            }
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Column {
            id: column
            width: scrollView.width

            property int mSpacing: units.gu(2)

            ListItem {
                height: layout.height + (divider.visible ? divider.height : 0)
                divider.visible: !filterInput.visible

                onClicked: {
                    filterInput.visible = !filterInput.visible;
                }

                ListItemLayout {
                    id: layout
                    title.text: "Filter"

                    Label {
                        text: filterText.text
                        SlotsLayout.position: SlotsLayout.Trailing
                    }
                }
            }

            ListItem {
                id: filterInput
                visible: false

                TextField {
                    id: filterText
                    width: parent.width - column.mSpacing * 2
                    anchors {
                        top: parent.top
                        topMargin: column.mSpacing / 2
                        left: parent.left
                        leftMargin: column.mSpacing
                    }
                }
            }

            ListItem {
                height: layout2.height + (divider.visible ? divider.height : 0)
                ListItemLayout {
                    id: layout2
                    title.text: "Hide push helper logs"

                    Switch {
                        id: hidePushHelper
                        SlotsLayout.position: SlotsLayout.Trailing
                    }
                }
            }

            ListItem {
                height: intervalLayout.height + (divider.visible ? divider.height : 0)
                divider.visible: !intervalInput.visible

                onClicked: {
                    intervalInput.visible = !intervalInput.visible;
                }

                ListItemLayout {
                    id: intervalLayout
                    title.text: "Refresh interval"

                    Label {
                        text: intervalSlider.value.toFixed(0) + " ms"
                        SlotsLayout.position: SlotsLayout.Trailing
                    }
                }
            }

            ListItem {
                id: intervalInput
                visible: false

                Slider {
                    id: intervalSlider
                    minimumValue: 50
                    maximumValue: 5000
                    value: 100
                    live: true
                    width: parent.width - column.mSpacing * 2
                    anchors {
                        top: parent.top
                        topMargin: column.mSpacing / 2
                        left: parent.left
                        leftMargin: column.mSpacing
                    }
                    
                    function formatValue(v) {
                        return v.toFixed(0)
                    }
                }
            }

            ListItem {
                height: fontLayout.height + (divider.visible ? divider.height : 0)
                divider.visible: !fontInput.visible

                onClicked: {
                    fontInput.visible = !fontInput.visible;
                }

                ListItemLayout {
                    id: fontLayout
                    title.text: "Font size"

                    Label {
                        text: fontslider.value.toFixed(0)
                        SlotsLayout.position: SlotsLayout.Trailing
                    }
                }
            }

            ListItem {
                id: fontInput
                visible: false

                Slider {
                    id: fontslider
                    minimumValue: 4
                    maximumValue: 24
                    value: 10
                    live: true
                    width: parent.width - column.mSpacing * 2
                    anchors {
                        top: parent.top
                        topMargin: column.mSpacing / 2
                        left: parent.left
                        leftMargin: column.mSpacing
                    }
                    
                    function formatValue(v) {
                        return v.toFixed(0)
                    }
                }
            }
        }
    }
}
