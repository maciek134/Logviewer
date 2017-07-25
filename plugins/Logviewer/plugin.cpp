#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "logviewer.h"

void LogViewerPlugin::registerTypes(const char *uri) {
    //@uri Template
    qmlRegisterSingletonType<LogViewer>(uri, 1, 0, "LogViewer", [](QQmlEngine*, QJSEngine*) -> QObject* { return new LogViewer; });
}
