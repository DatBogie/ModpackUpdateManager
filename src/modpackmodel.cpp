#include "modpackmodel.h"
#include "modpackinstance.h"

ModpackModel::ModpackModel(QObject *parent) : QAbstractListModel(parent) {}

void ModpackModel::addInstance(const ModpackInstance &instance) {
    const int row = instanceVec.size();
    beginInsertRows(QModelIndex(),row,row);
    instanceVec.push_back(instance);
    endInsertRows();
}

void ModpackModel::removeInstance(int index) {
    beginRemoveRows(QModelIndex(), index, index);
    instanceVec.removeAt(index);
    endRemoveRows();
}

int ModpackModel::findNextPrismIndex() {
    for (int i=0; i<instanceVec.size(); i++)
        if (instanceVec[i].fromPrism)
            return i;
    return -1;
}

int ModpackModel::rowCount(const QModelIndex &) const {
    return instanceVec.size();
}

QVariant ModpackModel::data(const QModelIndex &index, int role) const {
    const ModpackInstance &mi = instanceVec[index.row()];
    switch (role) {
        case NameRole:
            return mi.name;
        case ThumbnailKeyRole:
            return mi.thumbnailKey;
        case ThumbnailParentPathRole:
            return mi.thumbnailParentPath;
        case EnabledRole:
            return mi.packEnabled;
        case FromPrismRole:
            return mi.fromPrism;
        case IsCompatibleRole:
            return mi.isCompatible;
    }
    return {};
}

QHash<int, QByteArray> ModpackModel::roleNames() const {
    return {
        { NameRole, "name" },
        { ThumbnailKeyRole, "thumbnailKey" },
        { ThumbnailParentPathRole, "thumbnailParentPath" },
        { EnabledRole, "packEnabled" },
        { FromPrismRole, "fromPrism" },
        { IsCompatibleRole, "isCompatible" }
    };
}

ModpackInstance ModpackModel::instanceAt(int index) {
    return instanceVec[index];
}
