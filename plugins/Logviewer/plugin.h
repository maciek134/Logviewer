#ifndef TEMPLATEPLUGIN_H
#define TEMPLATEPLUGIN_H

#include <QQmlExtensionPlugin>

class LogViewerPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif
