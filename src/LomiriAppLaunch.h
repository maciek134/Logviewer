/*
 * Copyright (C) 2023  Maciej Sopylo
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * logviewerfocal is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef LOGVIEWER_LOMIRI_APP_LAUNCH_H
#define LOGVIEWER_LOMIRI_APP_LAUNCH_H

#include <QObject>
#include <QStringList>

class LomiriAppLaunch : public QObject {
  Q_OBJECT
public:
  Q_INVOKABLE QStringList iconAndName(const QString &id) const;
};

#endif // LOGVIEWER_
