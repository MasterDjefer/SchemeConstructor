#ifndef LOGICALITEMSMAP_H
#define LOGICALITEMSMAP_H

#include <QObject>
#include <QDebug>
#include <QVariant>
#include <QList>
#include "logicalitemsconnection.h"
#include "logicalfunctions.h"

#define RECURSION_CALL(pin) recursion(mListConnections.at(findElement(connection.out, MapKeys::in, pin)))

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
    int recursion(const LogicalItemsConnection& connection);
    int findElement(const QString& name, const QString& type, int pin);
    bool checkType(const QString& name, const QString& type);

private:
    QList<LogicalItemsConnection> mListConnections;
};

#endif // LOGICALITEMSMAP_H