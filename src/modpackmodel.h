#pragma once

#include <QAbstractListModel>
#include <QVector>

#include "modpackinstance.h"

class ModpackModel : public QAbstractListModel {
    Q_OBJECT

    public:
        explicit ModpackModel(QObject *parent = nullptr);
        void addInstance(const ModpackInstance &instance);
        enum Roles {
            NameRole = Qt::UserRole + 1,
            ThumbnailKeyRole,
            ThumbnailParentPathRole,
            EnabledRole
        };
        int rowCount(const QModelIndex &parent = QModelIndex()) const override;
        QVariant data(const QModelIndex &index, int role) const override;
        QHash<int, QByteArray> roleNames() const override;

    private:
        QVector<ModpackInstance> instanceVec;
};
