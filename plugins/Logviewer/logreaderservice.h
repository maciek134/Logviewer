#ifndef LOGREADERSERVICE_H
#define LOGREADERSERVICE_H

#include <QObject>
#include <QTextStream>
#include <QDebug>
#include <QFile>
#include <QList>
#include <QDir>



class LogReaderService : public QObject
{
    Q_OBJECT
public:
    explicit LogReaderService(QString filepath);
    explicit LogReaderService();
    ~LogReaderService();

    Q_SLOT void readLog();
    Q_SLOT void closeLog();
    Q_SLOT void readLogFiles();
    QString getLogText(){return m_logText;}
    void clearLogText() { m_logText=""; }
    void pauseLog() {mRead =false;}
    void setBuffer(int buffer) { mbuffer=buffer;}
    void setDir(QString logdir) { mDir = logdir;qDebug()<<" dir is set to: "<<logdir;}
    void setFilter (QString filter) { mFilter = filter;}
    QString getLogsList() { return mListResults;}
    void clearLogsList() {mListResults="";}


Q_SIGNALS:
    void logTextChanged();
    void logReadingDone();
    void fileloadingDone();

private:
    bool mRead;
    bool mDie;
    QTextStream * mlog;
    QString m_logText;
    int mbuffer;
    QString mDir;
    QString mCmd;
    QString resultsFile;
    QString mFilter;
    QString mListResults;
    QString mFilePath;
    QFile *inputFile;
};

#endif // LOGREADERSERVICE_H
