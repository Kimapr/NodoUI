import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0


Item {
    id: lockPinScreen
    property int labelSize: 0
    property int inputFieldWidth: 600
    property int defaultHeight: 64
    property bool pinFieldReadOnly: false
    property bool isLockPinEnabled: false

    signal deleteMe(int screenID)

    Component.onCompleted: {
        isLockPinEnabled = nodoControl.isLockPinEnabled()
        onCalculateMaximumTextLabelLength()
        lockPinSwitch.checked = isLockPinEnabled
        lockPinControlLockAfterField.valueText = nodoControl.getLockAfterTime()

        if(isLockPinEnabled)
        {
            lockPinScreen.state = "pinControlEnabled"
        }
        else
        {
            lockPinScreen.state = ""
        }
    }

    function onCalculateMaximumTextLabelLength() {
        if(lockPinControlLockAfterField.labelRectRoundSize > labelSize)
            labelSize = lockPinControlLockAfterField.labelRectRoundSize

        if(lockPinControlNewPinField.labelRectRoundSize > labelSize)
            labelSize = lockPinControlNewPinField.labelRectRoundSize

        if(lockPinControlReEnterNewPinField.labelRectRoundSize > labelSize)
            labelSize = lockPinControlReEnterNewPinField.labelRectRoundSize
    }

    function setButtonStatus(){
        if((lockPinControlNewPinField.valueText.length === 6) && (lockPinControlReEnterNewPinField.valueText.length === 6))
        {
            lockPinControlSetNewPin.isActive = true
        }
        else
        {
            lockPinControlSetNewPin.isActive = false
        }
    }

    Rectangle {
        id: lockPinSwitchRect
        anchors.left: lockPinScreen.left
        anchors.top: lockPinScreen.top
        height: NodoSystem.nodoItemHeight
        color: "black"

        NodoLabel{
            id: lockPinSwitchText
            height: lockPinSwitchRect.height
            anchors.left: lockPinSwitchRect.left
            anchors.top: lockPinSwitchRect.top
            text: qsTr("Lock with PIN")
        }

        NodoSwitch {
            id: lockPinSwitch
            anchors.left: lockPinSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: lockPinSwitchText.height
            width: 2*lockPinSwitchText.height
            display: AbstractButton.IconOnly
            onCheckedChanged: {
                if(!checked)
                {
                    nodoControl.disableLockPin()
                    lockPinScreen.state = ""
                    isLockPinEnabled = nodoControl.isLockPinEnabled()
                }
                else
                {
                    lockPinScreen.state = "pinControlEnabled"
                }
            }
        }
    }

    Rectangle {
        id: lockPinControlRect
        anchors.left: lockPinScreen.left
        anchors.right: lockPinScreen.right
        anchors.top: lockPinSwitchRect.bottom
        height: lockPinControlSetNewPin.height + lockPinControlSetNewPin.y
        anchors.topMargin: 20
        color: "black"
        visible:  lockPinScreen.state === "pinControlEnabled" ? true : false

        NodoInputField {
            id: lockPinControlLockAfterField
            anchors.left: lockPinControlRect.left
            anchors.top: lockPinControlRect.top
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Lock after")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{bottom: 1}
            onTextEditFinished: {
                nodoControl.setLockAfterTime(lockPinControlLockAfterField.valueText)
            }
        }

        Rectangle {
            id: lockPinControlLockAfterTimeRect
            anchors.left: lockPinControlLockAfterField.right
            anchors.top: lockPinControlLockAfterField.top
            anchors.leftMargin: 8
            color: "black"

            Text {
                id: lockPinControlLockAfterTimeUnit
                text: qsTr("minutes")
                anchors.left: lockPinControlLockAfterTimeRect.right
                height: NodoSystem.infoFieldLabelHeight
                verticalAlignment: Text.AlignVCenter
                font.family: NodoSystem.fontUrbanist.name
                font.pixelSize: NodoSystem.inputFieldValueFontSize
                color: nodoControl.appTheme ? NodoSystem.dataFieldTextColorNightModeOn : NodoSystem.dataFieldTextColorNightModeOff
            }
        }

        NodoInputField {
            id: lockPinControlNewPinField
            anchors.left: lockPinControlRect.left
            anchors.top: lockPinControlLockAfterField.bottom
            anchors.topMargin: 30
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("New PIN")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{top: 999999}
            valueText: ""
            readOnlyFlag: pinFieldReadOnly
            onTextEditFinished: {
                setButtonStatus()
            }
        }

        NodoInputField {
            id: lockPinControlReEnterNewPinField
            anchors.left: lockPinControlRect.left
            anchors.top: lockPinControlNewPinField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            width: inputFieldWidth
            height: NodoSystem.inputFieldLabelHeight
            itemSize: labelSize
            itemText: qsTr("Re-enter New PIN")
            textFlag: Qt.ImhDigitsOnly
            validator: IntValidator{top: 999999}
            valueText: ""
            readOnlyFlag: pinFieldReadOnly
            onTextEditFinished: {
                setButtonStatus()
            }
        }

        NodoButton {
            id: lockPinControlSetNewPin
            anchors.left: lockPinControlRect.left
            anchors.top: lockPinControlReEnterNewPinField.bottom
            anchors.topMargin: NodoSystem.nodoTopMargin
            text: qsTr("Change PIN")
            height: NodoSystem.nodoItemHeight
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.buttonTextFontSize
            isActive: false
            onClicked: {
                lockPinControlSetNewPin.isActive = false
                pinFieldReadOnly = true
                var newPin = lockPinControlNewPinField.valueText
                var newPin2 = lockPinControlReEnterNewPinField.valueText

                if(newPin === newPin2)
                {
                    nodoControl.setLockPin(newPin);
                }
                else
                {
                    nodoLockPinControlPopup.commandID = -1;
                    nodoLockPinControlPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.PINCodesAreDifferent]
                    nodoLockPinControlPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                    nodoLockPinControlPopup.open();
                }


                lockPinControlNewPinField.valueText = ""
                lockPinControlReEnterNewPinField.valueText = ""
                pinFieldReadOnly = false
            }
        }
    }

    NodoPopup {
        id: nodoLockPinControlPopup
        onApplyClicked: {
            close()
        }
    }
}
