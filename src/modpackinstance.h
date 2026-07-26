#pragma once

#include <QString>

#include "modpackcheckupdateresponse.h"

struct ModpackInstance {
    QString name;
    QString thumbnailKey;
    QString thumbnailParentPath;
    bool packEnabled = false;
    bool fromPrism = true;
    bool isCompatible = false;
    QString updateUrl;
    QString currentVersionId = "1.0";
    QString currentVersionType = "release";
    QString instancePath;
    ModpackCheckUpdateResponse pendingUpdate;
};
