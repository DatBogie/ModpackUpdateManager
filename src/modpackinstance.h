#pragma once

#include <QString>

struct ModpackInstance {
    QString name;
    QString thumbnailKey;
    QString thumbnailParentPath;
    bool packEnabled = true;
};
