/**
* SmartFoxTris v 1.0.0
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

var whoseTurn			// keep track of the current turn
var board			// a 2D array containing the board game data
var numPlayers			// count the number of players currently inside
var users = []			// an array of users
var gameStarted			// boolean, true if the game has started
var currentRoomId		// the Id of the room where the extension is running
var p1id			// userId of player1
var p2id			// userId of player2
var moveCount			// count the number of moves
var endGameResponse		// save the final result of the game


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
* Initialize the game board as a 2D array
* 
* We use 1 as the starting index istead of 0, so the array has an undefined value in pos 0
*/
function initGameBoard()
{
	board = []
	
	for (var i = 1; i <=3; i++)
		board[i] = [,".",".","."]
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
	
	initGameBoard()
	
	moveCount = 0
	endGameResponse = null
	
	if(whoseTurn == undefined)
		whoseTurn = 1
	
	var res = {}
	res._cmd = "start"
	res.t = whoseTurn
	res.p1n = users[p1id].getName()
	res.p1i = p1id
	res.p2n = users[p2id].getName()
	res.p2i = p2id
	
	_server.sendResponse(res, currentRoomId, null, users)
}



/*
* Handles the client request
* 
* cmd 		contains the request name
* params 	is an object containing data sent by the client
* user 		is the User object of the sender
* fromRoom	the id of the room where the request was sent from
*/
function handleRequest(cmd, params, user, fromRoom)
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
		
		// Handle player entering game
		// Let's check if the player is not a spectator (playerIndex != -1)
		if (u.getPlayerIndex() != -1)
		{
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
		else
		{
		
			// If a spectator enters the room 
			// we have to update him sending the current board status
			updateSpectator(u)
			
			if (endGameResponse != null)
				_server.sendResponse(endGameResponse, currentRoomId, null, [u])
		}
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
		
		// If the user we have lost was playing
		// we stop the game and tell everyone
		if (oldPid > 0)
		{
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
	
	// Handle a spectator switching to a player
	else if (evtName == "spectatorSwitched")
	{
		if (!gameStarted && evt["playerIndex"] > 0)
		{
			numPlayers++
			
			// Update the playerId
			this["p" + evt["playerIndex"] + "id"] = evt["user"].getUserId()
			
			// If we now have 2 players the game should be started
			if(numPlayers == 2)
				startGame()
		}
	}
}



/*
* Here we update the spectator that has entered the game
* after it was started. 
* We send him the current board status and the player names and ids
*/
function updateSpectator(user)
{
	var res = {}
	
	res._cmd = "specStatus"
	res.t = whoseTurn
	res.status = gameStarted
	res.board = board
	
	if (users[p1id] != undefined)
	{
		res.p1n = users[p1id].getName()
		res.p1i = p1id
	}
	else
		res.p1n = " "
		
	if (users[p2id] != undefined)
	{
		res.p2n = users[p2id].getName()
		res.p2i = p2id
	}
	else
		res.p2n = " "
	
	_server.sendResponse(res, currentRoomId, null, [user])
}



/*
* This method handles a move sent by the client
* 
* The move is validated before accepting it, then it is broadcasted
* back to all clients
*/
function handleMove(prms, u)
{
	if (gameStarted)
	{
		if (whoseTurn == u.getPlayerIndex())
		{
			var px = prms.x
			var py = prms.y
			
			if (board[py][px] == ".")
			{
				board[py][px] = String(u.getPlayerIndex())
				
				whoseTurn = (whoseTurn == 1) ? 2 : 1
				
				var o = {}
				o._cmd = "move"
				o.x = px
				o.y = py
				o.t = u.getPlayerIndex()
				
				_server.sendResponse(o, currentRoomId, null, users)
				
				moveCount++
				
				checkBoard()
			}
		}
	}
}


//----------------------------------------------------------
// This function checks if someone is winning!
// 
// It checks all three horizontal lines, all three vertical
// lines and the two diagonals.
// If no one wins and all board tiles are taken then it's
// a tie!
//
// The function is called after every player move.
//----------------------------------------------------------
function checkBoard()
{
	var solution = []
	
	// All Rows
	for (var i = 1; i < 4; i++)
	{
		solution.push(board[i][1] + board[i][2] + board[i][3])
	}
	
	// All Columns
	for (var i = 1; i < 4; i++)
	{
		solution.push(board[1][i] + board[2][i] + board[3][i])
	}
	
	// Diagonals
	solution.push(board[1][1] + board[2][2] + board[3][3])
	solution.push(board[1][3] + board[2][2] + board[3][1])
	
	
	var winner = null
	
	while(solution.length > 0)
	{
		var st = solution.pop()
		
		if (st == "111")
		{
			winner = 1
			break
		}
		else if (st == "222")
		{
			winner = 2
			break
		}
	}
	
	var response = {}
	
	// TIE !!!
	if (winner == null && moveCount == 9)
	{
		gameStarted = false
		
		response._cmd = "tie"
		_server.sendResponse(response, currentRoomId, null, users)
		
		endGameResponse = response
	}
	else if (winner != null)
	{
		// There is a winner !
		gameStarted = false
		
		response._cmd = "win"
		response.w = winner
		_server.sendResponse(response, currentRoomId, null, users)
		
		endGameResponse = response
	}
}
