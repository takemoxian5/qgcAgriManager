﻿import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQml                    2.2

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0


/// Mission item edit control
Rectangle {
    id:     _root
    height: editorLoader.y + (editorLoader.visible ? editorLoader.height : 0) + (_margin * 2)
    color:  _currentItem ? qgcPal.missionItemEditor : qgcPal.windowShade
    radius: _radius

    property var    map                 ///< Map control
    property var    masterController
    property var    missionItem         ///< MissionItem associated with this editor
    property bool   readOnly            ///< true: read only view, false: full editing view
    property var    rootQgcView

    signal clicked
    signal remove
    signal insertWaypoint
    signal insertComplexItem(string complexItemName)

    property var    _masterController:          masterController
    property var    _missionController:         _masterController.missionController
    property bool   _currentItem:               missionItem.isCurrentItem
    property color  _outerTextColor:            _currentItem ? qgcPal.primaryButtonText : qgcPal.text
    property bool   _noMissionItemsAdded:       ListView.view.model.count === 1
    property real   _sectionSpacer:             ScreenTools.defaultFontPixelWidth / 2  // spacing between section headings
    property bool   _singleComplexItem:         _missionController.complexMissionItemNames.length === 1

    readonly property real  _editFieldWidth:    Math.min(width - _margin * 2, ScreenTools.defaultFontPixelWidth * 12)
    readonly property real  _margin:            ScreenTools.defaultFontPixelWidth / 2
    readonly property real  _radius:            ScreenTools.defaultFontPixelWidth / 2
    readonly property real  _hamburgerSize:     commandPicker.height * 0.75
    readonly property bool  _waypointsOnlyMode: QGroundControl.corePlugin.options.missionWaypointsOnly

    QGCPalette {
        id: qgcPal
        colorGroupEnabled: enabled
    }

    FocusScope {
        id:             currentItemScope
        anchors.fill:   parent

        MouseArea {
            anchors.fill:   parent
            onClicked: {
                currentItemScope.focus = true
                _root.clicked()
            }
        }
    }

    QGCLabel {
        id:                     label
        anchors.verticalCenter: commandPicker.verticalCenter
        anchors.leftMargin:     _margin
        anchors.left:           parent.left
        text:                   missionItem.homePosition ? "H" : missionItem.sequenceNumber
        color:                  _outerTextColor
    }

    QGCColoredImage {
        id:                     hamburger
        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
        anchors.right:          parent.right
        anchors.verticalCenter: commandPicker.verticalCenter
        width:                  _hamburgerSize
        height:                 _hamburgerSize
        sourceSize.height:      _hamburgerSize
        source:                 "qrc:/qmlimages/Hamburger.svg"
        visible:                missionItem.isCurrentItem && missionItem.sequenceNumber != 0
        color:                  qgcPal.windowShade

    }

    QGCMouseArea {
        fillItem:   hamburger
        visible:    hamburger.visible
        onClicked: {
            currentItemScope.focus = true
            hamburgerMenu.popup()
        }

        Menu {
            id: hamburgerMenu

            MenuItem {
                text:           qsTr("插入航点")
                onTriggered:    insertWaypoint()
            }

            Menu {
                id:         patternMenu
                title:      qsTr("插入模式")
                visible:    !_singleComplexItem

                Instantiator {
                    model: _missionController.complexMissionItemNames

                    onObjectAdded:      patternMenu.insertItem(index, object)
                    onObjectRemoved:    patternMenu.removeItem(object)

                    MenuItem {
                        text:           modelData
                        onTriggered:    insertComplexItem(modelData)
                    }
                }
            }

            MenuItem {
                text:           qsTr("插入 ") + _missionController.complexMissionItemNames[0]
                visible:        _singleComplexItem
                onTriggered:    insertComplexItem(_missionController.complexMissionItemNames[0])
            }

            MenuItem {
                text:           qsTr("删除")
                onTriggered:    remove()
            }

            MenuItem {
                text:           qsTr("修改命令...")
                onTriggered:    commandPicker.clicked()
                visible:        !_waypointsOnlyMode
            }

            MenuSeparator {
                visible: missionItem.isSimpleItem && !_waypointsOnlyMode
            }

            MenuItem {
                text:       qsTr("显示所有数据")
                checkable:  true
                checked:    missionItem.isSimpleItem ? missionItem.rawEdit : false
                visible:    missionItem.isSimpleItem && !_waypointsOnlyMode

                onTriggered:    {
                    if (missionItem.rawEdit) {
                        if (missionItem.friendlyEditAllowed) {
                            missionItem.rawEdit = false
                        } else {
                            qgcView.showMessage(qsTr("任务管理"), qsTr("你已经对任务项做出了改变不能以简单模式显示"), StandardButton.Ok)
                        }
                    } else {
                        missionItem.rawEdit = true
                    }
                    checked = missionItem.rawEdit
                }
            }
        }
    }

    QGCButton {
        id:                     commandPicker
        anchors.topMargin:      _margin / 2
        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 2
        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
        anchors.left:           label.right
        anchors.top:            parent.top
        visible:                !commandLabel.visible
        text:                   missionItem.commandName

        Component {
            id: commandDialog

            MissionCommandDialog {
                missionItem: _root.missionItem
            }
        }

        onClicked: qgcView.showDialog(commandDialog, qsTr("选择任务命令"), qgcView.showDialogDefaultWidth, StandardButton.Cancel)
    }

    QGCLabel {
        id:                 commandLabel
        anchors.fill:       commandPicker
        visible:            !missionItem.isCurrentItem || !missionItem.isSimpleItem || _waypointsOnlyMode
        verticalAlignment:  Text.AlignVCenter
        text:               missionItem.commandName
        color:              _outerTextColor
    }

    Loader {
        id:                 editorLoader
        anchors.leftMargin: _margin
        anchors.topMargin:  _margin
        anchors.left:       parent.left
        anchors.top:        commandPicker.bottom
        source:             missionItem.editorQml
        visible:            _currentItem

        property var    masterController:   _masterController
        property real   availableWidth:     _root.width - (_margin * 2) ///< How wide the editor should be
        property var    editorRoot:         _root
    }
} // Rectangle
