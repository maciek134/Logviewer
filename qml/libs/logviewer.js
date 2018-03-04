.pragma library

var logSrc = "../ui/LogPage.qml";
var mlog = Qt.createComponent(logSrc);

function addLog (window, path, name,buffer){
    if (mlog.errorString() !== "") console.log(mlog.errorString());
    var dynamicObject = mlog.createObject(window, { "logname":name, "path":path, "buffer":buffer });
    return dynamicObject;
}
