/****************************************************************************
** Meta object code from reading C++ file 'logreaderservice.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.0.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "logreaderservice.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'logreaderservice.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.0.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
struct qt_meta_stringdata_LogReaderService_t {
    QByteArrayData data[8];
    char stringdata[95];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    offsetof(qt_meta_stringdata_LogReaderService_t, stringdata) + ofs \
        - idx * sizeof(QByteArrayData) \
    )
static const qt_meta_stringdata_LogReaderService_t qt_meta_stringdata_LogReaderService = {
    {
QT_MOC_LITERAL(0, 0, 16),
QT_MOC_LITERAL(1, 17, 14),
QT_MOC_LITERAL(2, 32, 0),
QT_MOC_LITERAL(3, 33, 14),
QT_MOC_LITERAL(4, 48, 15),
QT_MOC_LITERAL(5, 64, 7),
QT_MOC_LITERAL(6, 72, 8),
QT_MOC_LITERAL(7, 81, 12)
    },
    "LogReaderService\0logTextChanged\0\0"
    "logReadingDone\0fileloadingDone\0readLog\0"
    "closeLog\0readLogFiles\0"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_LogReaderService[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   44,    2, 0x05,
       3,    0,   45,    2, 0x05,
       4,    0,   46,    2, 0x05,

 // slots: name, argc, parameters, tag, flags
       5,    0,   47,    2, 0x0a,
       6,    0,   48,    2, 0x0a,
       7,    0,   49,    2, 0x0a,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void LogReaderService::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        LogReaderService *_t = static_cast<LogReaderService *>(_o);
        switch (_id) {
        case 0: _t->logTextChanged(); break;
        case 1: _t->logReadingDone(); break;
        case 2: _t->fileloadingDone(); break;
        case 3: _t->readLog(); break;
        case 4: _t->closeLog(); break;
        case 5: _t->readLogFiles(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (LogReaderService::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogReaderService::logTextChanged)) {
                *result = 0;
            }
        }
        {
            typedef void (LogReaderService::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogReaderService::logReadingDone)) {
                *result = 1;
            }
        }
        {
            typedef void (LogReaderService::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&LogReaderService::fileloadingDone)) {
                *result = 2;
            }
        }
    }
    Q_UNUSED(_a);
}

const QMetaObject LogReaderService::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_LogReaderService.data,
      qt_meta_data_LogReaderService,  qt_static_metacall, 0, 0}
};


const QMetaObject *LogReaderService::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *LogReaderService::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_LogReaderService.stringdata))
        return static_cast<void*>(const_cast< LogReaderService*>(this));
    return QObject::qt_metacast(_clname);
}

int LogReaderService::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void LogReaderService::logTextChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, 0);
}

// SIGNAL 1
void LogReaderService::logReadingDone()
{
    QMetaObject::activate(this, &staticMetaObject, 1, 0);
}

// SIGNAL 2
void LogReaderService::fileloadingDone()
{
    QMetaObject::activate(this, &staticMetaObject, 2, 0);
}
QT_END_MOC_NAMESPACE
