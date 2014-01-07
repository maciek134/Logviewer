import QtQuick 2.0
import Ubuntu.Components 0.1
import logviewer 1.0
import Ubuntu.Components.ListItems 0.1 as ListItem

Page {
    id:logPage
    property string logname
    property alias path:mLogViewer.filePath
    property alias filter: mLogViewer.logFilter
    property bool readingLog : true
    property bool autoscroll: true
    property alias buffer: mLogViewer.logBuffer
    property bool doselection:false
    property alias fontsize: logText.font.pointSize
    property int maxTitle:14
    property int iconSize:units.gu(4)

    title:logname.length > maxTitle? ".."+logname.slice(logname.length-maxTitle-1,logname.length-1) :
                                     logname
    visible: false

    LogViewer {
        id: mLogViewer
        onLogTextChanged: {
            if(autoscroll) flickArea.contentY= logText.height-logPage.height
        }
    }
    ListModel {  id:logsList  }
    tools: ToolbarItems {
        ToolbarButton {
            action: Action {
                text: readingLog? i18n.tr("Pause") : i18n.tr("Start")
                onTriggered: {
                    if (readingLog){
                        mLogViewer.stopLog()
                    } else {
                        mLogViewer.openLog()
                    }
                    readingLog = !readingLog
                }
                iconSource: readingLog?Qt.resolvedUrl("image://theme/media-playback-pause"):
                                        Qt.resolvedUrl("image://theme/media-playback-start")
            }
        }
        ToolbarButton {
            action: Action {
                text: i18n.tr("Clear")
                onTriggered: mLogViewer.clearLog()
                iconSource: Qt.resolvedUrl("image://theme/clear")
            }
        }
        ToolbarButton {
            action: Action {
                text: doselection? i18n.tr("Select") : i18n.tr("Copy")
                onTriggered: {
                    if (doselection) {
                        Clipboard.push(logText.selectedText)
                        logText.select(0,0)
                    }
                    doselection =!doselection
                }
                iconSource: doselection?Qt.resolvedUrl("image://theme/browser-tabs"):
                                        Qt.resolvedUrl("image://theme/edit")
            }
        }
    }


    Flickable {
        id: flickArea
        anchors.fill: parent
        contentWidth: logText.width; contentHeight: logText.height
        flickableDirection: Flickable.VerticalFlick
        clip: true
        onFlickStarted: autoscroll =false;
        onFlickEnded:{
            console.log("contenty is " + flickArea.contentY)
            console.log("log text is "+ logText.height + " and page is " + logPage.height)
            if (flickArea.contentY > logText.height-logPage.height*2) autoscroll=true

        }
        TextEdit{
            id: logText
            wrapMode: TextEdit.Wrap
            width:logPage.width
            text:mLogViewer.logText
            readOnly:true
            font.pointSize:12
            selectByMouse:doselection
            mouseSelectionMode:TextEdit.SelectWords

        }

    }
    Scrollbar {
        flickableItem: flickArea
        align: Qt.AlignTrailing
    }
    Component.onCompleted: mLogViewer.openLog()
}
