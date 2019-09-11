#ifndef LOGICALITEMSMAP_H
#define LOGICALITEMSMAP_H

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QList>
#include "logicalitemsconnection.h"
#include "logicalfunctions.h"


class LogicalItemsMap : public QObject
{
    Q_OBJECT

    struct MapKeys
    {
        static const QString out;
        static const QString in;
        static const QString pin;
        static const QString value;
    };

public:
    Q_INVOKABLE void getLogicalItemsMap(const QVariantList& list);

    explicit LogicalItemsMap(QObject *parent = nullptr);

private:
    void printConnections();
    void processConnections();
    int startMeasurement(const LogicalItemsConnection& connection);
    int findElement(const QString& name, const QString& type, int pin);
    bool checkType(const QString& name, const QString& type);

private:
    QList<LogicalItemsConnection> mListConnections;

signals:
    void endMeasurement(int value);
};

#endif // LOGICALITEMSMAP_H
