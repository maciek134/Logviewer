import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.folderlistmodel 1.0
import kjournald 1.0
import "libs/utils.js" as Utils

Page {
    id: mainPage
    property var unitRegex: {
        try {
            return new RegExp(preferences.unitFilter.replace(/\*/g, '.*').replace(/\./g, '\\.'));
        } catch (e) {
            return new RegExp('');
        }
    }

    header: PageHeader {
        title: i18n.tr("Ubuntu Touch Logs")
        flickable: scrollView.flickableItem

        trailingActionBar.actions: [
        Action {
            text: i18n.tr("Settings")
            onTriggered: mainView.showSettings()
            iconName: "settings"
        },
        Action {
            text: i18n.tr("About")
            onTriggered: pStack.push(Qt.resolvedUrl("AboutPage.qml"))
            iconName: "info"
        }
        ]
    }

    JournaldUniqueQueryModel {
        id: unitsList
        field: "_SYSTEMD_USER_UNIT"
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: logsListView
            anchors.fill: parent
            model: unitsList
            delegate: logDelegate
            focus: true

            Label {
                id: emptyLabel
                anchors.centerIn: parent
                text: i18n.tr("No logs found for the set filter")
                visible: logsListView.count === 0
            }
        }
    }

    Component{
        id: logDelegate

        ListItem {
            id: logItemDelegate
            visible: unitRegex.test(model.field)
            
            property var parsed: Utils.parseServiceName(model.field)

            onVisibleChanged: {
                if (!visible) {
                    height = 0;
                } else {
                    height = undefined;
                }
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("LogPage.qml"), {
                    logname: Utils.parsedNameToString(parsed),
                    unit: model.field,
                    fontSize: FontUtils.sizeToPixels("medium") * preferences.dpFontSize / 10,
                });
            }

            ListItemLayout {
                anchors.centerIn: parent
                title.text: Utils.parsedNameToString(parsed)
                subtitle.text: i18n.tr("systemd unit") + ": " + model.field

                Icon {
                    width: units.gu(2);
                    height: width
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Last
                }
            }
        }
    }
}
