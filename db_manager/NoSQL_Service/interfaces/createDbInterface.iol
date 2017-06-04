type connectionInfo : void {
  .host : string
  .dbname : string
  .port :int
  .timeZone:string
  .jsonStringDebug?:bool
  .logStreamDebug?:bool
}

type createDbRequest: void {
  .connectInfo :connectionInfo
  .collection : string
  .document: undefined
}

type updateOperationRequest : void {
  .docStructure : undefined
  .structurePath* : string
}

interface createDbInterface {
  RequestResponse:
  createService( createDbRequest )( bool ) throws IOException
}

interface ricursiveAlgo {
  RequestResponse:
  createTypeForCreateRequest( undefined )( string ),
  createFilterType( undefined )( string ),
  createUpdateType( undefined )( string ),
  createUpdateOperation( updateOperationRequest )( string ),
  createDocUpdate( updateOperationRequest )( string )
}
