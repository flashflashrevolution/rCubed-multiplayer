#
# MazeGame v 1.0.0
# {Server side version}
# Python version
#
# SmartFoxServer PRO example file
# 
# (c) 2005 - 2006 gotoAndPlay()
#

# number of players in the room
numPlayers = 0

# associative array of users in the room
users = {}

# flag that handles if the game is started
gameStarted = False

# id of the current room
currentRoomId = -1

# id of Player1
p1id = -1

# id of Player 2
p2id = -1

# Extension initialization
def init():
	pass
	

# Extension destroy
def destroy():
	pass

	
# Handle client request
def handleRequest(cmd, params, user, fromRoom, protocol):
	if protocol == "str":
		if cmd == "mv":
			handleMove(params, user)


# Handle server event
def handleInternalEvent(evt):
	global currentRoomId, numPlayers, p1id, p2id, gameStarted
	
	evtName = evt.getEventName()
	
	# Handle a user joining the room
	if evtName == "userJoin":
		# get the id of the current room
		if currentRoomId == -1:
			currentRoomId = evt.getObject("room").getId()
		
		# Get the user object
		u = evt.getObject("user")

		# add this user to our list of local users in this game room
		# We use the userId number as the key
		users[u.getUserId()] = u
		
		# Increase the number of players
		numPlayers += 1
		
		if u.getPlayerIndex() == 1:
			p1id = u.getUserId()
		else:
			p2id = u.getUserId()
		
		# If we have two players and the game was not started yet
		# it's time to start it now!
		if numPlayers == 2 and gameStarted == False:
			startGame()

	
	# Handle a user leaving the room or a user disconnection
	elif evtName == "userExit" or evtName == "userLost":
		# get the user id
		uId = int(evt.getParam("uid"))
		
		# get the playerId of the user that left the room
		if evtName == "userExit":
			oldPid = int(evt.getParam("oldPlayerIndex"))
		
		# get the playerId of the user that disconnected
		elif evtName == "userLost":
			pids = evt.getObject("playerIndexes")
			oldPid = pids[0]
		
		u = users[uId]
		
		# let's remove the player from the list
		del users[uId]
		
		numPlayers -= 1
		
		# game stops
		gameStarted = False
		
		# if one player is still in the room let's update him
		if numPlayers > 0:
			res = {}
			res["_cmd"] = "stop"
			res["n"] = u.getName()
			
			_server.sendResponse(res, currentRoomId, None, users.values())


# Game starts: send a message to both players
def startGame():
	global gameStarted
	gameStarted = True
	
	res = {}
	res["_cmd"] = "start"
	res["p1"] = {"id":p1id, "name":users[p1id].getName(), "x":1, "y":1}
	res["p2"] = {"id":p2id, "name":users[p2id].getName(), "x":22, "y":10}
	
	_server.sendResponse(res, currentRoomId, None, users.values())
	

# Handle the player move and broadcast it to the other player
def handleMove(params, user):
	if gameStarted:
		res = []
		res.append("mv")
		res.append(params[0])
		res.append(params[1])
		
		uid = user.getUserId()
		
		if uid == p1id:
			recipient = users[p2id]
		else:
			recipient = users[p1id]
		
		_server.sendResponse(res, currentRoomId, user, [recipient], _server.PROTOCOL_STR)
		
		 