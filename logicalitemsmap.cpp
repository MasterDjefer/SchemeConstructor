#include "logicalitemsmap.h"

LogicalItemsMap::LogicalItemsMap(QObject *parent) : QObject(parent)
{
}

void LogicalItemsMap::printConnections()
{
    for (int i = 0; i < mListConnections.size(); ++i)
    {
        mListConnections.at(i).printConnection();
    }
}

void LogicalItemsMap::processConnections()
{
    int res = 0;
    int outputIndex = findElement("Output", MapKeys::in, 0);
    if (outputIndex != -1)
    {
        res = startMeasurement(mListConnections.at(outputIndex));
    }

    emit endMeasurement(res);
}

//need to add checking infinite loop
int LogicalItemsMap::startMeasurement(const LogicalItemsConnection &connection)
{
    if (!checkType(connection.out, "Input"))
    {
        if (checkType(connection.out, "Not"))
        {
            int indexElement= findElement(connection.out, MapKeys::in, 0);
            if (indexElement == -1)
            {
                return LogicalFunctions::logicalNot(0);
            }

            return LogicalFunctions::logicalNot(startMeasurement(mListConnections.at(indexElement)));
        }
        else
        {
            int indexElement1= findElement(connection.out, MapKeys::in, 1);
            int indexElement2= findElement(connection.out, MapKeys::in, 2);
            int val1 = indexElement1 == - 1 ? 0 : startMeasurement(mListConnections.at(indexElement1));
            int val2 = indexElement2 == - 1 ? 0 : startMeasurement(mListConnections.at(indexElement2));

            if (checkType(connection.out, "And"))
            {
                return LogicalFunctions::logicalAnd(val1, val2);
            }
            else
            if (checkType(connection.out, "Nand"))
            {
                return LogicalFunctions::logicalNand(val1, val2);
            }
            else
            if (checkType(connection.out, "Or"))
            {
                return LogicalFunctions::logicalOr(val1, val2);
            }
            else
            if (checkType(connection.out, "Nor"))
            {
                return LogicalFunctions::logicalNor(val1, val2);
            }
            else
            if (checkType(connection.out, "Xor"))
            {
                return LogicalFunctions::logicalXor(val1, val2);
            }
        }
    }

    return connection.value;
}

int LogicalItemsMap::findElement(const QString &name, const QString& type, int pin)
{
    for (int i = 0; i <  mListConnections.size(); ++i)
    {
        if (type == MapKeys::in)
        {
            if (mListConnections.at(i).in.indexOf(name) != -1 && mListConnections.at(i).pin == pin)
            {
                return i;
            }
        }
        else
        if (type == MapKeys::out)
        {
            if (mListConnections.at(i).out.indexOf(name) != -1 && mListConnections.at(i).pin == pin)
            {
                return i;
            }
        }
    }
    return -1;
}

bool LogicalItemsMap::checkType(const QString &name, const QString &type)
{
    return name.indexOf(type) != -1;
}

void LogicalItemsMap::getLogicalItemsMap(const QVariantList &data)
{
    mListConnections.clear();

    for (int i = 0; i < data.size(); ++i)
    {
        QMap<QString, QVariant> map = data.at(i).toMap();
        mListConnections.push_back({map.value(MapKeys::out).toString(), map.value(MapKeys::value).toInt(),
                                    map.value(MapKeys::in).toString(), map.value(MapKeys::pin).toInt()});
    }
    processConnections();
}

const QString LogicalItemsMap::MapKeys::out = "out";
const QString LogicalItemsMap::MapKeys::in = "in";
const QString LogicalItemsMap::MapKeys::pin = "pin";
const QString LogicalItemsMap::MapKeys::value = "value";
