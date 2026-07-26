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

QVariantMap ModpackModel::ModpackCheckUpdateResponseToQVariantMap(ModpackCheckUpdateResponse pu) const {
    QVariantMap cvpu = {
        { "hasUpdate", pu.hasUpdate },
        { "updateId", pu.updateId },
        { "updateType", pu.updateType },
        { "updateName", pu.updateName },
        { "updateDesc", pu.updateDesc },
        { "changelog", pu.changelog }
    };
    return cvpu;
}

ModpackCheckUpdateResponse ModpackModel::QVariantMapToModpackCheckUpdateResponse(QVariantMap cvpu) {
    ModpackCheckUpdateResponse pu = { cvpu["updateId"].toString(), cvpu["updateType"].toString(), cvpu["updateName"].toString(), cvpu["updateDesc"].toString(), cvpu["changelog"].toList(), cvpu["hasUpdate"].toBool() };
    return pu;
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
        case UpdateUrlRole:
            return mi.updateUrl;
        case CurrentVersionIdRole:
            return mi.currentVersionId;
        case CurrentVersionTypeRole:
            return mi.currentVersionType;
        case PendingUpdateRole:
            return ModpackCheckUpdateResponseToQVariantMap(mi.pendingUpdate);
        case InstancePathRole:
            return mi.instancePath;
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
        { IsCompatibleRole, "isCompatible" },
        { UpdateUrlRole, "updateUrl" },
        { CurrentVersionIdRole, "currentVersionId" },
        { CurrentVersionTypeRole, "currentVersionType" },
        { PendingUpdateRole, "pendingUpdate" },
        { InstancePathRole, "instancePath" }
    };
}

ModpackInstance ModpackModel::instanceAt(int index) {
    return instanceVec[index];
}

Qt::ItemFlags ModpackModel::flags(const QModelIndex &index) const {
    return QAbstractListModel::flags(index) | Qt::ItemIsEditable;
}

bool ModpackModel::setData(const QModelIndex &index, const QVariant &value, int role) {
    if (!index.isValid()) return false;
    auto &instance = instanceVec[index.row()];
    switch (role) {
        case IsCompatibleRole:
            instance.isCompatible = value.toBool();
            break;
        case EnabledRole:
            instance.packEnabled = value.toBool();
            break;
        case UpdateUrlRole:
            instance.updateUrl = value.toString();
            break;
        case CurrentVersionIdRole:
            instance.currentVersionId = value.toString();
            break;
        case CurrentVersionTypeRole:
            instance.currentVersionType = value.toString();
            break;
        case PendingUpdateRole:
            instance.pendingUpdate = QVariantMapToModpackCheckUpdateResponse(value.toMap());
            break;
        default:
            return false;
    }
    emit dataChanged(index, index, { role });
    return true;
}

bool ModpackModel::setRoleProperty(int index, int role, QVariant value) {
    return setData(this->index(index, 0), value, role);
}
