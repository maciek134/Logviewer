import QtQuick 2.9
import Lomiri.Components 1.3
import Qt.labs.folderlistmodel 1.0
import kjournald 1.0
import LomiriAppLaunch 1.0
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
        id: defaultHeader
        title: i18n.tr("Ubuntu Touch Logs")
        flickable: scrollView.flickableItem
    }
    state: "defaultState"

    states: [
        State {
          id: defaultState
          name: "defaultState"

          property list<QtObject> trailingActions: [
              Action {
                  text: i18n.tr("Settings")
                  onTriggered: mainView.showSettings()
                  iconName: "settings"
              },
              Action {
                  text: i18n.tr("About")
                  onTriggered: pStack.push(Qt.resolvedUrl("AboutPage.qml"))
                  iconName: "info"
              },
              Action {
                  iconName: "search"
                  text: i18n.tr("Search")
                  onTriggered: {
                      mainPage.state = "searchState";
                      searchField.forceActiveFocus();
                  }
              }
          ]

          PropertyChanges {
              target: defaultHeader
              trailingActionBar.actions: defaultState.trailingActions
              leadingActionBar.actions:  []
          }
        },

        State {
            id: searchState
            name: "searchState"

            property list<QtObject> leadingActions: [
                Action {
                    iconName: "back"
                    shortcut: "Esc"
                    onTriggered: mainPage.state = "defaultState"
                }
            ]

            PropertyChanges {
                target: defaultHeader
                trailingActionBar.actions: []
                contents: searchField
                leadingActionBar.actions: searchState.leadingActions
            }

            PropertyChanges {
                target: searchField
                text: ""
            }
        }
    ]

    TextField {
        id: searchField
        visible: mainPage.state == "searchState"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        inputMethodHints: Qt.ImhNoPredictiveText
        placeholderText: i18n.tr("Search")
    }

    JournaldUniqueQueryModel {
        id: unitsList
        field: "_SYSTEMD_USER_UNIT"
    }

    SortFilterModel {
        id: filteredModel
        model: unitsList
        filter.property: "field"
        filter.pattern: mainPage.state == "searchState" ? RegExp(searchField.text, "gi") : RegExp("", "gi")
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: logsListView
            anchors.fill: parent
            model: filteredModel
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
            visible: unitRegex.test(model.field) && !preferences.hidePush || !Utils.isPush(model.field)

            property var parsed: Utils.parseServiceName(model.field)
            property var iconAndName: parsed.fullName ? LomiriAppLaunch.iconAndName(parsed.fullName) : []

            onVisibleChanged: {
                if (!visible) {
                    height = 0;
                } else {
                    height = undefined;
                }
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("LogPage.qml"), {
                    logname: Utils.parsedNameToString(parsed, iconAndName),
                    unit: model.field,
                    fontSize: FontUtils.sizeToPixels("medium") * preferences.dpFontSize / 10,
                });
            }

            ListItemLayout {
                anchors.centerIn: parent
                title.text: Utils.parsedNameToString(parsed, iconAndName)
                subtitle.text: i18n.tr("systemd unit") + ": " + model.field

                Component {
                    id: shape
                    LomiriShape {
                        source: Image {
                            source: `file://${iconAndName[0]}`
                        }
                        radius: "large"
                        width: units.gu(5)
                        height: width
                    }
                }

                Loader {
                    sourceComponent: shape
                    active: iconAndName.length > 0
                    SlotsLayout.position: SlotsLayout.Leading
                    SlotsLayout.padding {
                        leading: 0
                        trailing: 0
                    }
                }

                Icon {
                    width: units.gu(2);
                    height: width
                    name: "go-next"
                    SlotsLayout.position: SlotsLayout.Trailing
                }
            }
        }
    }
}
