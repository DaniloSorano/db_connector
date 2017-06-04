include "../interfaces/createDbInterface.iol"

outputPort createDbService {
  Location: "socket://localhost:9100"
  Protocol: sodep
  Interfaces: createDbInterface
}
main
{
  with( request.connectInfo ){
    .host = "localhost";
    .dbname ="prova";
    .port = 27017;
    .timeZone = "Europe/Rome";
    .jsonStringDebug = true
  };
  request.collection = "users";
  request.document.name = "void";
  request.document.name.multiple = true;
  request.document.name.first = "string";
  request.document.name.last = "string";
  request.document.age = "int";
  //request.document.
  createService@createDbService( request )( response )
}
