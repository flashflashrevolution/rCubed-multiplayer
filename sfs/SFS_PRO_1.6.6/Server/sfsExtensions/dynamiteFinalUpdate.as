//******************** declare  variables *****************************
var tiles;
var numPlayers;
var depth;
var gameStarted = false;
var map;
//Find room to reply to
var room = {};
//create an array with all users 
var users = [];
// empty tiles on boards
var empty_x = new Array();
var empty_y = new Array();
// wooden tiles on board
var wood_x = new Array();
var wood_y = new Array();
// tile which are walls
var wall_x = new Array();
var wall_y = new Array();
// tiles which are bombs
var bombsTile = new Array();
var bombs_x = new Array();
var bombs_y = new Array();
// stores current bomb
var bombId;
// tiles which are bombs to collect
var bombDropTile = new Array();
var bombDrop_x = new Array();
var bombDrop_y = new Array();
//used and cleared when deciding outcome of explosion
//Array of wood to destroy
var remove = new Array();
//Array of movieclips to display fire
var fire = new Array();
//Array of player who are killed
var deaths = new Array();
// properties of board, used to derive x and y coordinates on board
var w = 20;
var h = 10;
var xPos = 275;
var yPos = 160;
// setup array to store attributes of players
playerName = new Array();
player_x = new Array();
player_y = new Array();
playerTile = new Array();
playerBombs = new Array();
// stores which move is being made
var currentMove = 1;
// *****************function called when extension is loaded *************
function init() {
	// Using trace will send data to the server console
	trace("Loading bomberman extension");
}
//******************** function called when extension is destroyed **********
function destroy() {
	trace("Bye bye!");
}
//******************* function to handle requests from  clients **********
function handleRequest(cmd, params, user, fromRoom, protocol) {
	//Find room to reply to
	room = _server.getCurrentRoom();
	//create an array with all users 
	users = room.getAllUsers();
	// handles request to postion players
	if (cmd == "positionPlayers") {
		positionPlayers();
	}
	// if the request is to move a player
	if (cmd == "sm") {
		movePlayer(params, user);
	}
}
//******************** functions used to setup game initially ************
// function to choose and send map
function chooseMap() {
	// if the game has not started
	if (!gameStarted) {
		// set game started flag to true
		gameStarted = true;
		//Generate a random number from 1-10
		map = Math.round((Math.random()*10));
		map = 1;
	}
	//Open text file storing map
	var textFile = _server.readFile("sfsExtensions/data/"+map+".txt");
	// declare resonse as an object
	var response = {};
	response._cmd = "provideMap";
	response.values = textFile;
	//Send object to all users in room
	_server.sendResponse(response, -1, null, users);
	// produce map in the form of 2 dimentioal array
	var rows = [];
	// formulate text file into arrays
	depth = Math.sqrt(textFile.length);
	for (x=0; x<depth; x++) {
		rows[x] = [];
		for (y=0; y<depth; y++) {
			position = (x*depth)+y;
			rows[x][y] = textFile.substr(position, 1);
		}
	}
	// used to  create array to store free spaces in map
	//declare variables
	tiles = rows[0].length*rows.length;
	var n = 0;
	// for each item in rows array
	for (var x = 0; x<rows.length; x++) {
		// for each item in particular row
		for (var y = 0; y<rows[x].length; y++) {
			n++;
			//if item is not a obstacle
			if (rows[x][y] == 0) {
				// fill array with positions of empty tiles
				empty_x[n] = (xPos+(y-x)*w/2);
				empty_y[n] = (yPos+(x+y)*h/2);
			}
			if (rows[x][y] == 1) {
				// fill array with positions of empty tiles
				wall_x[n] = (xPos+(y-x)*w/2);
				wall_y[n] = (yPos+(x+y)*h/2);
			}
			if (rows[x][y] == 2) {
				// fill array with positions of wooden tiles
				wood_x[n] = (xPos+(y-x)*w/2);
				wood_y[n] = (yPos+(x+y)*h/2);
			}
		}
	}
}
// function to position players
function positionPlayers() {
	// declare reponse as an object
	var response = {};
	response._cmd = "positionPlayers";
	response.playerName = [];
	response.player_x = [];
	response.player_y = [];
	response.playerTile = [];
	response.bombs = 5;
	// for each user in the room
	for (c=0; c<users.length; c++) {
		// variable storing whether a suitable tile has been generated
		var found = false;
		// while an free space has not been found
		while (found == false) {
			// variable storing whether another player is occuping a tile
			var occupied = false;
			//generate a random tile
			var randomTile = Math.round((Math.random()*(tiles+1)));
			// check if any player is occuping the tile
			for (x=1; x<(users.length+1); x++) {
				if (playerTile[x] == randomTile) {
					occupied = true;
				}
			}
			//if the tile is empty and a player is not on it
			if (empty_x[randomTile] && occupied == false) {
				// set players position in array
				playerName[c+1] = users[c].getName();
				player_x[c+1] = empty_x[randomTile];
				player_y[c+1] = empty_y[randomTile];
				playerTile[c+1] = randomTile;
				response.playerTile[c] = playerTile[c+1];
				response.playerName[c] = playerName[c+1];
				response.player_x[c] = player_x[c+1];
				response.player_y[c] = player_y[c+1];
				found = true;
			}
		}
		// set number of bombs user has
		playerBombs[c+1] = response.bombs;
	}
	//Send response to all users
	_server.sendResponse(response, -1, null, users);
	// call function to start dropping bombs
	dropBombInterval = setInterval("bombDrop", 20000);
}
//******************* functions controlling bombs **********************
// function to position bombs dropped
function bombDrop() {
	trace("dropping bomb interval");
	// variable storing whether a suitable tile has been generated
	var found = false;
	// while an free space has not been found
	while (found == false) {
		var occupied = false;
		//generate a random tile
		var randomTile = Math.round((Math.random()*(tiles+1)));
		// check if any player is occuping the tile
		for (x=1; x<(users.length+1); x++) {
			if (playerTile[x] == randomTile) {
				occupied = true;
			}
		}
		// check if any icon is occupying the square
		for (x=0; x<(bombDropTile.length+1); x++) {
			if (bombDropTile[x] == randomTile) {
				occupied = true;
			}
		}
		// check if any icon is occupying the square
		for (x=0; x<(bombsTile.length+1); x++) {
			if (bombsTile[x] == randomTile) {
				occupied = true;
			}
		}
		//if the tile is empty and a player is not on it
		if (empty_x[randomTile] && occupied == false) {
			// set players position in array
			bombDropTile.push(randomTile);
			bombDrop_x.push(empty_x[randomTile]);
			bombDrop_y.push(empty_y[randomTile]);
			var response = [];
			response[0] = "db";
			response.push(randomTile);
			response.push(empty_x[randomTile]);
			response.push(empty_y[randomTile]);
			response.push(randomTile*depth-5);
			//Send outcome of the move to all users in room
			_server.sendResponse(response, -1, null, users, "str");
			var found = true;
		}
	}
}
// function deal with countdown on bombs
function bombCountdown(bombId) {
	// set interval to call detonate function every 5 seconds
	this["interval"+bombId] = setInterval("detonate", 5000, bombId);
}
// function to deal with detonation of bomb
function detonate(bombId) {
	trace("detonate Interval");
	// stop the timer
	clearInterval(this["interval"+bombId]);
	// declare arrays to send to user
	//clear array
	remove = [];
	//clear array
	fire = [];
	//clear array
	deaths = [];
	// find attributes of bomb
	detonate_x = bombs_x[bombId];
	detonate_y = bombs_y[bombId];
	detonateTile = bombsTile[bombId];
	// remove attraibutes from array
	bombs_x[bombId] = "";
	bombs_y[bombId] = "";
	bombsTile[bombId] = "";
	//enter the tile where the bomb was into the empty space array
	empty_x[detonateTile] = detonate_x;
	empty_y[detonateTile] = detonate_y;
	// produce the tiles where the bomb is
	detonateOutcome(detonateTile);
	// produce the tiles below the bomb
	detonateTile1 = detonateTile+1;
	detonateTile2 = detonateTile+2;
	detonateOutcome(detonateTile1, detonateTile2);
	// produce the tiles above the bomb
	detonateTile1 = detonateTile-1;
	detonateTile2 = detonateTile-2;
	detonateOutcome(detonateTile1, detonateTile2);
	// produce the tiles left the bomb
	detonateTile1 = detonateTile+depth;
	detonateTile2 = detonateTile+(depth*2);
	detonateOutcome(detonateTile1, detonateTile2);
	// produce the tiles left the bomb
	detonateTile1 = detonateTile-depth;
	detonateTile2 = detonateTile-(depth*2);
	detonateOutcome(detonateTile1, detonateTile2);
	// remove the bomb fron the array
	// formulate results into response to users
	var response = [];
	response[0] = "d";
	response.push(bombId);
	response.push("r");
	for (c=0; c<remove.length; c++) {
		response.push(remove[c]);
	}
	response.push("f");
	for (c=0; c<fire.length; c++) {
		// send x and y coordinates
		response.push(fire[c]);
		response.push(empty_x[fire[c]]);
		response.push(empty_y[fire[c]]);
	}
	response.push("d");
	for (c=0; c<deaths.length; c++) {
		response.push(deaths[c]);
	}
	_server.sendResponse(response, -1, null, users, "str");
}
// function to calculate outcome of detonation
function detonateOutcome(detonateTile1, detonateTile2) {
	//Iftile is not a wall
	if (!wall_x[detonateTile1]) {
		//If the tile is wood
		if (wood_x[detonateTile1] && wood_x[detonateTile1] != "") {
			//Add the tile to the empty space array
			empty_x[detonateTile1] = wood_x[detonateTile1];
			empty_y[detonateTile1] = wood_y[detonateTile1];
			//Remove the tile from the wood array
			wood_x[detonateTile1] = "";
			wood_y[detonateTile1] = "";
			//Add the tile to the movieclips to destroy array
			remove.push(detonateTile1);
			//Add the tile to the fire array
			fire.push(detonateTile1);
		} else {
			//If the  tile is a player
			for (c=0; c<playerTile.length; c++) {
				if (playerTile[c] == detonateTile1) {
					//Change the player server variables
					playerTile[c] = "";
					player_x[c] = "";
					player_y[c] = "";
					//Add the player to the dead array
					deaths.push(c);
					// call the fuction to decide whether there is a winner
					gameDecision();
				}
			}
			// add the tile to the fire array
			fire.push(detonateTile1);
			// if both tiles have been sent to the function
			if (detonateTile2) {
				//call the function again only using the second tile
				detonateOutcome(detonateTile2);
			}
		}
	}
}
//********************* functions to deal with movement of players *******
// function to control players movement requests
function movePlayer(params, user) {
	// key that was pressed
	var key = params[0];
	// the user that made the rquest
	var user = user.getName();
	// variable used to control whether to inform players
	var moved = false;
	// variable storing whether the space is occupied
	var occupied = false;
	// find the attributes of the player that made the move		
	for (c=0; c<playerName.length; c++) {
		if (user == playerName[c]) {
			//player id
			var pIndex = c;
			//player name
			var pName = playerName[c];
			var pTile = playerTile[c];
		}
	}
	// if a bomb has been set
	if (key == 32) {
		// store co-ordinates of bomb
		bombsTile.push(playerTile[pIndex]);
		bombs_x.push(player_x[pIndex]);
		bombs_y.push(player_y[pIndex]);
		// set up array to send to user
		var response = [];
		response[0] = "b";
		response.push(pIndex);
		response.push(player_x[pIndex]);
		response.push(player_y[pIndex]);
		response.push((playerTile[pIndex]*depth-1)-10);
		// variable to identify specfic bomb
		bombId = bombs_x.length-1;
		response.push(bombId);
		//Send object to all users in room
		_server.sendResponse(response, -1, null, users, "str");
		// call function to coundown detonation of bomb
		bombCountdown(bombId);
		// reduce the number of bombs the user has  by 1
		playerBombs[pIndex]--;
		tile = playerTile[pIndex];
		//remove empty spaces so players cannot move over bombs
		empty_x[tile] = "";
		empty_y[tile] = "";
	}
	//assign key value dependent on which key was pressed
	var keyValue;
	if (key == 37) {
		keyValue = depth;
	}
	if (key == 38) {
		keyValue = -1;
	}
	if (key == 39) {
		keyValue = -depth;
	}
	if (key == 40) {
		keyValue = 1;
	}
	//********** Compute final tile which player can move to in that direction ********************
	// variable to store the number of moves the player can make
	var moves = 0;
	// variable to store which tile is being examined
	var keyTile = keyValue;
	// while the player can move 
	while (empty_x[pTile+keyTile] && empty_x[pTile+keyTile] != "") {
		keyTile = keyTile+keyValue;
		// increment the number of moves
		moves++;
	}
	//object to store properties of final position the player can move to
	var finish = {};
	// variable to store the properties of the final and start position of the tile the player can move to in that direction
	// the player
	finish.player = pIndex;
	//the tile
	finish.tile = pTile+keyTile-keyValue;
	//x and y coordinates
	finish._x = empty_x[pTile+keyTile-keyValue];
	finish._y = empty_y[pTile+keyTile-keyValue];
	// the increment value
	finish.increment = keyValue;
	// number of moves
	finish.moves = moves;
	// start position of player
	finish.startTile = pTile;
	finish.start_x = player_x[pIndex];
	finish.start_y = player_y[pIndex];
	// determine whether there is another player in the first position to move to
	//If player can move
	move = true;
	// if there is a player in the position
	for (c=0; c<playerTile.length; c++) {
		if ((playerTile[finish.player]+finish.increment) == playerTile[c]) {
			move = false;
		}
	}
	if (keyTile != keyValue && move) {
		//clear any previous interval for the player
		if (this["intUpdatePosition"+finish.player]) {
			clearInterval(this["intUpdatePosition"+finish.player]);
		}
		//variable to store whehter the space is occupied
		var occupied = false;
		// if there is a player in the position
		for (c=0; c<playerTile.length; c++) {
			if ((playerTile[pIndex]+keyValue) == playerTile[c]) {
				occupied = true;
			}
		}
		//if another player doesn’t occupy the space.
		if (!occupied) {
			// repose of furthest point user can move
			var response = [];
			response[0] = "sm";
			response.push(finish.player);
			response.push(finish._x);
			response.push(finish._y);
			response.push(finish.start_x);
			response.push(finish.start_y);
			response.push(finish.startTile);
			response.push(finish.moves);
			response.push(finish.increment);
			//Send outcome of the move to all users in room
			_server.sendResponse(response, -1, null, users, "str");
			// variable to store the current move being taken
			finish.currentMove = 1;
			updatePosition(finish);
			//Call function to check and update players position
			this["intUpdatePosition"+finish.player] = setInterval("updatePosition", 400, finish);
		}
	}
}
// function to update and check players position
function updatePosition(finish) {
	trace("update position Interval");
	// if the player has made less moves than can be made
	if (finish.currentMove<=finish.moves) {
		//variable to store whrther player can make move
		var move = false;
		//check if the tile is empty
		if (empty_x[(playerTile[finish.player]+finish.increment)] && empty_x[(playerTile[finish.player]+finish.increment)] != "") {
			move = true;
			// if there is a player in the position
			for (c=0; c<playerTile.length; c++) {
				if ((playerTile[finish.player]+finish.increment) == playerTile[c]) {
					move = false;
				}
			}
		}
		//if another player doesn’t occupy the space.
		if (move) {
			//Update players position  variables
			playerTile[finish.player] = playerTile[finish.player]+finish.increment;
			player_x[finish.player] = empty_x[playerTile[finish.player]];
			player_y[finish.player] = empty_y[playerTile[finish.player]];
			// find if the player picked up a bomb
			for (c=0; c<bombDropTile.length; c++) {
				if (bombDropTile[c] == playerTile[finish.player] && playerBombs[finish.player]<5) {
					//remove information from array item
					bombDropTile[c] = "";
					bombDrop_x[c] = "";
					bombDrop_y[c] = "";
					// increment the number of bombs the player has
					playerBombs[finish.player]++;
					//formulate response to users
					var response = [];
					response[0] = "pb";
					// the player that picked it up
					response.push(finish.player);
					//the bomb that was picked up
					response.push(c);
					//Send outcome of the bomb being picked up to all users
					_server.sendResponse(response, -1, null, users, "str");
				}
			}
		} else {
			// stop updating postion
			// clear interval to stop updating position
			if (this["intUpdatePosition"+finish.player]) {
				clearInterval(this["intUpdatePosition"+finish.player]);
			}
			// send reponse to user with final position
			var response = [];
			response[0] = "fm";
			response.push(finish.player);
			response.push(playerTile[finish.player]);
			response.push(player_x[finish.player]);
			response.push(player_y[finish.player]);
			//Send outcome of the move to all users in room
			_server.sendResponse(response, -1, null, users, "str");
		}
	} else {
		//clear the interval	
		clearInterval(this["intUpdatePosition"+finish.player]);
	}
	// incrementthe current move by 1
	finish.currentMove++;
}
// *********** functions to deal with administration of game ***********
// function to descide whether the game has been won
function gameDecision() {
	var players = 0;
	for (c=0; c<playerTile.length; c++) {
		if (playerTile[c] && playerTile[c]>0) {
			players++;
		}
	}
	// if there are less than 2 players remaining
	if (players == 1) {
		gameOver();
	}
}
//function to deal with the number of players changing
function playersChange(maxPlayers) {
	room = _server.getCurrentRoom();
	var gameStart = gameStarted;
	// declare response as an object
	var response = {};
	response._cmd = "playerChange";
	response.numPlayers = numPlayers;
	response.maxPlayers = maxPlayers;
	response.gameStart = gameStart;
	//Send object to all users in room
	_server.sendResponse(response, -1, null, users);
}
function gameOver() {
	for (c=0; c<playerTile.length; c++) {
		if (playerTile[c] && playerTile[c]>0) {
			var winner = c;
		}
	}
	//stop dropping bombs
	clearInterval(dropBombInterval);
	// the game has finished
	response = {};
	response._cmd = "gameOver";
	response.playerId = winner;
	response.playerName = playerName[winner];
	// send response to all users to stop the game
	_server.sendResponse(response, -1, null, users);
}
//***************functions to deal with internal events ****************
function handleInternalEvent(evt) {
	//Find room to reply to
	room = _server.getCurrentRoom();
	//create an array with all users 
	users = room.getAllUsers();
	evtName = evt.name;
	// Handle a user joining the room
	if (evtName == "userJoin") {
		maxPlayers = room.getMaxUsers();
		//find the number of players in the room
		numPlayers = room.getUserCount();
		// if the correct number of players are present
		// call function to deal with the number of players changing
		playersChange(maxPlayers);
		if (maxPlayers == numPlayers && !gameStarted) {
			// call the function to choose and send the map
			chooseMap();
		}
	}
	// handle a user leaving the room
	if (evtName == "userExit" || evtName == "userLost") {
		numPlayers = room.getUserCount();
		maxPlayers = room.getMaxUsers();
		playerLeftId = evt.oldPlayerIndex;
		if (gameStarted) {
			// reduce number of players by if user is lost
			if (evtName == "userLost") {
				numPlayers--;
			}
			if (numPlayers == 1) {
				// remove the player who has left variable
				playerTile[playerLeftId] = "";
				// call function to deal with the game finishing
				gameOver();
			} else {
				playerName[playerLeftId] = "";
				player_x[playerLeftId] = "";
				player_y[playerLeftId] = "";
				playerTile[playerLeftId] = "";
				var res = {};
				res._cmd = "refresh";
				res.playerId = evt.oldPlayerIndex;
				// send response to all users to stop the game
				_server.sendResponse(res, -1, null, users);
			}
		} else {
			// call function to deal with the number of players changing
			playersChange(maxPlayers);
		}
	}
}
