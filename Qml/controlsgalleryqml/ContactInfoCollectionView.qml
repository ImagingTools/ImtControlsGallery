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

	property DocumentManagerBase documentManager: null
	commandsDelegateComp: Component {
		ViewCommandsDelegateBase {
			id: commandsDelegate

			property DocumentManagerBase documentManager: container.documentManager
			property var documentTypeIds: ["ContactInfo"]
			property var documentTypeNames: ["Contact Info"]

			onDocumentManagerChanged: {
				if (documentManager){
					documentManager.registerDocumentEditorFactory("ContactInfo", contactInfoEditorComp)
					documentManager.registerDocumentRepresentationFactory("ContactInfo", contactInfoRepresentationComp)
				}
			}

			onCommandActivated: {
				if (commandId === "Edit"){
					onEdit()
				}
				else if (commandId === "New"){
					onNew()
				}
			}

			Connections {
				target: container
				function onSelectionChanged(selectedIds, selectedIndexes){
					if (container.commandsController){
						container.commandsController.setCommandIsEnabled("Edit", selectedIds.length > 0)
						container.commandsController.setCommandIsEnabled("Remove", selectedIds.length > 0)
					}
				}
			}

			function onEdit(){
				let elementsModel = container.table.elements
				if (!elementsModel){
					console.error("Unable to edit document. Error: Elements for collection view is invalid")
					return
				}

				let indexes = container.table.getSelectedIndexes()
				if (indexes.length >= 0){
					let itemId = elementsModel.getData("id", indexes[0]);
					let typeId = elementsModel.getData("typeId", indexes[0]);

					documentManager.openDocument(typeId, itemId)
				}
			}

			function onNew(){
				if (documentTypeIds.length === 0){
					console.error("Unable to create new document. Type-ID is empty")
					return
				}

				if (documentTypeIds.length > 1){
					ModalDialogManager.openDialog(selectTypeIdDialogComp)
				}
				else{
					let documentTypeId = documentTypeIds[0]
					documentManager.createDocument(documentTypeId)
				}
			}

			Component {
				id: selectTypeIdDialogComp
		
				Dialog {
					id: selectTypeIdDialog
					title: qsTr("Select Document Type")
					canMove: false
					width: 300

					property string selectedDocumentTypeId

					Component.onCompleted: {
						addButton(Enums.ok, qsTr("OK"), true)
						addButton(Enums.cancel, qsTr("Cancel"), true)
					}

					onFinished: {
						if (buttonId === Enums.ok){
							if (selectedDocumentTypeId !== ""){
								commandsDelegate.documentManager.createDocument(selectedDocumentTypeId)
							}
							else{
								console.error("Unable to create document with type-ID: '" +selectedDocumentTypeId+"'")
							}
						}
					}

					contentComp: Component {
						Item {
							width: selectTypeIdDialog.width
							height: content.height
							Column {
								id: content
								anchors.top: parent.top
								anchors.topMargin: Style.marginL
								anchors.horizontalCenter: parent.horizontalCenter
								width: parent.width - 2 * Style.marginL
								spacing: Style.marginM
	
								BaseText {
									width: parent.width
									text: qsTr("Please select a document type")
								}
	
								ComboBox {
									id: documentTypeCb
									width: parent.width
									currentIndex: 0
									
									onCurrentIndexChanged: {
										if (currentIndex >= 0){
											selectTypeIdDialog.selectedDocumentTypeId = documentTypeCbModel.getData("id", currentIndex)
										}
										else{
											selectTypeIdDialog.selectedDocumentTypeId = ""
										}
									}
	
									TreeItemModel {
										id: documentTypeCbModel
										Component.onCompleted: {
											for (let i = 0; i < commandsDelegate.documentTypeIds.length; ++i){
												let documentTypeId = commandsDelegate.documentTypeIds[i]
												let documentTypeName = commandsDelegate.documentTypeNames[i]
	
												let index = insertNewItem()
												setData("id", documentTypeId, index)
												setData("name", documentTypeName, index)
											}
	
											documentTypeCb.model = documentTypeCbModel
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

	// commandsDelegateComp: Component {DocumentCollectionViewDelegate {
	// 		collectionView: container
			
	// 		documentTypeIds: [container.documenTypeId]
	// 		documentViewTypeIds: ["ContactInfoEditor"]
	// 		documentViewsComp: [contactInfoEditorComp]
	// 		documentDataControllersComp: [dataControllerComp]
	// 		documentValidatorsComp: [documentValidatorComp]
	// 	}
	// }
	
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
		id: contactInfoRepresentationComp
		ContactInfoData {}
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
