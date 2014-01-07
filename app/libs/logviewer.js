.pragma library

var logSrc= "../ui/LogPage.qml"
var mlog = Qt.createComponent(logSrc)


function addLog (window, path, name,buffer){
    var dynamicObject = mlog.createObject(window, {
                                              "logname":name,
                                              "path":path,
                                              "buffer":buffer
                                          })
    return dynamicObject
}
