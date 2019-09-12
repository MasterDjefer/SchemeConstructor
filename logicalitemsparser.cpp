#include "logicalitemsparser.h"

LogicalItemsParser::LogicalItemsParser()
{
}

void LogicalItemsParser::openFile(const QVariant& fileName)
{
    QString fileNameStr = fileName.toString();
    fileNameStr.remove("file:///"); //delete prefix

    QFile file(fileNameStr);
    file.open(QFile::ReadOnly | QFile::Text);

    QString data = file.readAll();
    file.close();

    cleanData(data);
    parse(data);
    convertData();
}

void LogicalItemsParser::cleanData(QString& data)
{
    data.remove(QRegExp("[ \n\t]"));
}

void LogicalItemsParser::parse(QString &data)
{
    //remove <Lif> attr
    data.remove(openAttribute(FileAttributes::lif));
    data.remove(closeAttribute(FileAttributes::lif));

    int openItemAttrIndex = data.indexOf(openAttribute(FileAttributes::items));
    int closeItemAttrIndex = data.indexOf(closeAttribute(FileAttributes::items));
    int openItemAttrSize = openAttribute(FileAttributes::items).size();

    mItemsData = data.mid(openItemAttrIndex + openItemAttrSize, closeItemAttrIndex - openItemAttrIndex - openItemAttrSize);
    parseItems();

    int openConnectionAttrIndex = data.indexOf(openAttribute(FileAttributes::connections));
    int closeConnectionAttrIndex = data.indexOf(closeAttribute(FileAttributes::connections));
    int openConnectionAttrSize = openAttribute(FileAttributes::connections).size();

    mConnectionsData = data.mid(openConnectionAttrIndex + openConnectionAttrSize, closeConnectionAttrIndex - openConnectionAttrIndex - openConnectionAttrSize);
    parseConnections();
}

void LogicalItemsParser::parseItems()
{
    //get type of item(ex. Not, Xor)
    QString type = mItemsData.mid(mItemsData.indexOf("<") + 1, mItemsData.indexOf(">") - mItemsData.indexOf("<") - 1);

    mItemsData.remove(0, mItemsData.indexOf(">") + 1);

    //create new map and insert type
    mItemsList.push_back(QMap<QString, QVariant>());
    mItemsList.back().insert("type", type);


    while (true)
    {
        QString attr = mItemsData.mid(mItemsData.indexOf("<") + 1, mItemsData.indexOf(">") - mItemsData.indexOf("<") - 1);

        if (attr == "/" + type)
        {
            mItemsData.remove(0, mItemsData.indexOf(">") + 1);
            if (!mItemsData.isEmpty())
            {
                parseItems();
            }
            return;
        }

        mItemsData.remove(0, mItemsData.indexOf(">") + 1);

        QString attrValue = mItemsData.left(mItemsData.indexOf("<"));
        bool ok = false;
        int res = attrValue.toInt(&ok);
        QVariant variant = 0;
        if (ok)
        {
            variant = res;
        }
        else
        {
            variant = attrValue;
        }

        mItemsList.back().insert(attr, variant);
        mItemsData.remove(0, mItemsData.indexOf("<"));

        //delete attribute end
        mItemsData.remove(0, mItemsData.indexOf(">") + 1);
    }
}

void LogicalItemsParser::parseConnections()
{
    while (true)
    {
        if (mConnectionsData.isEmpty())
        {
            return;
        }

        mConnectionsList.push_back(QMap<QString, QVariant>());


        QString item1 = mConnectionsData.mid(mConnectionsData.indexOf("<") + 1, mConnectionsData.indexOf(">") - mConnectionsData.indexOf("<") - 1);
        mConnectionsData.remove(0, mConnectionsData.indexOf(">") + 1);
        mConnectionsList.back().insert("item1", item1);

        int pin = mConnectionsData.left(mConnectionsData.indexOf("<")).toInt();
        mConnectionsData.remove(0, mConnectionsData.indexOf("<"));
        mConnectionsList.back().insert("pin", pin);

        QString item2 = mConnectionsData.mid(mConnectionsData.indexOf("<") + 1, mConnectionsData.indexOf(">") - mConnectionsData.indexOf("<") - 1);
        item2.remove(0,1);
        mConnectionsData.remove(0, mConnectionsData.indexOf(">") + 1);
        mConnectionsList.back().insert("item2", item2);
    }
}

void LogicalItemsParser::printListItems()
{
    for (int i = 0; i < mItemsList.size(); ++i)
    {
        qDebug() << "~~~~~~~~~~~~~~~~~~~~~~~";
        for(auto e : mItemsList.at(i).keys())
        {
            qDebug() << e << mItemsList.at(i).value(e);
        }
    }
}

void LogicalItemsParser::printListConnections()
{
    for (int i = 0; i < mConnectionsList.size(); ++i)
    {
        qDebug() << "~~~~~~~~~~~~~~~~~~~~~~~";
        for(auto e : mConnectionsList.at(i).keys())
        {
            qDebug() << e << mConnectionsList.at(i).value(e);
        }
    }
}

void LogicalItemsParser::convertData()
{
    QList<QVariant> itemsList;
    for (int i = 0; i < mItemsList.size(); ++i)
    {
        itemsList.push_back(mItemsList.at(i));
    }
    emit itemsParsed(QVariant(itemsList));

    QList<QVariant> connectionsList;
    for (int i = 0; i < mConnectionsList.size(); ++i)
    {
        connectionsList.push_back(mConnectionsList.at(i));
    }
    emit connectionsParsed(QVariant(connectionsList));
}

QString LogicalItemsParser::openAttribute(const QString &attribute)
{
    return "<" + attribute + ">";
}

QString LogicalItemsParser::closeAttribute(const QString &attribute)
{
    return "</" + attribute + ">";
}
