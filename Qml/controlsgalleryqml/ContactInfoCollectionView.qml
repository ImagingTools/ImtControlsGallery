import QtQuick 2.12
import Acf 1.0
import imtgui 1.0
import imtauthgui 1.0
import imtcolgui 1.0
import imtcontrols 1.0
import imtguigql 1.0
import imtdocgui 1.0
import controlsgalleryContactInfosSdl 1.0
import controlsgalleryContactInfoCollectionDocumentManagerSdl 1.0
import imtbaseCollectionDocumentManagerSdl 1.0
import imtbaseUndoManagerSdl 1.0

RemoteCollectionView {
	id: container

	collectionId: "ContactInfos"
	gqlGetListCommandId: ControlsgalleryContactInfosSdlCommandIds.s_contactInfoList

	property DocumentManagerBase documentManager: null

	Component.onCompleted: {
		table.setSortingInfo(ContactInfoItemDataTypeMetaInfo.s_timeStamp, "ASC") // Sort by default
	}

	commandsDelegateComp: Component {
		DocCollectionViewDelegate {
			documentTypeIds: ["ContactInfo"]
			documentTypeNames: ["Contact Info"]
			documentViewTypeIds: ["ContactInfoEditor"]
			documentEditorsComp: [contactInfoEditorComp]
			documentDataControllersComp: [contactInfoDataControllerFactory]

			collectionView: container

			Component {
				id: contactInfoEditorComp
				
				ContactInfoEditor {
					id: contactInfoEditor
					commandsControllerComp: Component {
						GqlBasedCommandsController {
							typeId: "ContactInfo"
						}
					}
				}
			}

			Component {
				id: contactInfoDataControllerFactory

				DocumentRepresentationController {
					id: root
				
					representationModel: ContactInfoData {}

					function updateRepresentationFromDocument(){
						documentIdInput.m_id = documentId
						getContactInfoRequest.send(documentIdInput)
					}
				
					function updateDocumentFromRepresentation(){
						updateContactInfoInput.m_documentId = documentId
						updateContactInfoInput.m_contactInfo = representationModel

						updateContactInfoRequest.send(updateContactInfoInput)
					}

					property DocumentId documentIdInput: DocumentId {}
					property GqlSdlRequestSender getContactInfoRequest: GqlSdlRequestSender {
						gqlCommandId: ControlsgalleryContactInfoCollectionDocumentManagerSdlCommandIds.s_getContactInfoRepresentation
						sdlObjectComp: Component {
							ContactInfoData {
								onFinished: {
									root.representationModel.copyFrom(this)
									root.representationUpdated(root.documentId, root.representationModel)
								}
							}
						}
					}

					property UpdateContactInfoInput updateContactInfoInput: UpdateContactInfoInput {}
					property GqlSdlRequestSender updateContactInfoRequest: GqlSdlRequestSender {
						gqlCommandId: ControlsgalleryContactInfoCollectionDocumentManagerSdlCommandIds.s_updateContactInfoFromRepresentation
						requestType: 1
						sdlObjectComp: Component {
							DocumentOperationStatus {
								onFinished: {
									if (m_status === "Success"){
										root.documentUpdated(root.documentId)
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
