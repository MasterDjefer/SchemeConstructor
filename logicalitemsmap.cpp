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
    int outputIndex = findElement("Output", MapKeys::in, 0);
    if (outputIndex == -1)
        return;

    int res = recursion(mListConnections.at(outputIndex));
    qDebug() << res;
}

int LogicalItemsMap::recursion(const LogicalItemsConnection &connection)
{
    if (!checkType(connection.out, "Input"))
    {
        if (checkType(connection.out, "Not"))
        {
            return LogicalFunctions::logicalNot(RECURSION_CALL(0));
        }
        else
        if (checkType(connection.out, "And"))
        {
            return LogicalFunctions::logicalAnd(RECURSION_CALL(1), RECURSION_CALL(2));
        }
        else
        if (checkType(connection.out, "Nand"))
        {
            return LogicalFunctions::logicalNand(RECURSION_CALL(1), RECURSION_CALL(2));
        }
        else
        if (checkType(connection.out, "Or"))
        {
            return LogicalFunctions::logicalOr(RECURSION_CALL(1), RECURSION_CALL(2));
        }
        else
        if (checkType(connection.out, "Nor"))
        {
            return LogicalFunctions::logicalNor(RECURSION_CALL(1), RECURSION_CALL(2));
        }
        else
        if (checkType(connection.out, "Xor"))
        {
            return LogicalFunctions::logicalXor(RECURSION_CALL(1), RECURSION_CALL(2));
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

    printConnections();
    processConnections();
}

const QString LogicalItemsMap::MapKeys::out = "out";
const QString LogicalItemsMap::MapKeys::in = "in";
const QString LogicalItemsMap::MapKeys::pin = "pin";
const QString LogicalItemsMap::MapKeys::value = "value";
