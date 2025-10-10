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

	Component.onCompleted: {
		table.setSortingInfo(ContactInfoItemDataTypeMetaInfo.s_timeStamp, "ASC") // Sort by default
	}

	commandsDelegateComp: Component {
		DocCollectionViewDelegate {
			documentTypeIds: ["ContactInfo", "ContactInfo"]
			documentTypeNames: ["Contact Info", "Contact Info"]
			documentViewTypeIds: ["ContactInfoEditor", "ContactEmailEditor"]
			documentEditorsComp: [contactInfoEditorComp, emailContactInfoEditorComp]
			documentDataControllersComp: [contactInfoDataControllerFactory, contactInfoEmailDataControllerFactory]
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
				id: emailContactInfoEditorComp
				
				ViewBase {
					id: emailContactInfoEditor
					
					anchors.fill: parent
					
					property EmailData emailData: model
					
					commandsControllerComp: Component {
						GqlBasedCommandsController {
							typeId: "ContactInfo"
						}
					}

					function updateGui(){
						emailInput.text = emailData.m_email
					}

					function updateModel(){
						emailData.m_email = emailInput.text
					}

					Column {
						id: content
						width: 700
						spacing: Style.marginXL
						TextInputElementView {
							id: emailInput
							
							name: qsTr("Email")
							placeHolderText: qsTr("Enter the email")

							onEditingFinished: {
								emailContactInfoEditor.doUpdateModel()
							}
						}
					}
				}
			}

			Component {
				id: contactInfoEmailDataControllerFactory

				DocumentRepresentationController {
					id: root

					representationModel: EmailData {}

					function updateRepresentationFromDocument(){
						documentIdInput.m_id = documentId
						getContactInfoRequest.send(documentIdInput)
					}

					function updateDocumentFromRepresentation(){
						updateContactInfoInput.m_documentId = documentId
						updateContactInfoInput.m_email = representationModel

						updateContactInfoRequest.send(updateContactInfoInput)
					}

					property DocumentId documentIdInput: DocumentId {}
					property GqlSdlRequestSender getContactInfoRequest: GqlSdlRequestSender {
						gqlCommandId: ControlsgalleryContactInfoCollectionDocumentManagerSdlCommandIds.s_getContactInfoEmailRepresentation
						sdlObjectComp: Component {
							ContactInfoData {
								onFinished: {
									root.representationModel.copyFrom(this)
									root.representationUpdated(root.documentId, root.representationModel)
								}
							}
						}
					}

					property UpdateContactInfoEmailInput updateContactInfoInput: UpdateContactInfoEmailInput {}
					property GqlSdlRequestSender updateContactInfoRequest: GqlSdlRequestSender {
						gqlCommandId: ControlsgalleryContactInfoCollectionDocumentManagerSdlCommandIds.s_updateContactInfoEmailFromRepresentation
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
