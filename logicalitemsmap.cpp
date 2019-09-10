#include "logicalitemsmap.h"

LogicalItemsMap::LogicalItemsMap(QObject *parent) : QObject(parent)
{
}

void LogicalItemsMap::getLogicalItemsMap(const QVariantList &data)
{
    for (int i = 0; i < data.size(); ++i)
    {
        QMap<QString, QVariant> map = data.at(i).toMap();
        qDebug() << map.value(MapKeys::out).toString() << ", " << map.value(MapKeys::value).toBool() << ", " <<
                    map.value(MapKeys::in).toString() << ", " << map.value(MapKeys::pin).toInt();
    }
}

const QString LogicalItemsMap::MapKeys::out = "out";
const QString LogicalItemsMap::MapKeys::in = "in";
const QString LogicalItemsMap::MapKeys::pin = "pin";
const QString LogicalItemsMap::MapKeys::value = "value";
