#include "logicalitemsparser.h"

LogicalItemsParser::LogicalItemsParser()
{

}

void LogicalItemsParser::openFile(const QString &fileName)
{
    //path was     file:///home/predator...
#ifdef _WIN32
    QString fName = "D:/Project/C/Qt/SchemeConstructor/examples/example1.lif";
#elif __linux__
    QString fName = "/home/predator/Programs/Qt/SchemeConstructor/examples/example1.lif";
#endif

    QFile file(fName);
    file.open(QFile::ReadOnly | QFile::Text);


    mData = file.readAll();
    file.close();

    cleanData();
//    qDebug() << mData;
    parse();
//    qDebug() << mList;
    printListItems();
}

void LogicalItemsParser::cleanData()
{
    mData.remove(QRegExp("[ \n\t]"));
}

void LogicalItemsParser::parse()
{
    if (mData.isEmpty())
    {
        return;
    }

    QString type = mData.mid(mData.indexOf("<") + 1, mData.indexOf(">") - mData.indexOf("<") - 1);
    mData.remove(0, mData.indexOf(">") + 1);
    mList.push_back(QMap<QString, QVariant>());
    mList.back().insert("type", type);


    while (true)
    {
        QString attr;
        attr = mData.mid(mData.indexOf("<") + 1, mData.indexOf(">") - mData.indexOf("<") - 1);

        if (attr == "/" + type)
        {
            mData.remove(0, mData.indexOf(">") + 1);
            parse();
            return;
        }


        mData.remove(0, mData.indexOf(">") + 1);

        QString attrValue = mData.left(mData.indexOf("<"));
        bool ok;
        int res = attrValue.toInt(&ok);
        QVariant variant;
        if (ok)
        {
            variant = res;
        }
        else
        {
            variant = attrValue;
        }

        mList.back().insert(attr, variant);
        mData.remove(0, mData.indexOf("<"));

        QString finAttr;
        finAttr = mData.mid(mData.indexOf("<") + 1, mData.indexOf(">") - mData.indexOf("<") - 1);
        mData.remove(0, mData.indexOf(">") + 1);

//        qDebug() << mData;





//        if (attr == "/" + attr)
//        {
//            continue;
//        }



    }
//    qDebug() << type;
    //    qDebug() << mData;
}

void LogicalItemsParser::printListItems()
{
    for (int i = 0; i < mList.size(); ++i)
    {
        qDebug() << "~~~~~~~~~~~~~~~~~~~~~~~";
        for(auto e : mList.at(i).keys())
        {
            qDebug() << e << mList.at(i).value(e);
        }
    }
}
