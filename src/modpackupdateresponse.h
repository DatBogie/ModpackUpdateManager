#pragma once

#include <QString>

#include "modpackresponsebase.h"

struct ModpackUpdateResponse : ModpackResponseBase {
    bool success = false;
};
