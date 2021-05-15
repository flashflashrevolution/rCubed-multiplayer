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
	//--- Handle the "getData" request --------------------------------------------------------------
	if (cmd == "getData")
	{
		// create a SQL statement
		var sql = "SELECT * FROM contacts ORDER BY name"		
		
		// execute query on DB
		// queryRes is a ResultSet object
		var queryRes = dbase.executeQuery(sql)

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
				item.id 	= tempRow.getItem("id")
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
	
	//--- Handle and "update record" request -------------------------------------------------------
	else if (cmd == "updData")
	{
		// Create the SQL statement to update the record
		var sql = "UPDATE contacts SET "
		sql += " name='" + _server.escapeQuotes(params.name) + "',"
		sql += " location='" + _server.escapeQuotes(params.location) + "',"
		sql += " email='" + _server.escapeQuotes(params.email) + "'"
		sql += " WHERE id='" + params.id + "'"
		
		var success = dbase.executeCommand(sql)
		
		// If it was successfully updated send a response
		if (success)
		{
			var response 		= {}
			response._cmd		= "updData"
			response.id 		= params.id
			response.name 		= params.name
			response.location 	= params.location
			response.email 		= params.email
			
			_server.sendResponse(response, -1, null, [user])
		}
	}
	
	//--- Handle and "add record" request ----------------------------------------------------------
	else if (cmd == "addData")
	{
		var id = getTimer()
		
		// Create the SQL statement to update the record
		var sql = "INSERT INTO contacts (id, name, location, email) VALUES ("
		sql += "'" + id + "', "
		sql += "'" + _server.escapeQuotes(params.name) + "', "
		sql += "'" + _server.escapeQuotes(params.location) + "', "
		sql += "'" + _server.escapeQuotes(params.email) + "')"
		
		var success = dbase.executeCommand(sql)
		
		// If it was successfully updated send a response
		if (success)
		{
			var response 		= {}
			response._cmd		= "addData"
			response.id 		= id
			response.name 		= params.name
			response.location 	= params.location
			response.email 		= params.email
			
			_server.sendResponse(response, -1, null, [user])
		}
	}
	
	//--- Handle and "remove record" request -------------------------------------------------------
	else if (cmd == "delData")
	{
		var sql = "DELETE FROM contacts WHERE id='" + params.id + "'"
		
		var success = dbase.executeCommand(sql)
		
		// If it was successfully updated send a response
		if (success)
		{
			var response 		= {}
			response._cmd		= "delData"
			response.id 		= params.id
			
			_server.sendResponse(response, -1, null, [user])
		}
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
	//trace("Event received: " + evt.name)	
}


