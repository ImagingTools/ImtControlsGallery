import QtQuick 2.12
import Acf 1.0
import com.imtcore.imtqml 1.0
import imtgui 1.0
import imtauthgui 1.0
import imtcolgui 1.0
import imtcontrols 1.0
import imtguigql 1.0
import imtdocgui 1.0
import controlsgalleryContactInfosSdl 1.0

RemoteCollectionView {
	id: container

	collectionId: "ContactInfos"
	gqlGetListCommandId: ControlsgalleryContactInfosSdlCommandIds.s_contactInfoList

	property string documenTypeId: "ContactInfo"

	commandsDelegateComp: Component {DocumentCollectionViewDelegate {
			collectionView: container
			
			documentTypeIds: [container.documenTypeId]
			documentViewTypeIds: ["ContactInfoEditor"]
			documentViewsComp: [contactInfoEditorComp]
			documentDataControllersComp: [dataControllerComp]
			documentValidatorsComp: [documentValidatorComp]
		}
	}
	
	Component.onCompleted: {
		table.setSortingInfo(ContactInfoItemDataTypeMetaInfo.s_timeStamp, "ASC") // Sort by default
	}
	
	Component {
		id: contactInfoEditorComp
		
		ContactInfoEditor {
			id: contactInfoEditor
			commandsControllerComp: Component {GqlBasedCommandsController {
					typeId: "ContactInfo"
				}
			}
		}
	}

	Component {
		id: documentValidatorComp;
		
		DocumentValidator {
			property ContactInfoData contactInfoData: documentModel

			function isValid(data){
				if (contactInfoData.m_firstName === "" ||
					contactInfoData.m_lastName === ""){
					return false
				}
				
				return true
			}
		}
	}
	
	Component {
		id: dataControllerComp;
		
		GqlRequestDocumentDataController {
			id: requestDocumentDataController
			
			property ContactInfoData contactInfoData: documentModel
			
			gqlGetCommandId: ControlsgalleryContactInfosSdlCommandIds.s_getContactInfo
			gqlUpdateCommandId: ControlsgalleryContactInfosSdlCommandIds.s_updateContactInfo
			gqlAddCommandId: ControlsgalleryContactInfosSdlCommandIds.s_addContactInfo
			
			typeId: container.documenTypeId;

			documentModelComp: Component {
				ContactInfoData {}
			}
		}
	}
}
