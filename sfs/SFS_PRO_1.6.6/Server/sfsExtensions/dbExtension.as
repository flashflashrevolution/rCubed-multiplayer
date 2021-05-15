/*
* SmartFoxServer PRO
* Simple database extension
* v 1.0.0
* 
* (c) 2005 gotoAndPlay()
*
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
	if (cmd == "getData")
	{
		var t1 = getTimer()
		
		// create a SQL statement
		var sql = "SELECT * FROM contacts ORDER BY name"		
		
		// execute query on DB
		// queryRes is a ResultSet object
		var queryRes = dbase.executeQuery(sql)
		
		// Show the time it took to parse the request
		var t2 = getTimer()
		
		trace("DB Request took: " + (t2-t1) + " ms.")
		
		// prepare the response object
		var response = {}
		
		// _cmd property is the name of the response command
		// This is the only mandatory property you should always add
		// to a response object
		response._cmd = "getData"
		
		// Here we create an array for storing the database data
		response.db = []
		
		// queryRes is ResultSet object
		// Methods available:
		// 
		// size() 	the number of records contained
		// get(n)	get the nth record in the RecordSet
		//
		// Example:
		// var record = queryRes.get(0)
		//
		// Gets the first record in the RecordSet
		//
		if (queryRes != null)
		{
			// Cycle through all records in the ResultSet
			for (var i = 0; i < queryRes.size(); i++)
			{
				// Get a record
				var tempRow = queryRes.get(i)
				
				// This object will hold the record data that we'll send to the client
				var item = {}

				// From the record object we can get each field value
				item.name 	= tempRow.getItem("name")
				item.location 	= tempRow.getItem("location")
				item.email 	= tempRow.getItem("email")

				response.db.push( item )
			}
		}
		else
			trace("DB Query failed")
		
		/*
		* 
		* Send response back to client
		* 
		* sendResponse(response, fromRoom, sender, recipients, type)
		* 
		* response = an object with the _cmd property specifying the name of the response command
		* fromRoom = the id of the room where the response comes from (-1 if not needed)
		* sender   = the user sending the response (null if not needed)
		* recipients = a list of user that should receive the reponse
		* type = can be "xml" or "str". It represent the message format
		* 
		*/

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
	// Simply print the name of the event that was received
	trace("Event received: " + evt.name)	
}


