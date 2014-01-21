/****************************************************************************
** Meta object code from reading C++ file 'logviewer.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.0.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "logviewer.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'logviewer.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.0.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_LogViewer_t {
    QByteArrayData data[23];
    char stringdata[291];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_LogViewer_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_LogViewer_t qt_meta_stringdata_LogViewer = {
    {
QT_MOC_LITERAL(0, 0, 9),
QT_MOC_LITERAL(1, 10, 15),
QT_MOC_LITERAL(2, 26, 0),
QT_MOC_LITERAL(3, 27, 14),
QT_MOC_LITERAL(4, 42, 10),
QT_MOC_LITERAL(5, 53, 16),
QT_MOC_LITERAL(6, 70, 13),
QT_MOC_LITERAL(7, 84, 14),
QT_MOC_LITERAL(8, 99, 16),
QT_MOC_LITERAL(9, 116, 7),
QT_MOC_LITERAL(10, 124, 7),
QT_MOC_LITERAL(11, 132, 8),
QT_MOC_LITERAL(12, 141, 26),
QT_MOC_LITERAL(13, 168, 26),
QT_MOC_LITERAL(14, 195, 23),
QT_MOC_LITERAL(15, 219, 8),
QT_MOC_LITERAL(16, 228, 9),
QT_MOC_LITERAL(17, 238, 8),
QT_MOC_LITERAL(18, 247, 6),
QT_MOC_LITERAL(19, 254, 7),
QT_MOC_LITERAL(20, 262, 9),
QT_MOC_LITERAL(21, 272, 9),
QT_MOC_LITERAL(22, 282, 7)
    },
    "LogViewer\0filePathChanged\0\0logTextChanged\0"
    "logStopped\0logBufferChanged\0logDirChanged\0"
    "logListChanged\0logFilterChanged\0openLog\0"
    "stopLog\0loadLogs\0changedServiceNotification\0"
    "stoppedServiceNotification\0"
    "listServiceNotification\0clearLog\0"
    "clearList\0filePath\0logDir\0logText\0"
    "logFilter\0logBuffer\0logList\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LogViewer[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      15,   14, // methods
       6,  104, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       7,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   89,    2, 0x05,
       3,    0,   90,    2, 0x05,
       4,    0,   91,    2, 0x05,
       5,    0,   92,    2, 0x05,
       6,    0,   93,    2, 0x05,
       7,    0,   94,    2, 0x05,
       8,    0,   95,    2, 0x05,

 // slots: name, argc, parameters, tag, flags
       9,    0,   96,    2, 0x0a,
      10,    0,   97,    2, 0x0a,
      11,    0,   98,    2, 0x0a,
      12,    0,   99,    2, 0x0a,
      13,    0,  100,    2, 0x0a,
      14,    0,  101,    2, 0x0a,
      15,    0,  102,    2, 0x0a,
      16,    0,  103,    2, 0x0a,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // properties: name, type, flags
      17, QMetaType::QString, 0x00495003,
      18, QMetaType::QString, 0x00495003,
      19, QMetaType::QString, 0x00495001,
      20, QMetaType::QString, 0x00495003,
      21, QMetaType::Int, 0x00495003,
      22, QMetaType::QString, 0x00495001,

 // properties: notify_signal_id
       0,
       4,
       1,
       6,
       3,
       5,

       0        // eod
};

void LogViewer::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        LogViewer *_t = static_cast<LogViewer *>(_o);
        switch (_id) {
        case 0: _t->filePathChanged(); break;
        case 1: _t->logTextChanged(); break;
        case 2: _t->logStopped(); break;
        case 3: _t->logBufferChanged(); break;
        case 4: _t->logDirChanged(); break;
        case 5: _t->logListChanged(); break;
        case 6: _t->logFilterChanged(); break;
        case 7: _t->openLog(); break;
        case 8: _t->stopLog(); break;
        case 9: _t->loadLogs(); break;
        case 10: _t->changedServiceNotification(); break;
        case 11: _t->stoppedServiceNotification(); break;
        case 12: _t->listServiceNotification(); break;
        case 13: _t->clearLog(); break;
        case 14: _t->clearList(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::filePathChanged)) {
                *result = 0;
            }
        }
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::logTextChanged)) {
                *result = 1;
            }
        }
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::logStopped)) {
                *result = 2;
            }
        }
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::logBufferChanged)) {
                *result = 3;
            }
        }
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::logDirChanged)) {
                *result = 4;
            }
        }
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::logListChanged)) {
                *result = 5;
            }
        }
        {
            typedef void (LogViewer::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogViewer::logFilterChanged)) {
                *result = 6;
            }
        }
    }
    Q_UNUSED(_a);
}

const QMetaObject LogViewer::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_LogViewer.data,
      qt_meta_data_LogViewer,  qt_static_metacall, 0, 0}
};


const QMetaObject *LogViewer::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LogViewer::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_LogViewer.stringdata))
        return static_cast<void*>(const_cast< LogViewer*>(this));
    return QObject::qt_metacast(_clname);
}

int LogViewer::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 15)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 15;
    }
#ifndef QT_NO_PROPERTIES
      else if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = filePath(); break;
        case 1: *reinterpret_cast< QString*>(_v) = logDir(); break;
        case 2: *reinterpret_cast< QString*>(_v) = logText(); break;
        case 3: *reinterpret_cast< QString*>(_v) = logFilter(); break;
        case 4: *reinterpret_cast< int*>(_v) = logBuffer(); break;
        case 5: *reinterpret_cast< QString*>(_v) = logList(); break;
        }
        _id -= 6;
    } else if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: setfilePath(*reinterpret_cast< QString*>(_v)); break;
        case 1: setlogDir(*reinterpret_cast< QString*>(_v)); break;
        case 3: setlogFilter(*reinterpret_cast< QString*>(_v)); break;
        case 4: setlogBuffer(*reinterpret_cast< int*>(_v)); break;
        }
        _id -= 6;
    } else if (_c == QMetaObject::ResetProperty) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 6;
    } else if (_c == QMetaObject::RegisterPropertyMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void LogViewer::filePathChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void LogViewer::logTextChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void LogViewer::logStopped()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}

// SIGNAL 3
void LogViewer::logBufferChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, 0);
}

// SIGNAL 4
void LogViewer::logDirChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, 0);
}

// SIGNAL 5
void LogViewer::logListChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, 0);
}

// SIGNAL 6
void LogViewer::logFilterChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, 0);
}
QT_END_MOC_NAMESPACE
