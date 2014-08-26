import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Layouts 1.0

Page {
    id: aboutPage
    title: i18n.tr("About")
    visible:false

    Flickable {
        id: flickable
        anchors.fill: parent
        clip: true

        contentHeight: aboutColumn.height + 2 * aboutColumn.marginTop //doubled marginTop to get the same margin at the bottom

        Column {
            id: aboutColumn
            spacing: units.gu(2)
            width: parent.width
            property real marginTop: units.gu(3)
            y: marginTop

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("<b>Logviewer</b>")
                fontSize: "x-large"
            }

            UbuntuShape {
                property real maxWidth: units.gu(45)
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, maxWidth)/2
                height: Math.min(parent.width, maxWidth)/2
                image: Image {
                    source: "../../icon.png"
                    smooth: true
                    fillMode: Image.PreserveAspectFit

                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("<b>Authors:</b>")
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Victor Tuson Palau<br><a href=\"mailto:vtuson@gmail.com\">vtuson@gmail.com</a><br>Niklas Wenzel<br><a href=\"mailto:nikwen.developer@gmail.com\">nikwen.developer@gmail.com</a>"
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("<b>Source code:</b>")
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "<a href=\"https://launchpad.net/logviewer\">https://launchpad.net/logviewer</a>"
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Version: <b>0.8</b>")
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true;
                text: "2014"
            }
        }
    }
}
