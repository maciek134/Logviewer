import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: aboutPage

    header: PageHeader {
        title: i18n.tr("About")
    }

    ScrollView {
        id: scrollView
        anchors {
            top: aboutPage.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        clip: true

        Column {
            id: aboutColumn
            spacing: units.gu(2)
            width: scrollView.width

            // TODO: Qt 5.6 added 'topPadding' property.
            Item { width: 1; height: units.gu(3) /* top margin */ }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Logviewer")
                textSize: Label.XLarge
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Version %1").arg("0.9")
            }

            UbuntuShape {
                property real maxWidth: units.gu(45)
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width, maxWidth)/2
                height: Math.min(parent.width, maxWidth)/2
                image: Image {
                    source: "../graphics/logviewer.png"
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Authors:")
                font.weight: Font.DemiBold
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Victor Tuson Palau<br><a href=\"mailto:vtuson@gmail.com\">vtuson@gmail.com</a><br>Niklas Wenzel<br><a href=\"mailto:nikwen.developer@gmail.com\">nikwen.developer@gmail.com</a>"
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: i18n.tr("Source code:")
                font.weight: Font.DemiBold
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "<a href=\"https://launchpad.net/logviewer\">https://launchpad.net/logviewer</a>"
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                font.weight: Font.DemiBold
                text: "2014-2016"
            }
        }
    }
}
