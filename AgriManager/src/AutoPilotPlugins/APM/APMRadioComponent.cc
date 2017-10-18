﻿/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


#include "APMRadioComponent.h"
#include "APMAutoPilotPlugin.h"
#include "APMAirframeComponent.h"
#include "ParameterManager.h"

#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
    #if defined(_MSC_VER) && (_MSC_VER > 1600)
        // Coding: UTF-8
        #pragma execution_character_set("utf-8")
    #endif
#endif

APMRadioComponent::APMRadioComponent(Vehicle* vehicle, AutoPilotPlugin* autopilot, QObject* parent) :
    VehicleComponent(vehicle, autopilot, parent),
    _name(tr("遥控器"))
{
    _mapParams << QStringLiteral("RCMAP_ROLL") << QStringLiteral("RCMAP_PITCH") << QStringLiteral("RCMAP_YAW") << QStringLiteral("RCMAP_THROTTLE");

    foreach (const QString& mapParam, _mapParams) {
        Fact* fact = _vehicle->parameterManager()->getParameter(-1, mapParam);
        connect(fact, &Fact::valueChanged, this, &APMRadioComponent::_triggerChanged);
    }

    _connectSetupTriggers();
}

QString APMRadioComponent::name(void) const
{
    return _name;
}

QString APMRadioComponent::description(void) const
{
    return tr("遥控器的设置是用来校准你的发射机的. "
              "它还分配了滚转、俯仰、偏航和油门控制的通道，以及确定它们是否被反转.");
}

QString APMRadioComponent::iconResource(void) const
{
    return QStringLiteral("/qmlimages/RadioComponentIcon.png");
}

bool APMRadioComponent::requiresSetup(void) const
{
    return true;
}

bool APMRadioComponent::setupComplete(void) const
{
    // The best we can do to detect the need for a radio calibration is look for attitude
    // controls to be mapped as well as all attitude control rc min/max/trim still at defaults.
    QList<int> mapValues;

    // First check for all attitude controls mapped
    for (int i=0; i<_mapParams.count(); i++) {
        mapValues << _vehicle->parameterManager()->getParameter(FactSystem::defaultComponentId, _mapParams[i])->rawValue().toInt();
        if (mapValues[i] <= 0) {
            return false;
        }
    }

    // Next check RC#_MIN/MAX/TRIM all at defaults
    foreach (const QString& mapParam, _mapParams) {
        int channel = _vehicle->parameterManager()->getParameter(-1, mapParam)->rawValue().toInt();
        if (_vehicle->parameterManager()->getParameter(-1, QString("RC%1_MIN").arg(channel))->rawValue().toInt() != 1100) {
            return true;
        }
        if (_vehicle->parameterManager()->getParameter(-1, QString("RC%1_MAX").arg(channel))->rawValue().toInt() != 1900) {
            return true;
        }
        if (_vehicle->parameterManager()->getParameter(-1, QString("RC%1_TRIM").arg(channel))->rawValue().toInt() != 1500) {
            return true;
        }
    }
    
    return false;
}

QStringList APMRadioComponent::setupCompleteChangedTriggerList(void) const
{
    // APMRadioComponent manages it's own triggers
    return QStringList();
}

QUrl APMRadioComponent::setupSource(void) const
{
    return QUrl::fromUserInput(QStringLiteral("qrc:/qml/RadioComponent.qml"));
}

QUrl APMRadioComponent::summaryQmlSource(void) const
{
    return QUrl::fromUserInput(QStringLiteral("qrc:/qml/APMRadioComponentSummary.qml"));
}

void APMRadioComponent::_connectSetupTriggers(void)
{
    // Disconnect previous triggers
    foreach(Fact* fact, _triggerFacts) {
        disconnect(fact, &Fact::valueChanged, this, &APMRadioComponent::_triggerChanged);
    }
    _triggerFacts.clear();

    // Get the channels for attitude controls and connect to those values for triggers
    foreach (const QString& mapParam, _mapParams) {
        int channel = _vehicle->parameterManager()->getParameter(FactSystem::defaultComponentId, mapParam)->rawValue().toInt();

        Fact* fact = _vehicle->parameterManager()->getParameter(-1, QString("RC%1_MIN").arg(channel));
        _triggerFacts << fact;
        connect(fact, &Fact::valueChanged, this, &APMRadioComponent::_triggerChanged);

        fact = _vehicle->parameterManager()->getParameter(-1, QString("RC%1_MAX").arg(channel));
        _triggerFacts << fact;
        connect(fact, &Fact::valueChanged, this, &APMRadioComponent::_triggerChanged);

        fact = _vehicle->parameterManager()->getParameter(-1, QString("RC%1_TRIM").arg(channel));
        _triggerFacts << fact;
        connect(fact, &Fact::valueChanged, this, &APMRadioComponent::_triggerChanged);
    }
}

void APMRadioComponent::_triggerChanged(void)
{
    emit setupCompleteChanged(setupComplete());

    // Control mapping may have changed so we need to reset triggers
    _connectSetupTriggers();
}