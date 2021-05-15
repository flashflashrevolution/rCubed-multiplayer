/**
* MazeGame v 1.0.0
* {Server side version}
* 
* SmartFoxServer PRO example file
* 
* (c) 2005 - gotoAndPlay()
* 
*/

/*
* Global variables declaration
*/

var numPlayers			// count the number of players currently inside
var users = []			// an array of users
var gameStarted			// boolean, true if the game has started
var currentRoomId		// the Id of the room where the extension is running
var p1id			// userId of player1
var p2id			// userId of player2



/*
* Entry Point
* This method is invoked by the Server when the extension is loaded
* 
* Put your initialization code here.
* 
* We set the number of player to = 0
* and the gameStarted flag to = false
*/
function init()
{
	numPlayers = 0
	gameStarted = false
}


/*
* Exit Point
* This method is invoked by the server when the extension is being destroyed.
* You should shutdown all your setIntervals etc... here.
*/
function destroy()
{
	// Nothing special to do here
}


/*
* This method starts the game.
* 
* we send a message to the current list of users telling that the game is
* started.
* We also send the name and id of the two players
* 
*/
function startGame()
{
	gameStarted = true
	
	var res = {}
	res._cmd = "start"
	
	res.p1 = {id:p1id, name:users[p1id].getName(), x:1, y:1}
	res.p2 = {id:p2id, name:users[p2id].getName(), x:22, y:10}
	
	_server.sendResponse(res, currentRoomId, null, users)
}



/*
* Handles the client request
* 
* cmd 		contains the request name
* params 	is an object containing data sent by the client
* user 		is the User object of the sender
* fromRoom	the id of the room where the request was sent from
* protocol	"xml" or "raw"
*/
function handleRequest(cmd, params, user, fromRoom, protocol)
{
	if (protocol == "xml")
	{
		switch (cmd)
		{
			case "move":
				handleMove(params, user)
			break
			
			case "restart":
				// If we have two players and the game was not started yet
				// it's time to start it now!
				if(numPlayers == 2 && !gameStarted)
					startGame()
			break
		}
	}
	else
	{
		switch(cmd)
		{
			case "mv":
				handleMove(params, user)
			break
			
				
		}
	}
}



/*
* This method handles a move sent by the client
* 
* The move is validated before accepting it, then it is broadcasted
* back to all clients
*/
function handleMove(params, user)
{
	if (gameStarted)
	{
		// Here we use a list of parameters instead of an object
		// for sending data to the client.
		//
		// It's not going to be possible to serialze complex nested
		// objects. The raw protocol accepts only strings.
		//
		// With this technique you can dramatically reduce the bandwidth
		// usage by a factor of at least 5 times up to 25 and even more!
		
		var res = []		// The list of params	
		res[0] = "mv"		// at index = 0, we store the command name
		res[1] = params[0]	// this is the X pos of the player
		res[2] = params[1]	// this is the Y pos of the player
		
		// Chose the recipient
		// We send this message only to the other client
		var uid = user.getUserId()
		var recipient = (uid == p1id) ? users[p2id]:users[p1id]
		
		// Send the raw message
		// _server.sendResponse() works just like any other requests
		// you have only to add the "str" argument to use the raw protocol
		_server.sendResponse(res, currentRoomId, null, [recipient], "str")
	}
}



/*
* Handles internal server events
* Events are received upon login requests, user Join, user Exit etc..
* 
* evt is the event object
* evt.getEventName() returns the name of the event
* 
* Each event sends a number of parameters (usually strings or numbers) and objects
* 
* You can get a parameter by using evt.getParam(paramName)
* You can get an object by using evt.getObject(objName)
* 
* the "userJoin" event sends these arguments:
* 
* zone (param)  .... name of the zone where the event occurred
* user (object) .... User object representing the user that joined
* 
* ----------------------------------------------------------------------------------------
* The User Object:
* 
* the User class represents a client logged in the server.
* Here are some of the methods you can call on these objects:
* 
* getName()		returns the name of the client
* getUserId()		returns the unique client ID
* getPlayerIndex()	returns the automatically assigned player index.
* 			Player index tells what player number is the selected client.
* 			if a playerIndex == -1, the client is a spectator, not a player.
* 
*/
function handleInternalEvent(evt)
{
	evtName = evt.name
	
	// Handle a user joining the room
	if (evtName == "userJoin")
	{
		// get the id of the current room
		if (currentRoomId == undefined)
			currentRoomId = evt["room"].getId()
		
		// Get the user object
		u = evt["user"]

		// add this user to our list of local users in this game room
		// We use the userId number as the key
		users[u.getUserId()] = u
		
		// Increase the number of players
		numPlayers++
		
		if (u.getPlayerIndex() == 1)
			p1id = u.getUserId()
		else
			p2id = u.getUserId()
		
		// If we have two players and the game was not started yet
		// it's time to start it now!
		if(numPlayers == 2 && !gameStarted)
			startGame()

	}
	
	// Handle a user leaving the room or a user disconnection
	else if (evtName == "userExit" || evtName == "userLost")
	{	
		// get the user id
		var uId = evt["userId"]
		
		// get the playerId of the user we have lost
		var oldPid = evt["oldPlayerIndex"]
		
		var u = users[uId]
		
		// Let's remove the player from the list
		delete users[uId]
		
		numPlayers--
		
		gameStarted = false
		
		if(numPlayers > 0)
		{
			var res = {}
			res._cmd = "stop"
			res.n = u.getName()
			_server.sendResponse(res, currentRoomId, null, users)
		}

	}
}






