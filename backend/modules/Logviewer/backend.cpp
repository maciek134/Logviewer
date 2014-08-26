#include <QtQml>
#include <QtQml/QQmlContext>
#include "backend.h"
#include "logviewer.h"


void BackendPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("logviewer"));

    qmlRegisterType<LogViewer>(uri, 1, 0, "LogViewer");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
    QQmlExtensionPlugin::initializeEngine(engine, uri);
}
