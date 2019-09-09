#ifndef LOGICALITEMSMAP_H
#define LOGICALITEMSMAP_H

#include <QObject>
#include <QDebug>
#include <QVariant>

class LogicalItemsMap : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE void getLogicalItemsMap(const QVariantList& list);

public:
    explicit LogicalItemsMap(QObject *parent = 0);
};

#endif // LOGICALITEMSMAP_H
