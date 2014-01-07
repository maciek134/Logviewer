TEMPLATE = lib
TARGET = logviewer
QT += qml quick
CONFIG += qt plugin no_keywords

#comment in the following line to disable traces
#DEFINES += QT_NO_DEBUG_OUTPUT

TARGET = $$qtLibraryTarget($$TARGET)
uri = logviewer

INCLUDEPATH += .

# Input
HEADERS += backend.h \
    logviewer.h \
    logreaderservice.h
SOURCES += backend.cpp \
    logviewer.cpp \
    logreaderservice.cpp

# Install path for the plugin
installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
target.path = $$installPath
INSTALLS += target

# find files
QMLDIR_FILE = qmldir

# make visible to qt creator
OTHER_FILES += $$QMLDIR_FILE  

# create install targets for files
qmldir.path = $$installPath
qmldir.files = $$QMLDIR_FILE

INSTALLS += qmldir

