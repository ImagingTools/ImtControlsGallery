#include <controlsgallerygql/CContactInfoCollectionDocumentManagerComp.h>


// ACF includes
#include <istd/CChangeGroup.h>

// ImtCore includes
#include <imtbase/IObjectCollectionIterator.h>
#include <imtauth/IContactInfo.h>


namespace controlsgallerygql
{


// protected methods

// reimplemented (CGraphQlHandlerCompBase)

sdl::controlsgallery::ContactInfos::CContactInfoData CContactInfoCollectionDocumentManagerComp::OnGetContactInfoRepresentation(
			const sdl::controlsgallery::ContactInfoCollectionDocumentManager::CGetContactInfoRepresentationGqlRequest& getContactInfoRepresentationRequest,
			const::imtgql::CGqlRequest& /*gqlRequest*/,
			QString& errorMessage) const
{
	sdl::controlsgallery::ContactInfoCollectionDocumentManager::GetContactInfoRepresentationRequestArguments arguments = getContactInfoRepresentationRequest.GetRequestedArguments();
	if (!arguments.input.Version_1_0){
		Q_ASSERT(false);
		return sdl::controlsgallery::ContactInfos::CContactInfoData();
	}

	QByteArray objectId;
	istd::IChangeable* documentPtr = nullptr;
	if (arguments.input.Version_1_0->id){
		objectId = *arguments.input.Version_1_0->id;
		documentPtr = m_documentManagerCompPtr->GetDocument("Test", objectId);
	}

	if (documentPtr == nullptr){
		return sdl::controlsgallery::ContactInfos::CContactInfoData();
	}

	imtauth::IContactInfo* contactInfoPtr = dynamic_cast<imtauth::IContactInfo*>(documentPtr);
	if (contactInfoPtr == nullptr){
		return sdl::controlsgallery::ContactInfos::CContactInfoData();
	}

	sdl::controlsgallery::ContactInfos::CContactInfoData response;
	response.Version_1_0.Emplace();

	response.Version_1_0->firstName = contactInfoPtr->GetNameField(imtauth::IContactInfo::NFT_FIRST_NAME);
	response.Version_1_0->lastName = contactInfoPtr->GetNameField(imtauth::IContactInfo::NFT_LAST_NAME);
	response.Version_1_0->email = contactInfoPtr->GetEmail();

	return response;
}


sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus CContactInfoCollectionDocumentManagerComp::OnUpdateContactInfoFromRepresentation(
			const sdl::controlsgallery::ContactInfoCollectionDocumentManager::CUpdateContactInfoFromRepresentationGqlRequest& updateContactInfoFromRepresentationRequest,
			const ::imtgql::CGqlRequest& /*gqlRequest*/,
			QString& errorMessage) const
{
	sdl::controlsgallery::ContactInfoCollectionDocumentManager::UpdateContactInfoFromRepresentationRequestArguments arguments = updateContactInfoFromRepresentationRequest.GetRequestedArguments();
	if (!arguments.input.Version_1_0){
		Q_ASSERT(false);
		return sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus();
	}

	sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus response;
	response.Version_1_0.Emplace();
	response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::Failed;

	QByteArray documentId;
	if (arguments.input.Version_1_0->documentId){
		documentId = *arguments.input.Version_1_0->documentId;
	}

	sdl::controlsgallery::ContactInfos::CContactInfoData::V1_0 contactInfo;
	if (arguments.input.Version_1_0->contactInfo){
		contactInfo = *arguments.input.Version_1_0->contactInfo;
	}

	istd::IChangeable* documentPtr = m_documentManagerCompPtr->GetDocument("Test", documentId);
	if (documentPtr == nullptr){
		response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::InvalidDocumentId;
		return response;
	}

	imtauth::IContactInfo* contactInfoPtr = dynamic_cast<imtauth::IContactInfo*>(documentPtr);
	if (contactInfoPtr == nullptr){
		response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::InvalidDocumentId;
		return response;
	}

	istd::CChangeGroup changeGroup(contactInfoPtr);

	if (contactInfo.firstName){
		contactInfoPtr->SetNameField(imtauth::IContactInfo::NFT_FIRST_NAME, *contactInfo.firstName);
	}

	if (contactInfo.lastName){
		contactInfoPtr->SetNameField(imtauth::IContactInfo::NFT_LAST_NAME, *contactInfo.lastName);
	}

	if (contactInfo.email){
		contactInfoPtr->SetEmail(*contactInfo.email);
	}

	response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::Success;

	return response;
}


sdl::controlsgallery::ContactInfoCollectionDocumentManager::CEmailData CContactInfoCollectionDocumentManagerComp::OnGetContactInfoEmailRepresentation(
			const sdl::controlsgallery::ContactInfoCollectionDocumentManager::CGetContactInfoEmailRepresentationGqlRequest& getContactInfoEmailRepresentationRequest,
			const ::imtgql::CGqlRequest& /*gqlRequest*/,
			QString& /*errorMessage*/) const
{
	sdl::controlsgallery::ContactInfoCollectionDocumentManager::CEmailData response;
	sdl::controlsgallery::ContactInfoCollectionDocumentManager::GetContactInfoEmailRepresentationRequestArguments arguments = getContactInfoEmailRepresentationRequest.GetRequestedArguments();
	if (!arguments.input.Version_1_0){
		Q_ASSERT(false);
		return response;
	}

	QByteArray objectId;
	istd::IChangeable* documentPtr = nullptr;
	if (arguments.input.Version_1_0->id){
		objectId = *arguments.input.Version_1_0->id;
		documentPtr = m_documentManagerCompPtr->GetDocument("Test", objectId);
	}

	if (documentPtr == nullptr){
		return response;
	}

	imtauth::IContactInfo* contactInfoPtr = dynamic_cast<imtauth::IContactInfo*>(documentPtr);
	if (contactInfoPtr == nullptr){
		return response;
	}

	response.Version_1_0.Emplace();
	response.Version_1_0->email = contactInfoPtr->GetEmail();

	return response;
}


sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus CContactInfoCollectionDocumentManagerComp::OnUpdateContactInfoEmailFromRepresentation(
			const sdl::controlsgallery::ContactInfoCollectionDocumentManager::CUpdateContactInfoEmailFromRepresentationGqlRequest& updateContactInfoEmailFromRepresentationRequest,
			const ::imtgql::CGqlRequest& gqlRequest,
			QString& errorMessage) const
{
	sdl::controlsgallery::ContactInfoCollectionDocumentManager::UpdateContactInfoEmailFromRepresentationRequestArguments arguments = updateContactInfoEmailFromRepresentationRequest.GetRequestedArguments();
	if (!arguments.input.Version_1_0){
		Q_ASSERT(false);
		return sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus();
	}

	sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus response;
	response.Version_1_0.Emplace();
	response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::Failed;

	QByteArray documentId;
	if (arguments.input.Version_1_0->documentId){
		documentId = *arguments.input.Version_1_0->documentId;
	}

	sdl::controlsgallery::ContactInfoCollectionDocumentManager::CEmailData::V1_0 emailInfo;
	if (arguments.input.Version_1_0->email){
		emailInfo = *arguments.input.Version_1_0->email;
	}

	istd::IChangeable* documentPtr = m_documentManagerCompPtr->GetDocument("Test", documentId);
	if (documentPtr == nullptr){
		response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::InvalidDocumentId;
		return response;
	}

	imtauth::IContactInfo* contactInfoPtr = dynamic_cast<imtauth::IContactInfo*>(documentPtr);
	if (contactInfoPtr == nullptr){
		response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::InvalidDocumentId;
		return response;
	}

	if (emailInfo.email){
		istd::CChangeGroup changeGroup(contactInfoPtr);

		contactInfoPtr->SetEmail(*emailInfo.email);
	}

	response.Version_1_0->status = sdl::imtbase::CollectionDocumentManager::EDocumentOperationStatus::Success;

	return response;
}


} // namespace controlsgallerygql

