#include <controlsgallerygql/CParamsSetTestControllerComp.h>


namespace controlsgallerygql
{


// protected methods

// reimplemented (sdl::controlsgallery::ParamsSetTest::CGraphQlHandlerCompBase)

sdl::imtbase::ImtBaseTypes::CParamsSet CParamsSetTestControllerComp::OnGetParamsSet(const sdl::controlsgallery::ParamsSetTest::CGetParamsSetGqlRequest& getParamsSetRequest, const::imtgql::CGqlRequest& gqlRequest, QString& errorMessage) const
{
	sdl::imtbase::ImtBaseTypes::CParamsSet retVal;
	retVal.Version_1_0.emplace();

	// Text parameter
	sdl::imtbase::ImtBaseTypes::CTextParam strParam;
	strParam.Version_1_0.emplace().text = "SampleText";

	QJsonObject jsonObject;
	if (!strParam.WriteToJsonObject(jsonObject, strParam.PV_1_0)){
		false;
	}
	QJsonDocument jsonDocument;
	jsonDocument.setObject(jsonObject);

	// ParamsSet parameter
	sdl::imtbase::ImtBaseTypes::CParameter::V1_0 param;
	param.id = "SampleId";
	param.name = "SampleName";
	param.description = "SampleDesc";
	param.enabled = true;
	param.typeId = "SampleId";
	param.data = jsonDocument.toJson(QJsonDocument::Compact);

	retVal.Version_1_0->parameters.emplace().append(param);

	return sdl::imtbase::ImtBaseTypes::CParamsSet();
}


sdl::controlsgallery::ParamsSetTest::CSetParamsSetResult CParamsSetTestControllerComp::OnSetParamsSet(const sdl::controlsgallery::ParamsSetTest::CSetParamsSetGqlRequest& setParamsSetRequest, const::imtgql::CGqlRequest& gqlRequest, QString& errorMessage) const
{
	sdl::controlsgallery::ParamsSetTest::CSetParamsSetResult retVal;

	retVal.Version_1_0.emplace().result = true;

	return retVal;
}


} // namespace controlsgallerygql


