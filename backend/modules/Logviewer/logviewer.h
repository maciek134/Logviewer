#ifndef LOGVIEWER_H
#define LOGVIEWER_H

#include <QObject>
#include <QTextStream>
#include <QDebug>
#include <QFile>
#include <QThread>
#include "logreaderservice.h"
#include <QList>


class LogViewer : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString filePath READ filePath WRITE setfilePath NOTIFY filePathChanged )
    Q_PROPERTY( QString logDir READ logDir WRITE setlogDir NOTIFY logDirChanged )
    Q_PROPERTY( QString logText READ logText NOTIFY logTextChanged )
    Q_PROPERTY( QString logFilter READ logFilter WRITE setlogFilter NOTIFY logFilterChanged )
    Q_PROPERTY( int logBuffer READ logBuffer WRITE setlogBuffer NOTIFY logBufferChanged )
    Q_PROPERTY(QString logList READ logList NOTIFY logListChanged)
public:
    explicit LogViewer(QObject *parent = 0);
    ~LogViewer();

    Q_SLOT void openLog();
    Q_SLOT void stopLog(){if (mService!=NULL) mService->pauseLog();}
    Q_SLOT void loadLogs();
    Q_SLOT void changedServiceNotification(){m_logText = mService->getLogText();Q_EMIT logTextChanged();}
    Q_SLOT void stoppedServiceNotification(){Q_EMIT logStopped();}
    Q_SLOT void listServiceNotification();
    Q_SLOT void clearLog() { m_logText =""; if (mService!=NULL) mService->clearLogText();Q_EMIT logTextChanged(); }
    Q_SLOT void clearList() { if(mService==NULL)mService->clearLogsList();mList="";}


Q_SIGNALS:
    void filePathChanged();
    void logTextChanged();
    void logStopped();
    void logBufferChanged();
    void logDirChanged();
    void logListChanged();
    void logFilterChanged();

protected:
    QString logDir() { return mDir;}
    int logBuffer() {return mBuffer;}
    QString logFilter() {return mlogFilter;}
    void setlogFilter(QString filter) { mlogFilter = filter;Q_EMIT logFilterChanged();}
    void setlogDir(QString logdir) { mDir =logdir;Q_EMIT logDirChanged(); }
    QString filePath() { return m_filePath; }
    QString logText() { return m_logText;}
    QString logList() {return mList;}
    void setfilePath(QString path) { m_filePath = path; Q_EMIT filePathChanged(); }
    void setlogBuffer(int buffer );
    QString m_filePath;
    QString mDir;
    QString m_logText;
    QFile *inputFile;
    LogReaderService *mService;
    QThread *serviceThread;
    QTextStream *mlog;
    int mBuffer;
    QString mlogFilter;
    QString mList;
};

#endif // LOGVIEWER_H
