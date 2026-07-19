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
            IsCompatibleRole
        };
        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        QVariant data(const QModelIndex &index, int role) const override;
        QHash<int, QByteArray> roleNames() const override;
        Q_INVOKABLE void removeInstance(int index);
        int findNextPrismIndex();
        ModpackInstance instanceAt(int index);

    private:
        QVector<ModpackInstance> instanceVec;
};
