#ifndef LOGICALITEMSCONNECTION_H
#define LOGICALITEMSCONNECTION_H
#include <QString>
#include <QDebug>

struct LogicalItemsConnection
{
    QString out;
    int value;
    QString in;
    int pin;

    void printConnection() const;
};

#endif // LOGICALITEMSCONNECTION_H
