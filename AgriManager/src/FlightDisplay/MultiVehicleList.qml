﻿/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.FlightMap     1.0

QGCListView {
    id:             missionItemEditorListView
    spacing:        ScreenTools.defaultFontPixelHeight / 2
    orientation:    ListView.Vertical
    model:          QGroundControl.multiVehicleManager.vehicles
    cacheBuffer:    _cacheBuffer < 0 ? 0 : _cacheBuffer
    clip:           true

    property real _margin:          ScreenTools.defaultFontPixelWidth / 2
    property real _cacheBuffer:     height * 2
    property real _widgetHeight:    ScreenTools.defaultFontPixelHeight * 3

    delegate: Rectangle {
        width:      parent.width
        height:     innerColumn.y + innerColumn.height + _margin
        color:      qgcPal.missionItemEditor
        opacity:    0.8
        radius:     _margin

        property var    _vehicle:   object
        property color  _textColor: "black"

        QGCPalette { id: qgcPal }

        Row {
            id:                 widgetLayout
            anchors.margins:    _margin
            anchors.top:        parent.top
            anchors.right:      parent.right
            spacing:            ScreenTools.defaultFontPixelWidth / 2
            layoutDirection:    Qt.RightToLeft

            QGCCompassWidget {
                size:       _widgetHeight
                vehicle:    _vehicle
            }

            QGCAttitudeWidget {
                size:       _widgetHeight
                vehicle:    _vehicle
            }
        }

        RowLayout {
            anchors.top:    widgetLayout.top
            anchors.bottom: widgetLayout.bottom
            anchors.left:   parent.left
            anchors.right:  widgetLayout.left
            spacing:        ScreenTools.defaultFontPixelWidth / 2

            QGCLabel {
                Layout.alignment:   Qt.AlignTop
                text:               _vehicle.id
                color:              _textColor
            }

            FlightModeMenu {
                font.pointSize: ScreenTools.largeFontPointSize
                color:          _textColor
                activeVehicle:  _vehicle
            }
        }

        Column {
            id:                 innerColumn
            anchors.margins:    _margin
            anchors.left:       parent.left
            anchors.right:      parent.right
            anchors.top:        widgetLayout.bottom
            spacing:            _margin

            Rectangle {
                anchors.left:   parent.left
                anchors.right:  parent.right
                height:         5
                color:          "green"
            }

            Row {
                spacing: ScreenTools.defaultFontPixelWidth

                QGCButton {
                    text:       "解锁"
                    visible:    !_vehicle.armed
                    onClicked:  _vehicle.armed = true
                }

                QGCButton {
                    text:       "开始"
                    visible:    _vehicle.armed && _vehicle.flightMode != _vehicle.missionFlightMode
                    onClicked:  _vehicle.flightMode = _vehicle.missionFlightMode
                }

                QGCButton {
                    text:       "停止"
                    visible:    _vehicle.armed && _vehicle.pauseVehicleSupported
                    onClicked:  _vehicle.pauseVehicle()
                }

                QGCButton {
                    text:       "返航"
                    visible:    _vehicle.armed && _vehicle.flightMode != _vehicle.rtlFlightMode
                    onClicked:  _vehicle.flightMode = _vehicle.rtlFlightMode
                }

                QGCButton {
                    text:       "采取控制"
                    visible:    _vehicle.armed && _vehicle.flightMode != _vehicle.takeControlFlightMode
                    onClicked:  _vehicle.flightMode = _vehicle.takeControlFlightMode
                }

            }
        }
    }
} // QGCListView
