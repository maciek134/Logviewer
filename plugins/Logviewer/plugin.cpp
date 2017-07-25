#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "logviewer.h"

void LogViewerPlugin::registerTypes(const char *uri) {
    //@uri Template
    qmlRegisterType<LogViewer>(uri, 1, 0, "LogViewer");
}

void LogViewerPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
