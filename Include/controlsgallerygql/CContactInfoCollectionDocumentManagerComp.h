#pragma once


// Rosa includes
#include <imtservergql/CollectionDocumentManagerDefs.h>
#include <imtservergql/TCollectionDocumentManagerCompBase.h>
#include <controlsgallerysdl/SDL/1.0/CPP/ContactInfoCollectionDocumentManager.h>


COLLECTION_DOCUMENT_MANAGER_DEFS(sdl::controlsgallery::ContactInfoCollectionDocumentManager, ContactInfoCollectionDocumentManager);


namespace controlsgallerygql
{


class CColorCollectionDocumentManagerComp
	: public imtservergql::TCollectionDocumentManagerCompBase<
		sdl::controlsgallery::ContactInfoCollectionDocumentManager::CGraphQlHandlerCompBase,
		ContactInfoCollectionDocumentManager>
{
public:
	typedef TCollectionDocumentManagerCompBase<
		sdl::controlsgallery::ContactInfoCollectionDocumentManager::CGraphQlHandlerCompBase,
		ContactInfoCollectionDocumentManager> BaseClass;

	I_BEGIN_COMPONENT(CColorCollectionDocumentManagerComp)
	I_END_COMPONENT

protected:
};


} // namespace controlsgallerygql
