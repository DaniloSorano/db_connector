type operationType : void{
      .eq? : bool
      .lt? : bool
      .gt? : bool
      .lteq? : bool
      .gteq? : bool
      .noteq? : bool
      }
      type createusersRequest : void {
	.name* : void {
	.last : string
	.first : string
	}
	.age : int

}

type updateusersRequest : void {
  .filter: void {
	.name* : void {
	.last? : string
	.first? : string
	}
	.age? : int {
                  .operation? : operationType 
 	}

  }
  .documentUpdate : void {
    	.name* : void {
	.last? : string
	.first? : string
	}
	.age? : int

  }
}

type deleteusersRequest : void {
  .filter? : void {

    	.name* : void {
	.last? : string
	.first? : string
	}
	.age? : int {
                  .operation? : operationType 
 	}

  }
}

type queryusersRequest : void {
  .filter? : void{
    	.name* : void {
	.last? : string
	.first? : string
	}
	.age? : int {
                  .operation? : operationType 
 	}

  }
  .sort? : undefined
  .limit? : int
}

interface usersInterface {
  RequestResponse : createusers( createusersRequest )( void ),
  updateusers(updateusersRequest)(void),
  deleteusers(deleteusersRequest)(void),
  queryusers(queryusersRequest)(void)
} 