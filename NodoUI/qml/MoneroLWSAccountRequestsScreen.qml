import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Item {
    id: moneroLWSAccountCreationRequestsScreen
	anchors.fill: parent

    function createRequestListModels() {
        requestListModel.clear()

        for (var index = 0; index < moneroLWS.getRequestAccountSize(); index++) {
            var accountParams = { "requestAddress": moneroLWS.getRequestAccountAddress(index), "scanHeight": moneroLWS.getRequestAccountScanHeight(index)}
            requestListModel.append(accountParams)
        }
    }

    Component.onCompleted: {
        if(moneroLWS.isListRequestsCompleted())
        {
            createRequestListModels()
        }
    }

    Connections {
        target: moneroLWS
        function listRequestsCompleted() {
            createListModels()
        }
    }

    NodoButton {
        id: moneroLWSAcceptAllRequestsButton
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAccountCreationRequestsScreen.top
        text: qsTr("Accept All Requests")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: requestListModel.count > 0 ? true : false
        onClicked: {
            moneroLWS.acceptAllRequests()
        }
    }

    ListView {
        id: requestList
        anchors.top: moneroLWSAcceptAllRequestsButton.bottom
        anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.bottom: moneroLWSAccountCreationRequestsScreen.bottom
        anchors.leftMargin: 10
        anchors.topMargin: 10
        model: requestListModel
        visible: true
        width: 1840
        clip: true

        delegate: MoneroLWSAccountRequestsScreenDelegate {
            id: requestListDelegate
            requestAddress: model.requestAddress
            scanHeight: model.scanHeight
            width: requestList.width
        }
        spacing: 15
    }
    ListModel {
        id: requestListModel
    }
}

