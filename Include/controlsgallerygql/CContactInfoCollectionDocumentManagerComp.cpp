#include <controlsgallerygql/CContactInfoCollectionDocumentManagerComp.h>


// ImtCore includes
#include <imtbase/IObjectCollectionIterator.h>


namespace controlsgallerygql
{


// protected methods

// reimplemented (CGraphQlHandlerCompBase)

sdl::controlsgallery::ContactInfos::CContactInfoData CContactInfoCollectionDocumentManagerComp::OnGetContactInfoRepresentation(
	const sdl::controlsgallery::ContactInfoCollectionDocumentManager::CGetContactInfoRepresentationGqlRequest& getContactInfoRepresentationRequest,
	const::imtgql::CGqlRequest& gqlRequest,
	QString& errorMessage) const
{
	return sdl::controlsgallery::ContactInfos::CContactInfoData();
}


sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus CContactInfoCollectionDocumentManagerComp::OnUpdateContactInfoFromRepresentation(
	const sdl::controlsgallery::ContactInfoCollectionDocumentManager::CUpdateContactInfoFromRepresentationGqlRequest& updateContactInfoFromRepresentationRequest,
	const ::imtgql::CGqlRequest& gqlRequest,
	QString& errorMessage) const
{
	return sdl::imtbase::CollectionDocumentManager::CDocumentOperationStatus();
}


} // namespace controlsgallerygql

