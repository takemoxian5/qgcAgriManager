﻿import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2
import QtQuick.Dialogs  1.2

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.FactControls      1.0
import QGroundControl.Palette           1.0

// Toolbar for Plan View
Rectangle {
    id:                 _root
    height:             ScreenTools.toolbarHeight
    anchors.left:       parent.left
    anchors.right:      parent.right
    anchors.top:        parent.top
    z:                  toolBar.z + 1
    color:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(1,1,1,0.8) : Qt.rgba(0,0,0,0.75)
    visible:            false
    anchors.bottomMargin: 1

    signal showFlyView

    property var    planMasterController
    property var    currentMissionItem          ///< Mission item to display status for

    property var    missionItems:               _controllerValid ? planMasterController.missionController.visualItems : undefined
    property real   missionDistance:            _controllerValid ? planMasterController.missionController.missionDistance : NaN
    property real   missionTime:                _controllerValid ? planMasterController.missionController.missionTime : NaN
    property real   missionMaxTelemetry:        _controllerValid ? planMasterController.missionController.missionMaxTelemetry : NaN
    property bool   missionDirty:               _controllerValid ? planMasterController.missionController.dirty : false

    property bool   _controllerValid:           planMasterController != undefined
    property bool   _controllerOffline:         _controllerValid ? planMasterController.offline : true
    property var    _controllerDirty:           _controllerValid ? planMasterController.dirty : false
    property var    _controllerSyncInProgress:  _controllerValid ? planMasterController.syncInProgress : false

    property bool   _statusValid:               currentMissionItem != undefined
    property bool   _missionValid:              missionItems != undefined

    property real   _dataFontSize:              ScreenTools.defaultFontPointSize
    property real   _largeValueWidth:           ScreenTools.defaultFontPixelWidth * 8
    property real   _mediumValueWidth:          ScreenTools.defaultFontPixelWidth * 4
    property real   _smallValueWidth:           ScreenTools.defaultFontPixelWidth * 3
    property real   _labelToValueSpacing:       ScreenTools.defaultFontPixelWidth
    property real   _rowSpacing:                ScreenTools.isMobile ? 1 : 0
    property real   _distance:                  _statusValid ? currentMissionItem.distance : NaN
    property real   _altDifference:             _statusValid ? currentMissionItem.altDifference : NaN
    property real   _gradient:                  _statusValid && currentMissionItem.distance > 0 ? Math.atan(currentMissionItem.altDifference / currentMissionItem.distance) : NaN
    property real   _gradientPercent:           isNaN(_gradient) ? NaN : _gradient * 100
    property real   _azimuth:                   _statusValid ? currentMissionItem.azimuth : NaN
    property real   _heading:                   _statusValid ? currentMissionItem.missionVehicleYaw : NaN
    property real   _missionDistance:           _missionValid ? missionDistance : NaN
    property real   _missionMaxTelemetry:       _missionValid ? missionMaxTelemetry : NaN
    property real   _missionTime:               _missionValid ? missionTime : NaN
    property int    _batteryChangePoint:        _controllerValid ? planMasterController.missionController.batteryChangePoint : -1
    property int    _batteriesRequired:         _controllerValid ? planMasterController.missionController.batteriesRequired : -1
    property bool   _batteryInfoAvailable:      _batteryChangePoint >= 0 || _batteriesRequired >= 0
    property real   _controllerProgressPct:     _controllerValid ? planMasterController.missionController.progressPct : 0
    property bool   _syncInProgress:            _controllerValid ? planMasterController.missionController.syncInProgress : false

    property string _distanceText:              isNaN(_distance) ?              "-.-" : QGroundControl.metersToAppSettingsDistanceUnits(_distance).toFixed(1) + " " + QGroundControl.appSettingsDistanceUnitsString
    property string _altDifferenceText:         isNaN(_altDifference) ?         "-.-" : QGroundControl.metersToAppSettingsDistanceUnits(_altDifference).toFixed(1) + " " + QGroundControl.appSettingsDistanceUnitsString
    property string _gradientText:              isNaN(_gradient) ?              "-.-" : _gradientPercent.toFixed(0) + " %"
    property string _azimuthText:               isNaN(_azimuth) ?               "-.-" : Math.round(_azimuth)
    property string _headingText:               isNaN(_azimuth) ?               "-.-" : Math.round(_heading)
    property string _missionDistanceText:       isNaN(_missionDistance) ?       "-.-" : QGroundControl.metersToAppSettingsDistanceUnits(_missionDistance).toFixed(0) + " " + QGroundControl.appSettingsDistanceUnitsString
    property string _missionMaxTelemetryText:   isNaN(_missionMaxTelemetry) ?   "-.-" : QGroundControl.metersToAppSettingsDistanceUnits(_missionMaxTelemetry).toFixed(0) + " " + QGroundControl.appSettingsDistanceUnitsString
    property string _batteryChangePointText:    _batteryChangePoint < 0 ?       "N/A" : _batteryChangePoint
    property string _batteriesRequiredText:     _batteriesRequired < 0 ?        "N/A" : _batteriesRequired

    readonly property real _margins: ScreenTools.defaultFontPixelWidth

    QGCPalette { id: qgcPal }

    function getMissionTime() {
        if(isNaN(_missionTime)) {
            return "00:00:00"
        }
        var t = new Date(0, 0, 0, 0, 0, Number(_missionTime))
        return Qt.formatTime(t, 'hh:mm:ss')
    }

    //-- Eat mouse events, preventing them from reaching toolbar, which is underneath us.
    MouseArea {
        anchors.fill:   parent
        onWheel:        { wheel.accepted = true; }
        onPressed:      { mouse.accepted = true; }
        onReleased:     { mouse.accepted = true; }
    }

    //-- The reason for this Row to be here is so the Logo (Home) button is in the same
    //   location as the one in the main toolbar.
    Row {
        id:                     logoRow
        anchors.bottomMargin:   1
        anchors.left:           parent.left
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        QGCToolBarButton {
            id:                 settingsButton
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            source:             "/qmlimages/PaperPlane.svg"
            logo:               true
            checked:            false
            onClicked: {
                checked = false
                showFlyView()
            }
        }
    }

    // Progress bar

    on_ControllerProgressPctChanged: {
        if (_controllerProgressPct === 1) {
            missionStats.visible = false
            uploadCompleteText.visible = true
            resetProgressTimer.start()
        } else if (_controllerProgressPct > 0) {
            progressBar.visible = true
        }
    }

    Timer {
        id:             resetProgressTimer
        interval:       5000
        onTriggered: {
            missionStats.visible = true
            uploadCompleteText.visible = false
            progressBar.visible = false
        }
    }

    Rectangle {
        id:             progressBar
        anchors.left:   parent.left
        anchors.bottom: parent.bottom
        height:         4
        width:          _controllerProgressPct * parent.width
        color:          qgcPal.colorGreen
        visible:        false
    }

    QGCLabel {
        id:                     uploadCompleteText
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left:           logoRow.right
        anchors.right:          uploadButton.left
        font.pointSize:         ScreenTools.largeFontPointSize
        horizontalAlignment:    Text.AlignHCenter
        verticalAlignment:      Text.AlignVCenter
        text:                   "Done"
        visible:                false
    }

    GridLayout {
        id:                     missionStats
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.leftMargin:     _margins
        anchors.rightMargin:    _margins
        anchors.left:           logoRow.right
        anchors.right:          uploadButton.visible ? uploadButton.left : parent.right
        columnSpacing:          0
        columns:                3

        GridLayout {
            anchors.verticalCenter: parent.verticalCenter
            columns:                8
            rowSpacing:             _rowSpacing
            columnSpacing:          _labelToValueSpacing
            Layout.alignment:       Qt.AlignHCenter

            QGCLabel {
                text:               qsTr("选择航点")
                Layout.columnSpan:  8
                font.pointSize:     ScreenTools.smallFontPointSize
            }

            QGCLabel { text: qsTr("高度差:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _altDifferenceText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _mediumValueWidth
            }

            Item { width: 1; height: 1 }

            QGCLabel { text: qsTr("方位角:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _azimuthText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _smallValueWidth
            }

            Item { width: 1; height: 1 }

            QGCLabel { text: qsTr("距离:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _distanceText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _largeValueWidth
            }

            QGCLabel { text: qsTr("梯度:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _gradientText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _mediumValueWidth
            }

            Item { width: 1; height: 1 }

            QGCLabel { text: qsTr("偏航:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _headingText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _smallValueWidth
            }
        }

        GridLayout {
            anchors.verticalCenter: parent.verticalCenter
            columns:                5
            rowSpacing:             _rowSpacing
            columnSpacing:          _labelToValueSpacing
            Layout.alignment:       Qt.AlignHCenter

            QGCLabel {
                text:               qsTr("总任务")
                Layout.columnSpan:  5
                font.pointSize:     ScreenTools.smallFontPointSize
            }

            QGCLabel { text: qsTr("距离:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _missionDistanceText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _largeValueWidth
            }

            Item { width: 1; height: 1 }

            QGCLabel { text: qsTr("最大数传距离:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _missionMaxTelemetryText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _largeValueWidth
            }

            QGCLabel { text: qsTr("时间:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   getMissionTime()
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _largeValueWidth
            }
        }

        GridLayout {
            anchors.verticalCenter: parent.verticalCenter
            columns:                3
            rowSpacing:             _rowSpacing
            columnSpacing:          _labelToValueSpacing
            Layout.alignment:       Qt.AlignHCenter
            visible:                _batteryInfoAvailable

            QGCLabel {
                text:               qsTr("电池")
                Layout.columnSpan:  3
                font.pointSize:     ScreenTools.smallFontPointSize
            }

            QGCLabel { text: qsTr("电池需求:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _batteriesRequiredText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _mediumValueWidth
            }

            Item { width: 1; height: 1 }

            QGCLabel { text: qsTr("交换航点:"); font.pointSize: _dataFontSize; }
            QGCLabel {
                text:                   _batteryChangePointText
                font.pointSize:         _dataFontSize
                Layout.minimumWidth:    _mediumValueWidth
            }
        }
    }

    QGCButton {
        id:                     uploadButton
        anchors.rightMargin:    _margins
        anchors.right:          parent.right
        anchors.verticalCenter: parent.verticalCenter
        text:                   _controllerDirty ? qsTr("上传需求") : qsTr("上传")
        enabled:                !_controllerSyncInProgress
        visible:                !_controllerOffline && !_controllerSyncInProgress && !uploadCompleteText.visible
        primary:                _controllerDirty
        onClicked:              planMasterController.upload()

        PropertyAnimation on opacity {
            easing.type:    Easing.OutQuart
            from:           0.5
            to:             1
            loops:          Animation.Infinite
            running:        _controllerDirty && !_controllerSyncInProgress
            alwaysRunToEnd: true
            duration:       2000
        }
    }
}

