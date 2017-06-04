//include "../public/interfaces/MongoDbConnector.iol"
include "interfaces/createDbInterface.iol"
include "runtime.iol"
include "string_utils.iol"
include "file.iol"
include "console.iol"

inputPort createDbService {
  Location: "socket://localhost:9100"
  Protocol: sodep
  Interfaces: createDbInterface
}

outputPort ricursive {
  Interfaces: ricursiveAlgo
}

inputPort ricursive{
  Location: "local"
  Interfaces: ricursiveAlgo
}

execution { concurrent }

init
{
	getLocalLocation@Runtime()( ricursive.location )
}

main
{
  [createService( request )( response ) {
    mkdir@File("db_services")( success );
    mkdir@File("db_services/" + request.collection + "_service")();
    mkdir@File("db_services/" + request.collection + "_service/interfaces")();
    mkdir@File("db_services/" + request.collection + "_service/lib")();

    readRequest.filename = "interfaces/MongoDbConnector.iol";
    readFile@File(readRequest)(fileContent);
    writeRequest.filename = "db_services/" + request.collection + "_service/interfaces/MongoDbConnector.iol";
    writeRequest.content = fileContent;
    writeFile@File(writeRequest)();
    undef( writeRequest );

    readRequest.filename = "lib/joda-time-2.4.jar";
    readRequest.format = "binary";
    readFile@File(readRequest)(fileContent);
    writeRequest.filename = "db_services/" + request.collection + "_service/lib/joda-time-2.4.jar";
    writeRequest.content = fileContent;
    writeFile@File( writeRequest )();
    undef( writeRequest );

    readRequest.filename = "lib/mongo-java-driver-3.2.2.jar";
    readRequest.format = "binary";
    readFile@File(readRequest)(fileContent);
    writeRequest.filename = "db_services/" + request.collection + "_service/lib/mongo-java-driver-3.2.2.jar";
    writeRequest.content = fileContent;
    writeFile@File( writeRequest )();
    undef( writeRequest );

    readRequest.filename = "lib/mongodb-driver-3.2.2.jar";
    readRequest.format = "binary";
    readFile@File(readRequest)(fileContent);
    writeRequest.filename = "db_services/" + request.collection + "_service/lib/mongodb-driver-3.2.2.jar";
    writeRequest.content = fileContent;
    writeFile@File( writeRequest )();
    undef( writeRequest );

    readRequest.filename = "lib/mongodb-driver-core-3.2.2.jar";
    readRequest.format = "binary";
    readFile@File(readRequest)(fileContent);
    writeRequest.filename = "db_services/" + request.collection + "_service/lib/mongodb-driver-core-3.2.2.jar";
    writeRequest.content = fileContent;
    writeFile@File( writeRequest )();
    undef( writeRequest );

    readRequest.filename = "lib/MongoDbConnector.jar";
    readRequest.format = "binary";
    readFile@File(readRequest)(fileContent);
    writeRequest.filename = "db_services/" + request.collection + "_service/lib/MongoDbConnector.jar";
    writeRequest.content = fileContent;
    writeFile@File( writeRequest )();

    tree << request.document;

    content = "type operationType : void{
      .eq? : bool
      .lt? : bool
      .gt? : bool
      .lteq? : bool
      .gteq? : bool
      .noteq? : bool
      }
      type create" + request.collection + "Request : void {\n";
    createTypeForCreateRequest@ricursive(tree)(response);
    createFilterType@ricursive(tree)(response2);
    createUpdateType@ricursive(tree)(response3);
    undef( tree );
    tree.docStructure << request.document;
    tree.structurePath = "";
    createUpdateOperation@ricursive(tree)(response4);
    createDocUpdate@ricursive(tree)(response5);
    content = content + response + "
}

type update" + request.collection + "Request : void {
  .filter: void {\n" + response2 + "
  }
  .documentUpdate : void {
    " + response3 + "
  }
}

type delete" + request.collection + "Request : void {
  .filter? : void {\n
    " + response2 +"
  }
}

type query" + request.collection + "Request : void {
  .filter? : void{
    " + response2 + "
  }
  .sort? : undefined
  .limit? : int
}

interface " + request.collection + "Interface {
  RequestResponse : create" + request.collection + "( create" + request.collection + "Request )( void ),
  update" + request.collection + "(update" + request.collection + "Request)(void),
  delete" + request.collection + "(delete" + request.collection + "Request)(void),
  query" + request.collection + "(query" + request.collection + "Request)(void)
} ";
    println@Console( content )();
    undef( writeRequest );
    writeRequest.filename = "db_services/" + request.collection + "_service/interfaces/" + request.collection + "Interface.iol";
    writeRequest.content = content;
    writeFile@File(writeRequest)();
    undef( writeRequest );
    writeRequest.filename = "db_services/" + request.collection + "_service/" + "main_" + request.collection + "_service.ol";
    writeRequest.content =
    "include \"interfaces/MongoDbConnector.iol\"
    include \"interfaces/usersInterface.iol\"
    include \"console.iol\"
    include \"string_utils.iol\"\n
    inputPort UserService {
      Location : \"socket://localhost:8100\"
      Protocol : sodep
      Interfaces : MongoDBInterface, usersInterface
    }

    execution{concurrent}

    init{
      scope (ConnectionMongoDbScope){
        install (defaulta => valueToPrettyString@StringUtils(ConnectionMongoDbScope)();
                 println@Console(s)()
                 );
        with (connectValue){
            .host = \"" + request.connectInfo.host + "\";
            .dbname = \"" + request.connectInfo.dbname +"\";
            .port = " + request.connectInfo.port + ";
            .timeZone = \"" + request.connectInfo.timeZone + "\";";
            if( is_defined( request.connectInfo.jsonStringDebug )  ) {
              if( is_defined( request.connectInfo.logStreamDebug )  ) {
                writeRequest.content = writeRequest.content +
                "\n\t.jsonStringDebug = " + request.connectInfo.jsonStringDebug + ";\n"
              }
              else{
                writeRequest.content = writeRequest.content +
                "\n\t.jsonStringDebug = " + request.connectInfo.jsonStringDebug + "\n"
              }
            };
            if( is_defined( request.connectInfo.logStreamDebug )  ) {
              writeRequest.content = writeRequest.content +
              "\n\t.logStreamDebug = " + request.connectInfo.logStreamDebug + "\n"
            };
            writeRequest.content = writeRequest.content +
            "\t};
            connect@MongoDB(connectValue)()
    }
  }
    main{
      [create" + request.collection + "(create" + request.collection + "Request)(){
        insertRequest.collection = \"" + request.collection + "\";
        insertRequest.document << create" + request.collection + "Request;
        insert@MongoDB(insertRequest)(response);
        valueToPrettyString@StringUtils (response)(s);
        println@Console( s )()
      }]{nullProcess}
      [update" + request.collection + "(request)(){
        filterString = \"\";
        fieldBefore = false;
        " + response4 + "
        updateString = \"\";
        fieldBefore = false;
        " + response5 + "
        updateRequest.filter = \"{\" + filterString + \"}\";
        updateRequest.documentUpdate = \" { $set : { \" + updateString + \" } }\";
        updateRequest.collection = \"" + request.collection + "\";
        update@MongoDB(updateRequest)(updateResponse);
        valueToPrettyString@StringUtils(updateResponse)(s);
        println@Console(\" updateResponse >>> \" + s)()
      }]{nullProcess}
      [delete" + request.collection + "(request)(){
        filterString = \"\";
        fieldBefore = false;
        " + response4 + "
        deleteRequest.filter = \"{ \" + filterString + \" }\";
        deleteRequest.collection = \"" + request.collection + "\";
        delete@MongoDB(deleteRequest)(deleteResponse);
        valueToPrettyString@StringUtils(deleteResponse)(s);
        println@Console(\" deleteResponse >>> \" + s)()
      }]{nullProcess}

      [query" + request.collection + "(request)(){
        filterString = \"\";
        fieldBefore = false;
        " + response4 + "
        queryRequest.collection = \"" + request.collection + "\";
        queryRequest.filter = \"{\" + filterString + \"}\";
        if(is_defined(request.sort)){
          queryRequest.sort << request.sort
        };
        if(is_defined(request.limit)){
          queryRequest.limit << request.limit
        };
        query@MongoDB(queryRequest)(queryResponse);
        valueToPrettyString@StringUtils(queryResponse)(s);
        println@Console(\" queryResponse >>> \" + s)()
      }]{nullProcess}
    }";
    writeFile@File( writeRequest )();
    response = true
  }]{nullProcess}

  [createTypeForCreateRequest(request)(response){
    response = "";
    if( is_defined( request )) {
      foreach ( node : request ){
        //for ( index = 0, index < #request.(node), index ) {
          undef( tree );
          tree << request.( node );
          hasSubNode = false;
          foreach ( subnode : request.( node ) ) {
            hasSubNode = true
          };
          createTypeForCreateRequest@ricursive(tree)( response2 );
          if( node != "multiple" ) {
            if( hasSubNode == true ) {
              if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
                response = response + "\t." + node + "* : " + request.( node ) + " {\n" + response2 + "\t}\n"
              }
              else{
                response = response + "\t." + node + " : " + request.( node ) + " {\n" + response2 + "\t}\n"
              }
            }
            else{
              if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
                response = response + "\t." + node + "* : " + request.( node ) + "\n" + response2
              }
              else{
                response = response + "\t." + node + " : " + request.( node ) + "\n" + response2
              }
            }
          }
        //}
      }
    }
  }]

  [createUpdateType(request)(response){
    response = "";
    if( is_defined( request )) {
      foreach ( node : request ){
        undef( tree );
        tree << request.( node );
        hasSubNode = false;
        foreach ( subnode : request.( node ) ) {
          hasSubNode = true
        };
        createUpdateType@ricursive(tree)( response2 );
        if( node != "multiple" ) {
          if( hasSubNode == true ) {
            if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
              response = response + "\t." + node + "* : " + request.( node ) + " {\n" + response2 + "\t}\n"
            }
            else{
              response = response + "\t." + node + "? : " + request.( node ) + " {\n" + response2 + "\t}\n"
            }
          }
          else{
            if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
              response = response + "\t." + node + "* : " + request.( node ) + "\n" + response2
            }
            else{
              response = response + "\t." + node + "? : " + request.( node ) + "\n" + response2
            }
          }
        }
      }
    }
  }]

  [createFilterType(request)(response){
    response = "";
    if( is_defined( request )) {
      foreach ( node : request ){
        undef( tree );
        tree << request.( node );
        hasSubNode = false;
        foreach ( subnode : request.( node ) ) {
          hasSubNode = true
        };
        createFilterType@ricursive(tree)( response2 );
        if( node != "multiple" ) {
          if( hasSubNode == true ) {
            if(request.( node ) == "int" || request.( node ) == "double" || request.( node ) == "long"){
              if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
                response = response + "\t." + node + "* : " + request.( node ) + " {
                  .operation? : operationType \n " + response2 + "\t}\n"
              }
              else{
                response = response + "\t." + node + "? : " + request.( node ) + " {
                  .operation? : operationType \n " + response2 + "\t}\n"
              }
            }
            else{
              if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
                response = response + "\t." + node + "* : " + request.( node ) + " {\n" + response2 + "\t}\n"
              }
              else{
                response = response + "\t." + node + "? : " + request.( node ) + " {\n" + response2 + "\t}\n"
              }
            }
          }
          else{
            if(request.( node ) == "int" || request.( node ) == "double" || request.( node ) == "long"){
              if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
                response = response + "\t." + node + "* : " + request.( node ) + " {
                  .operation? : operationType \n " + response2 + "\t}\n"
              }
              else{
                response = response + "\t." + node + "? : " + request.( node ) + " {
                  .operation? : operationType \n " + response2 + "\t}\n"
              }
            }
            else{
              if( is_defined( request.(node).multiple ) && request.(node).multiple == true) {
                response = response + "\t." + node + "* : " + request.( node ) + "\n" + response2
              }
              else{
                response = response + "\t." + node + "? : " + request.( node ) + "\n" + response2
              }
            }
          }
        }
      }
    }
  }]{nullProcess}

  [createUpdateOperation( request )( response ){
    response = "";
    if( is_defined( request )) {
      foreach ( node : request.docStructure ){
        for ( index = 0, index < #request.docStructure.(node), index++ ) {
          undef( tree );
          tree.docStructure << request.docStructure.( node )[index];
          hasSubNode = false;
          foreach ( subnode : request.docStructure.( node )[index] ) {
            hasSubNode = true
          };
          if( request.structurePath == "" ) {
            tree.structurePath = node
          }
          else{
            tree.structurePath << request.structurePath;
            tree.structurePath[#tree.structurePath] = node
          };
          createUpdateOperation@ricursive(tree)( response2 );

          filterPath = "";

          for ( y = 0, y < #tree.structurePath, y++ ) {
            if( filterPath == "" ) {
              filterPath = tree.structurePath[y]
            } else {
              filterPath = filterPath + "." + tree.structurePath[y]
            }
          };

          path = "";

          for ( j = 0, j < #tree.structurePath, j++ ) {
            if( path == "" ) {
              path =  tree.structurePath[j]
            } else {
              path = path + "." + tree.structurePath[j]
            }
          };


                if( request.docStructure.( node )[index] == "int" || request.docStructure.( node )[index] == "double" || request.docStructure.( node )[index] == "long" ) {
                    response = response + "if( is_defined( request.filter." + path +  ") && is_defined( request.filter." + path +  ".operation.eq )
                    && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : \" + request.filter." + path + " + \"\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : \" + request.filter." + path + " + \"\"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter." + path +  ") && is_defined( request.filter." + path +  ".operation.lt )
                    && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        updateString = updateString + \", '" + filterPath + "' : { $lt : \" + request.filter." + path + " + \"}\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : { $lt : \" + request.filter." + path + " + \"}\"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter." + path +  ") && is_defined( request.filter." + path +  ".operation.gt )
                    && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : { $lt : \" + request.filter." + path + " + \"}\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : { $lt : \" + request.filter." + path + " + \"}\"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter." + path +  ") && is_defined( request.filter." + path +  ".operation.lteq )
                    && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : { $lte : \" + request.filter." + path + " + \"}\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : { $lte : \" + request.filter." + path + " + \"}\"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter." + path +  ") && is_defined( request.filter." + path +  ".operation.gteq )
                    && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : { $gte : \" + request.filter." + path + " + \"}\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : { $gte : \" + request.filter." + path + " + \"}\"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter." + path +  ") && is_defined( request.filter." + path +  ".operation.noteq )
                    && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : { $ne : \" + request.filter." + path + " + \"}\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : { $ne : \" + request.filter." + path + " + \"}\"
                      };
                      fieldBefore = true
                    }
                    else if(is_defined(request.filter." + path + ") && request.filter." + path + " != null){
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : \" + request.filter." + path + " + \"\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : \" + request.filter." + path + " + \"\"
                      };
                      fieldBefore = true
                    }
                    else{
                        filterString = filterString + \"\"
                    };\n" + response2
                }
                else if (request.docStructure.(node) != "void"){
                    response = response + "if( is_defined( request.filter." + path +  ")  && request.filter." + path + " != null) {
                      if( fieldBefore ) {
                        filterString = filterString + \", '" + filterPath + "' : \\\"\" + request.filter." + path + " + \"\\\"\"
                      }else{
                        filterString = filterString + \" '" + filterPath + "' : \\\"\" + request.filter." + path + " + \"\\\"\"
                      };
                      fieldBefore = true
                    };\n" + response2
                }else{
                  response = response + response2
                }
        }

        }
      }
    }]{nullProcess}


    [createDocUpdate( request )( response ){
      response = "";
      if( is_defined( request )) {
        foreach ( node : request.docStructure ){
          undef( tree );
          tree.docStructure << request.docStructure.( node );
          hasSubNode = false;
          foreach ( subnode : request.docStructure.( node ) ) {
            hasSubNode = true
          };
          if( request.structurePath == "" ) {
            tree.structurePath = node
          }
          else{
            tree.structurePath << request.structurePath;
            tree.structurePath[#tree.structurePath] = node
          };
          createDocUpdate@ricursive(tree)( response2 );

          path = "";

          for ( j = 0, j < #tree.structurePath, j++ ) {
            if( path == "" ) {
              path =  tree.structurePath[j]
            } else if(#tree.structurePath > 2){
              path = path + "." + tree.structurePath[j]
            }
          };

          updatePath = "";

          for ( o = 0, o < #tree.structurePath, o++ ) {
            if( updatePath == "" ) {
              updatePath = tree.structurePath[o]
            } else if(#tree.structurePath > 2){
              updatePath = updatePath + ".0." + tree.structurePath[o]
            }
          };

          if( request.docStructure.(node) == "int" || request.docStructure.(node) == "long" || request.docStructure.(node) == "double" ) {

          containsRequest = updatePath;
          containsRequest.substring = ".";
          contains@StringUtils(containsRequest)(containsResponse);

            if( containsResponse == false && #tree.structurePath == 2 && tree.structurePath[1] != "multiple") {
              response = response + "
              for(index = 0, index < #request.documentUpdate." + tree.structurePath[0] + ", index++){
                if( is_defined( request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + ") && request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + " != null) {
                  if( fieldBefore ) {
                    updateString = updateString + \", '" + tree.structurePath[0] + ".\" + index + \"." + tree.structurePath[1] + "' : \" + request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + "
                  }else{
                    updateString = updateString + \" '" + tree.structurePath[0] + ".\" + index + \"." + tree.structurePath[1] + "' : \" + request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + "
                  };
                  fieldBefore = true
                }
              };\n" + response2
            }
            else if(tree.structurePath[1] != "multiple"){
              response = response + "if( is_defined( request.documentUpdate." + path +  ") && request.documentUpdate." + path +  " != null) {
                if( fieldBefore ) {
                  updateString = updateString + \", '" + updatePath + "' : \" + request.documentUpdate." + path + " + \"\"
                }else{
                  updateString = updateString + \" '" + updatePath + "' : \" + request.documentUpdate." + path + " + \"\"
                };
                fieldBefore = true
              };\n" + response2
            }
            else{
              response = response2 + response
            }
          } else if(request.docStructure.(node) != "void"){
            containsRequest = updatePath;
            containsRequest.substring = ".";
            contains@StringUtils(containsRequest)(containsResponse);

            if( containsResponse == false  && #tree.structurePath == 2 && tree.structurePath[1] != "multiple") {
              response = response + "
              for(index = 0, index < #request.documentUpdate." + tree.structurePath[0] + ", index++){
                if( is_defined( request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + ") && request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + " != null) {
                  if( fieldBefore ) {
                    updateString = updateString + \", '" + tree.structurePath[0] + ".\" + index + \"." + tree.structurePath[1] + "' : \\\"\" + request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + " + \"\\\"\"
                  }else{
                    updateString = updateString + \" '" + tree.structurePath[0] + ".\" + index + \"." + tree.structurePath[1] + "' : \\\"\" + request.documentUpdate." + tree.structurePath[0] + "[index]." + tree.structurePath[1] + " + \"\\\"\"
                  };
                  fieldBefore = true
                }
              };\n" + response2
            }
            else if(tree.structurePath[1] != "multiple"){
              response = response + "if( is_defined( request.documentUpdate." + path +  ") && request.documentUpdate." + path +  " != null) {
                if( fieldBefore ) {
                  updateString = updateString + \", '" + updatePath + "' : \" + request.documentUpdate." + path + " + \"\"
                }else{
                  updateString = updateString + \" '" + updatePath + "' : \" + request.documentUpdate." + path + " + \"\"
                };
                fieldBefore = true
              };\n" + response2
            }
            else{
              response = response + response2
            }
          }
          else{
            response = response + response2
          }
        }
    }
    }]{nullProcess}

}
