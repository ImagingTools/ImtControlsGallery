import QtQuick 2.12

import Acf 1.0
import com.imtcore.imtqml 1.0
import imtcontrols 1.0
import imtgui 1.0
import imtdocgui 1.0
import imtguigql 1.0

Rectangle {
	id: sdlTestPage;

	anchors.fill: parent;
	clip: true;

	color: Style.baseColor


	Row{
		anchors.centerIn: parent;
		spacing: 100
		height: 40
		Button{
			text: "Get Param Set"

			onClicked: {

			}
		}

		Button{
			text: "Send Param Set"

			onClicked: {

			}
		}

	}


}

