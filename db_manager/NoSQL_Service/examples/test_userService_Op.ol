include "../db_services/users_service/interfaces/usersInterface.iol"
include "console.iol"
include "string_utils.iol"

outputPort UserService {
  Location : "socket://localhost:8100"
  Protocol : sodep
  Interfaces : usersInterface
}

main{
    createusersRequest.name.first = "Danilo";
    createusersRequest.name.last = "Sorano";
    createusersRequest.name[1].first = "Carlo";
    createusersRequest.name[1].last = "Antonio";
    createusersRequest.age = 22;
    createusers@UserService(createusersRequest)();
    updateusersRequest.filter.age = 22;
    updateusersRequest.filter.age.operation.gteq = true;
    updateusersRequest.documentUpdate.name.last = "Cracco";
    updateusers@UserService(updateusersRequest)()

    /*queryusersRequest.filter.name.first = "Danilo";
    queryusers@UserService(queryusersRequest)()*/
}
