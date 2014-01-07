#include "logreaderservice.h"

LogReaderService::LogReaderService(QString filepath) :
    QObject(0)
{
    mFilePath = filepath;
    inputFile =NULL;
    resultsFile ="logls.txt";
    mRead = true;
    mDie = false;
    mDir = "";
    LogReaderService();
}

LogReaderService::LogReaderService() :
    QObject(0),
    mListResults("")
{
    inputFile =NULL;
    mCmd ="ls ";
    mDir = "";
    mFilter ="*.log";

}

void LogReaderService::readLog() {
    qDebug() << "readlog called";
    mRead = true;
    QString mline("") ;

    if (inputFile == NULL) {
        inputFile = new QFile(mFilePath);
        if (!inputFile->open(QIODevice::ReadOnly)){
            qDebug()<< "opening file failed" << mFilePath;
            return;
        }
        qint64 pos =inputFile->size() - mbuffer;
        qDebug() << "filed opened succesfully " << mFilePath;
        mlog = new QTextStream(inputFile);
        if (pos > 0) {
            bool isSeek = mlog->seek(pos);
            qDebug() << "seek of file was " << isSeek;
        }
    }
    while (mRead && !mDie)
    {
        if (!mlog->atEnd()) {
            mline = mlog->readLine();
            m_logText.append(mline + "\n");
            //qDebug() << "Line is " << mline ;
            if (m_logText.length() > mbuffer) {
                m_logText = m_logText.right(mbuffer);
            }
            Q_EMIT logTextChanged();
        } else {
            int ms = 500;
            struct timespec ts = { ms / 1000, (ms % 1000) * 1000 * 1000 };
            nanosleep(&ts, NULL);
        }
    }

    qDebug() << "leaving read log";
    if (!mDie)Q_EMIT logReadingDone();
}

LogReaderService::~LogReaderService(){
    if (inputFile !=NULL){
        mDie=true;
        qDebug() << "closing file and destroy service";
        inputFile->close();
        delete(inputFile);
        delete(mlog);
    }
}

void LogReaderService::readLogFiles() {
    QString icmd = mCmd + mDir + mFilter;
    qDebug() << "command is" <<icmd;
    QByteArray ba = icmd.toLocal8Bit();
    const char *cmd_char = ba.data();

    FILE* pipe = popen(cmd_char, "r");
    if (!pipe) {qDebug()<<"error running cmd";return;}
    char buffer[128];
    while(!feof(pipe)) {
        if(fgets(buffer, 128, pipe) != NULL) {
            mListResults.append(buffer);
        }
    }
    qDebug() << "line is " << mListResults;
    Q_EMIT fileloadingDone();
}
