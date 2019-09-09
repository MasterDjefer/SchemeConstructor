#include "logicalitemsmap.h"

LogicalItemsMap::LogicalItemsMap(QObject *parent) : QObject(parent)
{

}

void LogicalItemsMap::getLogicalItemsMap(const QVariantList &data)
{
    qDebug() << data;
}
