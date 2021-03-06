import QtQuick 2.3
import QtQuick.Controls 1.2

import QGroundControl.FactSystem 1.0
import QGroundControl.FactControls 1.0
import QGroundControl.Controls 1.0
import QGroundControl.Palette 1.0

FactPanel {
    id:             panel
    anchors.fill:   parent
    color:          qgcPal.windowShadeDark

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }
    FactPanelController { id: controller; factPanel: panel }

    property Fact returnAltFact:    controller.getParameterFact(-1, "RTL_RETURN_ALT")
    property Fact descendAltFact:   controller.getParameterFact(-1, "RTL_DESCEND_ALT")
    property Fact landDelayFact:    controller.getParameterFact(-1, "RTL_LAND_DELAY")
    property Fact commRCLossFact:   controller.getParameterFact(-1, "COM_RC_LOSS_T")
    property Fact lowBattAction:    controller.getParameterFact(-1, "COM_LOW_BAT_ACT")
    property Fact rcLossAction:     controller.getParameterFact(-1, "NAV_RCL_ACT")
    property Fact dataLossAction:   controller.getParameterFact(-1, "NAV_DLL_ACT")

    Column {
        anchors.fill:       parent

        VehicleSummaryRow {
            labelText: qsTr("返航最小高度:")
            valueText: returnAltFact ? returnAltFact.valueString + " " + returnAltFact.units : ""
        }

        VehicleSummaryRow {
            labelText: qsTr("返航高度:")
            valueText: descendAltFact ? descendAltFact.valueString + " " + descendAltFact.units : ""
        }

        VehicleSummaryRow {
            labelText: qsTr("遥控器失效返航:")
            valueText: commRCLossFact ? commRCLossFact.valueString + " " + commRCLossFact.units : ""
        }

        VehicleSummaryRow {
            labelText: qsTr("遥控器失效动作:")
            valueText: rcLossAction ? rcLossAction.enumStringValue : ""
        }

        VehicleSummaryRow {
            labelText: qsTr("数据链失效动作:")
            valueText: dataLossAction ? dataLossAction.enumStringValue : ""
        }

        VehicleSummaryRow {
            labelText: qsTr("低电压动作:")
            valueText: lowBattAction ? lowBattAction.enumStringValue : ""
        }

    }
}
