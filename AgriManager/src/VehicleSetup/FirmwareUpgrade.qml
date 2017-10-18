/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0

QGCView {
    id:         qgcView
    viewPanel:  panel

    // Those user visible strings are hard to translate because we can't send the
    // HTML strings to translation as this can create a security risk. we need to find
    // a better way to hightlight them, or use less hightlights.

    // User visible strings
    readonly property string title:             "FIRMWARE"
    readonly property string highlightPrefix:   "<font color=\"" + qgcPal.warningText + "\">"
    readonly property string highlightSuffix:   "</font>"
    readonly property string welcomeText:       qsTr("%1 可以升级飞控、数传和光流的固件.").arg(QGroundControl.appName)
    readonly property string plugInText:        "<big>" + highlightSuffix + "通过USB口" + highlightPrefix + " 插入设备以开始" + highlightSuffix + " 固件升级.</big>"
    readonly property string flashFailText:     "如果升级失败, 请确认 " + highlightPrefix + "直接连接" + highlightSuffix + " 到一个可供电的USB端口, 而不是通过USB hub接口. " +
                                                "同时确认只用USB口供电 " + highlightPrefix + "不是电池" + highlightSuffix + "."
    readonly property string qgcUnplugText1:    qsTr("所有 %1 和设备的连接 ").arg(QGroundControl.appName) + highlightPrefix + " 都要断开 " + highlightSuffix + "确保固件升级的优先级."
    readonly property string qgcUnplugText2:    highlightPrefix + "<big>请从USB口断开设备连接.</big>" + highlightSuffix

    readonly property int _defaultFimwareTypePX4:   12
    readonly property int _defaultFimwareTypeAPM:   3

    property var    _defaultFirmwareFact:   QGroundControl.settingsManager.appSettings.defaultFirmwareType
    property bool   _defaultFirmwareIsPX4:  _defaultFirmwareFact.rawValue == _defaultFimwareTypePX4

    property string firmwareWarningMessage
    property bool   controllerCompleted:      false
    property bool   initialBoardSearch:       true
    property string firmwareName

    property bool _singleFirmwareMode: QGroundControl.corePlugin.options.firmwareUpgradeSingleURL.length != 0   ///< true: running in special single firmware download mode

    function cancelFlash() {
        statusTextArea.append(highlightPrefix + qsTr("升级取消") + highlightSuffix)
        statusTextArea.append("------------------------------------------")
        controller.cancel()
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    FirmwareUpgradeController {
        id:             controller
        progressBar:    progressBar
        statusLog:      statusTextArea

        property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

        Component.onCompleted: {
            controllerCompleted = true
            if (qgcView.completedSignalled) {
                // We can only start the board search when the Qml and Controller are completely done loading
                controller.startBoardSearch()
            }
        }

        onActiveVehicleChanged: {
            if (!activeVehicle) {
                statusTextArea.append(plugInText)
            }
        }

        onNoBoardFound: {
            initialBoardSearch = false
            if (!QGroundControl.multiVehicleManager.activeVehicleAvailable) {
                statusTextArea.append(plugInText)
            }
        }

        onBoardGone: {
            initialBoardSearch = false
            if (!QGroundControl.multiVehicleManager.activeVehicleAvailable) {
                statusTextArea.append(plugInText)
            }
        }

        onBoardFound: {
            if (initialBoardSearch) {
                // Board was found right away, so something is already plugged in before we've started upgrade
                statusTextArea.append(qgcUnplugText1)
                statusTextArea.append(qgcUnplugText2)
                QGroundControl.multiVehicleManager.activeVehicle.autoDisconnect = true
            } else {
                // We end up here when we detect a board plugged in after we've started upgrade
                statusTextArea.append(highlightPrefix + qsTr("发现设备") + highlightSuffix + ": " + controller.boardType)
                if (controller.pixhawkBoard || controller.px4FlowBoard) {
                    showDialog(pixhawkFirmwareSelectDialogComponent, title, qgcView.showDialogDefaultWidth, StandardButton.Ok | StandardButton.Cancel)
                }
            }
        }

        onError: {
            hideDialog()
            statusTextArea.append(flashFailText)
        }
    }

    onCompleted: {
        if (controllerCompleted) {
            // We can only start the board search when the Qml and Controller are completely done loading
            controller.startBoardSearch()
        }
    }

    Component {
        id: pixhawkFirmwareSelectDialogComponent

        QGCViewDialog {
            id:             pixhawkFirmwareSelectDialog
            anchors.fill:   parent

            property bool showFirmwareTypeSelection:    _advanced.checked
            property bool px4Flow:                      controller.px4FlowBoard

            function updatePX4VersionDisplay() {
                var versionString = ""
                if (_advanced.checked) {
                    switch (controller.selectedFirmwareType) {
                    case FirmwareUpgradeController.StableFirmware:
                        versionString = controller.px4StableVersion
                        break
                    case FirmwareUpgradeController.BetaFirmware:
                        versionString = controller.px4BetaVersion
                        break
                    }
                } else {
                    versionString = controller.px4StableVersion
                }
                px4FlightStack.text = qsTr("PX4飞控固件") + versionString
            }

            Component.onCompleted: updatePX4VersionDisplay()

            function accept() {
                hideDialog()
                if (_singleFirmwareMode) {
                    controller.flashSingleFirmwareMode()
                } else {
                    var stack = apmFlightStack.checked ? FirmwareUpgradeController.AutoPilotStackAPM : FirmwareUpgradeController.AutoPilotStackPX4
                    if (px4Flow) {
                        stack = FirmwareUpgradeController.PX4Flow
                    }

                    var firmwareType = firmwareVersionCombo.model.get(firmwareVersionCombo.currentIndex).firmwareType
                    var vehicleType = FirmwareUpgradeController.DefaultVehicleFirmware
                    if (apmFlightStack.checked) {
                        vehicleType = controller.vehicleTypeFromVersionIndex(vehicleTypeSelectionCombo.currentIndex)
                    }
                    controller.flash(stack, firmwareType, vehicleType)
                }
            }

            function reject() {
                hideDialog()
                cancelFlash()
            }

            ExclusiveGroup {
                id: firmwareGroup
            }

            ListModel {
                id: firmwareTypeList

                ListElement {
                    text:           qsTr("标准版本(稳定)")
                    firmwareType:   FirmwareUpgradeController.StableFirmware
                }
                ListElement {
                    text:           qsTr("测试版本 (测试中)")
                    firmwareType:   FirmwareUpgradeController.BetaFirmware
                }
                ListElement {
                    text:           qsTr("开发者编译版本 (开发中)")
                    firmwareType:   FirmwareUpgradeController.DeveloperFirmware
                }
                ListElement {
                    text:           qsTr("自定义固件...")
                    firmwareType:   FirmwareUpgradeController.CustomFirmware
                }
            }

            ListModel {
                id: px4FlowTypeList

                ListElement {
                    text:           qsTr("标准版本(稳定)")
                    firmwareType:   FirmwareUpgradeController.StableFirmware
                }
                ListElement {
                    text:           qsTr("自定义固件...")
                    firmwareType:   FirmwareUpgradeController.CustomFirmware
                }
            }

            ListModel {
                id: singleFirmwareModeTypeList

                ListElement {
                    text:           qsTr("标准版本")
                    firmwareType:   FirmwareUpgradeController.StableFirmware
                }
                ListElement {
                    text:           qsTr("自定义固件...")
                    firmwareType:   FirmwareUpgradeController.CustomFirmware
                }
            }

            Column {
                anchors.fill:   parent
                spacing:        defaultTextHeight

                QGCLabel {
                    width:      parent.width
                    wrapMode:   Text.WordWrap
                    text:       _singleFirmwareMode ? _singleFirmwareLabel : (px4Flow ? _px4FlowLabel : _pixhawkLabel)

                    readonly property string _px4FlowLabel:          qsTr("检测到PX4光流模块. 请从下面选择固件:")
                    readonly property string _pixhawkLabel:          qsTr("检测到pixhawk飞控. 请从下面选择固件:")
                    readonly property string _singleFirmwareLabel:   qsTr("点击确认升级设备固件.")
                }

                function firmwareVersionChanged(model) {
                    firmwareVersionWarningLabel.visible = false
                    // All of this bizarre, setting model to null and index to 1 and then to 0 is to work around
                    // strangeness in the combo box implementation. This sequence of steps correctly changes the combo model
                    // without generating any warnings and correctly updates the combo text with the new selection.
                    firmwareVersionCombo.model = null
                    firmwareVersionCombo.model = model
                    firmwareVersionCombo.currentIndex = 1
                    firmwareVersionCombo.currentIndex = 0
                }

                Component.onCompleted: {
                    if (_defaultFirmwareIsPX4) {
                        px4FlightStack.checked = true
                    } else {
                        apmFlightStack.checked = true
                    }
                }

                QGCRadioButton {
                    id:             px4FlightStack
                    exclusiveGroup: firmwareGroup
                    text:           qsTr("PX4飞控固件")
                    visible:        !_singleFirmwareMode && !px4Flow

                    onClicked: {
                        _defaultFirmwareFact.rawValue = _defaultFimwareTypePX4
                        parent.firmwareVersionChanged(firmwareTypeList)
                    }
                }

                QGCRadioButton {
                    id:             apmFlightStack
                    exclusiveGroup: firmwareGroup
                    text:           qsTr("ArduPilot飞控固件")
                    visible:        !_singleFirmwareMode && !px4Flow

                    onClicked: {
                        _defaultFirmwareFact.rawValue = _defaultFimwareTypeAPM
                        parent.firmwareVersionChanged(firmwareTypeList)
                    }
                }

                QGCComboBox {
                    id:             vehicleTypeSelectionCombo
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    visible:        apmFlightStack.checked
                    model:          controller.apmAvailableVersions
                }

                Row {
                    width:      parent.width
                    spacing:    ScreenTools.defaultFontPixelWidth / 2
                    visible:    !px4Flow

                    Rectangle {
                        height: 1
                        width:      ScreenTools.defaultFontPixelWidth * 5
                        color:      qgcPal.text
                        anchors.verticalCenter: _advanced.verticalCenter
                    }

                    QGCCheckBox {
                        id:         _advanced
                        text:       qsTr("高级设置")
                        checked:    px4Flow ? true : false

                        onClicked: {
                            firmwareVersionCombo.currentIndex = 0
                            firmwareVersionWarningLabel.visible = false
                            updatePX4VersionDisplay()
                        }
                    }

                    Rectangle {
                        height:     1
                        width:      ScreenTools.defaultFontPixelWidth * 5
                        color:      qgcPal.text
                        anchors.verticalCenter: _advanced.verticalCenter
                    }
                }

                QGCLabel {
                    width:      parent.width
                    wrapMode:   Text.WordWrap
                    visible:    showFirmwareTypeSelection
                    text:       px4Flow ? qsTr("请选择固件安装版本:") : qsTr("请选择您想安装的固件版本:")
                }

                QGCComboBox {
                    id:             firmwareVersionCombo
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    visible:        showFirmwareTypeSelection
                    model:          _singleFirmwareMode ? singleFirmwareModeTypeList: (px4Flow ? px4FlowTypeList : firmwareTypeList)
                    currentIndex:   controller.selectedFirmwareType

                    onActivated: {
                        controller.selectedFirmwareType = index
                        if (model.get(index).firmwareType == FirmwareUpgradeController.BetaFirmware) {
                            firmwareVersionWarningLabel.visible = true
                            firmwareVersionWarningLabel.text = qsTr("警告：测试版固件. ") +
                                    qsTr("这个固件适用于测试者测试. ") +
                                    qsTr("不要用于正式应用场合.")
                        } else if (model.get(index).firmwareType == FirmwareUpgradeController.DeveloperFirmware) {
                            firmwareVersionWarningLabel.visible = true
                            firmwareVersionWarningLabel.text = qsTr("警告: 最新编译的固件. ") +
                                    qsTr("这个固件不是用于测试的. ") +
                                    qsTr("它是用于开发者调试的. ") +
                                    qsTr("没有安全措施的情况下不要使用这版飞行. ")
                        } else {
                            firmwareVersionWarningLabel.visible = false
                        }
                        updatePX4VersionDisplay()
                    }
                }

                QGCLabel {
                    id:         firmwareVersionWarningLabel
                    width:      parent.width
                    wrapMode:   Text.WordWrap
                    visible:    false
                }
            } // Column
        } // QGCViewDialog
    } // Component - pixhawkFirmwareSelectDialogComponent

    Component {
        id: firmwareWarningDialog

        QGCViewMessage {
            message: firmwareWarningMessage

            function accept() {
                hideDialog()
                controller.doFirmwareUpgrade();
            }
        }
    }

    QGCViewPanel {
        id:             panel
        anchors.fill:   parent

        QGCLabel {
            id:             titleLabel
            text:           title
            font.pointSize: ScreenTools.mediumFontPointSize
        }

        ProgressBar {
            id:                 progressBar
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight
            anchors.top:        titleLabel.bottom
            width:              parent.width
        }

        TextArea {
            id:                 statusTextArea
            anchors.topMargin:  ScreenTools.defaultFontPixelHeight
            anchors.top:        progressBar.bottom
            anchors.bottom:     parent.bottom
            width:              parent.width
            readOnly:           true
            frameVisible:       false
            font.pointSize:     ScreenTools.defaultFontPointSize
            textFormat:         TextEdit.RichText
            text:               welcomeText

            style: TextAreaStyle {
                textColor:          qgcPal.text
                backgroundColor:    qgcPal.windowShade
            }
        }
    } // QGCViewPabel
} // QGCView