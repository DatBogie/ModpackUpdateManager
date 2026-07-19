#include "modpackmodel.h"
#include "modpackinstance.h"

ModpackModel::ModpackModel(QObject *parent) : QAbstractListModel(parent) {}

void ModpackModel::addInstance(const ModpackInstance &instance) {
    const int row = instanceVec.size();
    beginInsertRows(QModelIndex(),row,row);
    instanceVec.push_back(instance);
    endInsertRows();
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
    }
    return {};
}

QHash<int, QByteArray> ModpackModel::roleNames() const {
    return {
        { NameRole, "name" },
        { ThumbnailKeyRole, "thumbnailKey" },
        { ThumbnailParentPathRole, "thumbnailParentPath" },
        { EnabledRole, "packEnabled" }
    };
}
