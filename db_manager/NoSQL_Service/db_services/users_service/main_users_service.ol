include "interfaces/MongoDbConnector.iol"
    include "interfaces/usersInterface.iol"
    include "console.iol"
    include "string_utils.iol"

    inputPort UserService {
      Location : "socket://localhost:8100"
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
            .host = "localhost";
            .dbname = "prova";
            .port = 27017;
            .timeZone = "Europe/Rome";
	.jsonStringDebug = true
	};
            connect@MongoDB(connectValue)()
    }
  }
    main{
      [createusers(createusersRequest)(){
        insertRequest.collection = "users";
        insertRequest.document << createusersRequest;
        insert@MongoDB(insertRequest)(response);
        valueToPrettyString@StringUtils (response)(s);
        println@Console( s )()
      }]{nullProcess}
      [updateusers(request)(){
        filterString = "";
        fieldBefore = false;
        if( is_defined( request.filter.name.last)  && request.filter.name.last != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.last' : \"" + request.filter.name.last + "\""
                      }else{
                        filterString = filterString + " 'name.last' : \"" + request.filter.name.last + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.name.multiple)  && request.filter.name.multiple != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.multiple' : \"" + request.filter.name.multiple + "\""
                      }else{
                        filterString = filterString + " 'name.multiple' : \"" + request.filter.name.multiple + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.name.first)  && request.filter.name.first != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.first' : \"" + request.filter.name.first + "\""
                      }else{
                        filterString = filterString + " 'name.first' : \"" + request.filter.name.first + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.eq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : " + request.filter.age + ""
                      }else{
                        filterString = filterString + " 'age' : " + request.filter.age + ""
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.lt )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        updateString = updateString + ", 'age' : { $lt : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lt : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.gt )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $lt : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lt : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.lteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $lte : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lte : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.gteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $gte : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $gte : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.noteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $ne : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $ne : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if(is_defined(request.filter.age) && request.filter.age != null){
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : " + request.filter.age + ""
                      }else{
                        filterString = filterString + " 'age' : " + request.filter.age + ""
                      };
                      fieldBefore = true
                    }
                    else{
                        filterString = filterString + ""
                    };

        updateString = "";
        fieldBefore = false;
        
              for(index = 0, index < #request.documentUpdate.name, index++){
                if( is_defined( request.documentUpdate.name[index].last) && request.documentUpdate.name[index].last != null) {
                  if( fieldBefore ) {
                    updateString = updateString + ", 'name." + index + ".last' : \"" + request.documentUpdate.name[index].last + "\""
                  }else{
                    updateString = updateString + " 'name." + index + ".last' : \"" + request.documentUpdate.name[index].last + "\""
                  };
                  fieldBefore = true
                }
              };

              for(index = 0, index < #request.documentUpdate.name, index++){
                if( is_defined( request.documentUpdate.name[index].first) && request.documentUpdate.name[index].first != null) {
                  if( fieldBefore ) {
                    updateString = updateString + ", 'name." + index + ".first' : \"" + request.documentUpdate.name[index].first + "\""
                  }else{
                    updateString = updateString + " 'name." + index + ".first' : \"" + request.documentUpdate.name[index].first + "\""
                  };
                  fieldBefore = true
                }
              };
if( is_defined( request.documentUpdate.age) && request.documentUpdate.age != null) {
                if( fieldBefore ) {
                  updateString = updateString + ", 'age' : " + request.documentUpdate.age + ""
                }else{
                  updateString = updateString + " 'age' : " + request.documentUpdate.age + ""
                };
                fieldBefore = true
              };

        updateRequest.filter = "{" + filterString + "}";
        updateRequest.documentUpdate = " { $set : { " + updateString + " } }";
        updateRequest.collection = "users";
        update@MongoDB(updateRequest)(updateResponse);
        valueToPrettyString@StringUtils(updateResponse)(s);
        println@Console(" updateResponse >>> " + s)()
      }]{nullProcess}
      [deleteusers(request)(){
        filterString = "";
        fieldBefore = false;
        if( is_defined( request.filter.name.last)  && request.filter.name.last != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.last' : \"" + request.filter.name.last + "\""
                      }else{
                        filterString = filterString + " 'name.last' : \"" + request.filter.name.last + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.name.multiple)  && request.filter.name.multiple != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.multiple' : \"" + request.filter.name.multiple + "\""
                      }else{
                        filterString = filterString + " 'name.multiple' : \"" + request.filter.name.multiple + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.name.first)  && request.filter.name.first != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.first' : \"" + request.filter.name.first + "\""
                      }else{
                        filterString = filterString + " 'name.first' : \"" + request.filter.name.first + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.eq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : " + request.filter.age + ""
                      }else{
                        filterString = filterString + " 'age' : " + request.filter.age + ""
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.lt )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        updateString = updateString + ", 'age' : { $lt : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lt : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.gt )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $lt : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lt : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.lteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $lte : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lte : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.gteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $gte : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $gte : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.noteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $ne : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $ne : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if(is_defined(request.filter.age) && request.filter.age != null){
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : " + request.filter.age + ""
                      }else{
                        filterString = filterString + " 'age' : " + request.filter.age + ""
                      };
                      fieldBefore = true
                    }
                    else{
                        filterString = filterString + ""
                    };

        deleteRequest.filter = "{ " + filterString + " }";
        deleteRequest.collection = "users";
        delete@MongoDB(deleteRequest)(deleteResponse);
        valueToPrettyString@StringUtils(deleteResponse)(s);
        println@Console(" deleteResponse >>> " + s)()
      }]{nullProcess}

      [queryusers(request)(){
        filterString = "";
        fieldBefore = false;
        if( is_defined( request.filter.name.last)  && request.filter.name.last != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.last' : \"" + request.filter.name.last + "\""
                      }else{
                        filterString = filterString + " 'name.last' : \"" + request.filter.name.last + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.name.multiple)  && request.filter.name.multiple != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.multiple' : \"" + request.filter.name.multiple + "\""
                      }else{
                        filterString = filterString + " 'name.multiple' : \"" + request.filter.name.multiple + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.name.first)  && request.filter.name.first != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'name.first' : \"" + request.filter.name.first + "\""
                      }else{
                        filterString = filterString + " 'name.first' : \"" + request.filter.name.first + "\""
                      };
                      fieldBefore = true
                    };
if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.eq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : " + request.filter.age + ""
                      }else{
                        filterString = filterString + " 'age' : " + request.filter.age + ""
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.lt )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        updateString = updateString + ", 'age' : { $lt : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lt : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.gt )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $lt : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lt : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.lteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $lte : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $lte : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.gteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $gte : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $gte : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if( is_defined( request.filter.age) && is_defined( request.filter.age.operation.noteq )
                    && request.filter.age != null) {
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : { $ne : " + request.filter.age + "}"
                      }else{
                        filterString = filterString + " 'age' : { $ne : " + request.filter.age + "}"
                      };
                      fieldBefore = true
                    }
                    else if(is_defined(request.filter.age) && request.filter.age != null){
                      if( fieldBefore ) {
                        filterString = filterString + ", 'age' : " + request.filter.age + ""
                      }else{
                        filterString = filterString + " 'age' : " + request.filter.age + ""
                      };
                      fieldBefore = true
                    }
                    else{
                        filterString = filterString + ""
                    };

        queryRequest.collection = "users";
        queryRequest.filter = "{" + filterString + "}";
        if(is_defined(request.sort)){
          queryRequest.sort << request.sort
        };
        if(is_defined(request.limit)){
          queryRequest.limit << request.limit
        };
        query@MongoDB(queryRequest)(queryResponse);
        valueToPrettyString@StringUtils(queryResponse)(s);
        println@Console(" queryResponse >>> " + s)()
      }]{nullProcess}
    }