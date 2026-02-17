import QtQuick
import imtcontrols 1.0

Rectangle {
	id: root

	Rectangle {id: box; width: 100; height: 100; color: "blue"; opacity: 1.0}
	Text {id: label; text: "Normal"; color: "black"}

	StateManager {
		id: stateManager
		states: ({
			"highlighted": [
				{
					target: box,
					properties: {color: "red", opacity: 0.8, width: 150}
				},
				{
					target: label,
					properties: {text: "Highlighted!", color: "red"}
				}
			],
			"disabled": [
				{
					target: box,
					properties: {opacity: 0.3, color: "gray"}
				},
				{
					target: label,
					properties: {text: "Disabled", color: "gray"}
				}
			]
		})
	}

	Row {
		anchors.bottom: parent.bottom
		spacing: 10

		Button { text: "Highlight"; onClicked: {stateManager.state = "highlighted"}}
		Button { text: "Disable"; onClicked: {stateManager.state = "disabled"}}
		Button { text: "Reset"; onClicked: {stateManager.restoreDefaults()}}
	}
}