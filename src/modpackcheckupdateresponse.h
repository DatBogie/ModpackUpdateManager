#pragma once

#include <QString>

#include "modpackresponsebase.h"

struct ModpackCheckUpdateResponse : ModpackResponseBase {
    bool hasUpdate = false;
};
