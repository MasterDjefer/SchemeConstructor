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
    int openAttrSize = openAttribute(FileAttributes::items).size();
    int closeAttrSize = openAttrSize + 1;

    mItemsData = data.mid(openItemAttrIndex + openAttrSize, closeItemAttrIndex - openItemAttrIndex - openAttrSize);
    data.remove(openItemAttrIndex, closeItemAttrIndex + closeAttrSize - openItemAttrIndex);

    parseItems();
}

void LogicalItemsParser::parseItems()
{
    qDebug() << mItemsData;
    //get type of item(ex. Not, Xor)
    QString type = mItemsData.mid(mItemsData.indexOf("<") + 1, mItemsData.indexOf(">") - mItemsData.indexOf("<") - 1);

    mItemsData.remove("<" + type + ">");

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
        qDebug() << mItemsData;
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

void LogicalItemsParser::convertData()
{
    QList<QVariant> list;
    for (int i = 0; i < mItemsList.size(); ++i)
    {
        list.push_back(mItemsList.at(i));
    }

    emit itemsParsed(QVariant(list));
}

QString LogicalItemsParser::openAttribute(const QString &attribute)
{
    return "<" + attribute + ">";
}

QString LogicalItemsParser::closeAttribute(const QString &attribute)
{
    return "</" + attribute + ">";
}
