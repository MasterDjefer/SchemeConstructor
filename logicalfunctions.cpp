#include "logicalfunctions.h"


bool LogicalFunctions::logicalNot(bool val)
{
    return !val;
}

bool LogicalFunctions::logicalAnd(bool val1, bool val2)
{
    return val1 && val2;
}

bool LogicalFunctions::logicalNand(bool val1, bool val2)
{
    return !(val1 && val2);
}

bool LogicalFunctions::logicalOr(bool val1, bool val2)
{
    return val1 || val2;
}

bool LogicalFunctions::logicalNor(bool val1, bool val2)
{
    return !(val1 || val2);
}

bool LogicalFunctions::logicalXor(bool val1, bool val2)
{
    return val1 != val2;
}
