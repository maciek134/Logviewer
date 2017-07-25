#include "logviewer.h"

#include <typeinfo>

LogViewer::LogViewer(QObject *parent) :
    QObject(parent),
    m_filePath(""),
    m_logText(""),
    mDir(""),
    mlogFilter("*.log")
{
    inputFile=NULL;
    mlog =NULL;
    mService=NULL;
    serviceThread=NULL;
}

LogViewer::~LogViewer() {
    delete (mService);
    delete(serviceThread);

}

void LogViewer::listServiceNotification(){
    mList = mService->getLogsList();
    delete (mService);
    delete(serviceThread);
    Q_EMIT logListChanged();
}
void LogViewer::loadLogs(){
    qDebug() << "load";
    mService = new LogReaderService();
    serviceThread = new QThread() ;
    connect( serviceThread, SIGNAL(started()), mService, SLOT(readLogFiles()) );
    connect(mService, SIGNAL(fileloadingDone()), this, SLOT(listServiceNotification()));
    connect(mService, SIGNAL(fileloadingDone()), serviceThread, SLOT(quit()));
    mService->setDir(mDir);
    mService->setFilter(mlogFilter);
    qDebug() << "loading logs for "<< mDir << " with filter is " << mlogFilter;
    serviceThread->start();
}


void LogViewer::openLog(){
    qDebug() << "open";
    if (serviceThread ==NULL) {
        mService = new LogReaderService(mDir + m_filePath);
        serviceThread = new QThread();
        mService->setBuffer(mBuffer);
        mService->moveToThread(serviceThread);
        connect( serviceThread, SIGNAL(started()), mService, SLOT(readLog()) );
        connect (mService, SIGNAL(logTextChanged()), this, SLOT(changedServiceNotification()));
        connect (mService,SIGNAL(logReadingDone()), serviceThread, SLOT(quit()));
        connect (serviceThread, SIGNAL(finished()), this,SLOT(stoppedServiceNotification()));
    }
    serviceThread->start();

}

void LogViewer::setlogBuffer(int buffer) {
    mBuffer=buffer;
    if (mService!=NULL){
        mService->setBuffer(mBuffer);
    }
    Q_EMIT logBufferChanged();
}

