import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

// Bateria de controle (DualSense/Xbox) para a barra vertical: visível apenas
// quando um controle está conectado — sumir da barra significa desconectado.
MouseArea {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property var controller: {
        const devs = UPower.devices.values;
        let fallback = null;
        for (let i = 0; i < devs.length; ++i) {
            const d = devs[i];
            const m = (d.model ?? "").toLowerCase();
            const isPad = d.type === UPowerDeviceType.GamingInput
                || m.includes("dualsense") || m.includes("controller")
                || m.includes("gamepad") || m.includes("xbox");
            if (!isPad) continue;
            if (m.includes("dualsense")) return d; // DualSense tem prioridade
            if (!fallback) fallback = d;
        }
        return fallback;
    }
    readonly property bool available: root.controller !== null
    readonly property real percentage: root.controller?.percentage ?? 0
    readonly property bool isCharging: root.controller?.state === UPowerDeviceState.Charging
    readonly property bool isLow: percentage <= Config.options.battery.low / 100

    visible: root.available
    implicitHeight: batteryProgress.implicitHeight
    hoverEnabled: true

    ClippedProgressBar {
        id: batteryProgress
        anchors.centerIn: parent
        vertical: true
        valueBarWidth: 20
        valueBarHeight: 36
        value: root.percentage
        text: Math.round(root.percentage * 100)
        highlightColor: (root.isLow && !root.isCharging) ? Appearance.m3colors.m3error : Appearance.colors.colOnSecondaryContainer

        font {
            pixelSize: 13
            weight: Font.DemiBold
        }

        textMask: Item {
            anchors.centerIn: parent
            width: batteryProgress.valueBarWidth
            height: batteryProgress.valueBarHeight

            Column {
                anchors.centerIn: parent
                spacing: -4

                MaterialSymbol {
                    anchors.horizontalCenter: parent.horizontalCenter
                    fill: 1
                    text: root.isCharging ? "bolt" : "sports_esports"
                    iconSize: Appearance.font.pixelSize.normal
                    animateChange: true
                }
                StyledText {
                    visible: text.length <= 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    font: batteryProgress.font
                    text: batteryProgress.text
                }
            }
        }
    }

    StyledToolTip {
        extraVisibleCondition: root.containsMouse
        text: (root.controller?.model || "Controle") + " — "
              + (root.isCharging ? "carregando" : "conectado") + " — "
              + Math.round(root.percentage * 100) + "%"
    }
}
