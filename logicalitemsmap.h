#ifndef LOGICALITEMSMAP_H
#define LOGICALITEMSMAP_H

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QList>
#include "logicalitemsconnection.h"
#include "logicalfunctions.h"

namespace MapKeys
{
    const QString out = "out";
    const QString in = "in";
    const QString pin = "pin";
    const QString value = "value";
}

class LogicalItemsMap : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE void getLogicalItemsMap(const QVariantList& list);

    explicit LogicalItemsMap(QObject *parent = nullptr);

private:
    void printConnections();
    void processConnections();
    int startMeasurement(const LogicalItemsConnection& connection);
    int findElement(const QString& name, const QString& type, int pin);
    bool checkType(const QString& name, const QString& type);
    bool checkInfiniteLoop();

private:
    QList<LogicalItemsConnection> mListConnections;

signals:
    void endMeasurement(int value);
};

#endif // LOGICALITEMSMAP_H
