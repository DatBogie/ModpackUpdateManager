#pragma once

#include <QAbstractListModel>
#include <QVector>

#include "modpackinstance.h"

class ModpackModel : public QAbstractListModel {
    Q_OBJECT

    public:
        explicit ModpackModel(QObject *parent = nullptr);
        Q_INVOKABLE void addInstance(const ModpackInstance &instance);
        enum Roles {
            NameRole = Qt::UserRole + 1,
            ThumbnailKeyRole,
            ThumbnailParentPathRole,
            EnabledRole,
            FromPrismRole,
            IsCompatibleRole,
            UpdateUrlRole,
            CurrentVersionIdRole,
            CurrentVersionTypeRole,
            PendingUpdateRole,
            InstancePathRole
        };
        Qt::ItemFlags flags(const QModelIndex &index) const override;
        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        QVariantMap ModpackCheckUpdateResponseToQVariantMap(ModpackCheckUpdateResponse pu) const;
        ModpackCheckUpdateResponse QVariantMapToModpackCheckUpdateResponse(QVariantMap ccvpu);
        QVariant data(const QModelIndex &index, int role) const override;
        bool setData(const QModelIndex &index, const QVariant &value, int role) override;
        QHash<int, QByteArray> roleNames() const override;
        void removeInstance(int index);
        bool setRoleProperty(int index, int role, QVariant value);
        int findNextPrismIndex();
        ModpackInstance instanceAt(int index);

    private:
        QVector<ModpackInstance> instanceVec;
};
