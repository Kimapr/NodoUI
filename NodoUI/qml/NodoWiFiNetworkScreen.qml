import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: wifiNetworkScreen
    width: parent.width
    height: parent.height
    property bool isWirelessEnabled

    function updateWifiDeviceStatus() {
        var deviceStatus = networkManager.getWifiDeviceStatus()
        wifiEnabledSwitch.enabled = true

        if(deviceStatus === 10)
        {
            wifiNetworkScreen.isWirelessEnabled = false
            wifiEnabledSwitch.enabled = false
            systemPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.NoNetworkDevice]
            systemPopup.commandID = -1;
            systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            systemPopup.open();
        }
        else if(deviceStatus === 20)
        {
            wifiNetworkScreen.isWirelessEnabled = false
        }
        else if((deviceStatus === 30) || (deviceStatus === 100))
        {
            wifiNetworkScreen.isWirelessEnabled = true
        }

        wifiEnabledSwitch.checked = wifiNetworkScreen.isWirelessEnabled

        if(wifiNetworkScreen.isWirelessEnabled === true)
        {
            pageLoader.source = "NodoWiFiNetworkListView.qml"
        }
        else
        {
            pageLoader.source = ""
        }

    }

    Component.onCompleted: {
        updateWifiDeviceStatus()
    }

    Connections {
        target: networkManager
        function onWifiDeviceStatusChanged() {
            updateWifiDeviceStatus()
        }
    }

    Rectangle {
        id: wifiEnabledRect
        anchors.left: wifiNetworkScreen.left
        anchors.top: wifiNetworkScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: wifiEnabledSwitchText
            height: wifiEnabledRect.height
            anchors.left: wifiEnabledRect.left
            anchors.top: wifiEnabledRect.top
            text: systemMessages.messages[NodoMessages.Message.WiFi]
        }

        NodoSwitch {
            id: wifiEnabledSwitch
            anchors.left: wifiEnabledSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: wifiEnabledRect.height
            width: 2*wifiEnabledRect.height
            display: AbstractButton.IconOnly
            checked: networkManager.getWifiDeviceStatus() > 20 ? true : false//wifiNetworkScreen.isWirelessEnabled
            onCheckedChanged: {
                networkManager.setWifiDeviceStatus(wifiEnabledSwitch.checked)
            }
        }
    }

    Rectangle {
        id: wifiNetworkView
        anchors.top: wifiEnabledRect.bottom
        anchors.left: wifiNetworkScreen.left
        anchors.right: wifiNetworkScreen.right
        anchors.bottom: wifiNetworkScreen.bottom
        anchors.topMargin: 16
        color: "black"
        visible: wifiEnabledSwitch.checked

        Loader {
            id: pageLoader
            anchors.top: wifiNetworkView.top
            anchors.left: wifiNetworkView.left
            anchors.right: wifiNetworkView.right
            anchors.bottom: wifiNetworkView.bottom
        }
    }

}
