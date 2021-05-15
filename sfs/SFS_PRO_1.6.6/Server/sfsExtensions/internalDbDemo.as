/*
* SmartFoxServer PRO
* Simple H2 database example
* v 1.0.0
* 
* (c) 2007 gotoAndPlay()
*
* 	SQL code used for creating the test db table:
*
*	CREATE TABLE retrocomputers (
*		ID INT AUTO_INCREMENT PRIMARY KEY, 
*		BRAND VARCHAR(120), 
*		MODEL VARCHAR(200), 
*		CPU VARCHAR(100), 
*		RAM VARCHAR(50)
*	)
*  
*/

// a global variable
var dbase

/* 
* Initializion point:
* 
* this function is called as soon as the extension
* is loaded in the server.
* 
* You can add here all the initialization code
* 
*/
function init()
{
	trace("Initing dbExtension")

	// get a reference to the database manager object
	// This will let you interact the database configure for this zone
	dbase = _server.getDatabaseManager()

}


/*
* This method is called by the server when an extension
* is being removed / destroyed.
* 
* Always make sure to release resources like setInterval(s)
* open files etc in this method.
* 
* In this case we delete the reference to the databaseManager
*/
function destroy()
{
	// Release the reference to the dbase manager
	delete dbase
}



/*
* 
* Handle Client Requests
* 
* cmd 		= a string with the client command to execute 
* params 	= list of parameters expected from the client
* user 		= the User object representing the sender
* fromRoom 	= the id of the room where the request was generated
* 
*/
function handleRequest(cmd, params, user, fromRoom)
{
	if (cmd == "getList")
	{
		sendComputerList(user)
	}
}

function sendComputerList(user)
{
	var sql = "SELECT * FROM retrocomputers ORDER BY BRAND"		
		
	// execute query on DB
	// queryRes is a ResultSet object
	var queryRes = dbase.executeQuery(sql)
	
	if (queryRes != null)
	{
		var response = {}
		response._cmd = "getList"
		
		/*
		* Here's the new SmartFoxServer 1.6 framework update:
		* You can pass the query ResultSet DIRECTLY to the send response
		* which will serialize the record set behind the scenes!
		*/
		response.list = queryRes
		
		_server.sendResponse(response, -1, null, [user])
	}
}


/*
* This method handles internal events
* Internal events are dispactched by the Zone or Room where the extension is attached to
* 
* the (evt) object
*/
function handleInternalEvent(evt)
{
	// Code for handling events goes here...
}
		
