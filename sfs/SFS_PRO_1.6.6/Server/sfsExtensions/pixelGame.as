/**
 * 
 * PixelGame Tutorial
 * (advanced room management) 
 * 
 * (c) 2005 gotoAndPlay() 
 * www.gotoandplay.it
 * www.smartfoxserver.com
 *    
 */  
 
var zone
var roomCounter = 0

// Size of the grid
var gX = 30
var gY = 30

/**
* initialize all the available rooms by adding a "grid" to each one
* the grid is a bi-dimensional array where pixels are stored
*/
function init()
{
	zone = _server.getCurrentZone()
	trace("PixelGame extension started!")
	
	var rooms = zone.getRooms()
	
	for (var i in rooms)
	{
		createGrid(rooms[i])
	}
}

function destroy()
{
	//
}

function handleRequest(cmd, params, user, fromRoom, proto)
{
	if (proto == "str")
	{
		if (cmd == "jme")
		{
			lookForRoom(user)
		}
		else if (cmd == "grid")
		{
			sendStatus(user, fromRoom)
		}
		else if (cmd == "upd")
		{
			handleUpdate(params, fromRoom)
		}
	}
}

function handleInternalEvent(e)
{

	if (e.name == "loginRequest")
	{
		var newUser = null
		var error = ""
		
		var nick = e["nick"]
		var pass = e["pass"]
		var chan = e["chan"]

		if (nick == "")
			nick = getRandomName(12)

		var obj = _server.loginUser(nick, pass, chan)
		
		if (obj.success == false)
			error = obj.error
		
		// Send response to client
		var response = new Object()
		
		if (error == "")
		{
			newUser = _server.instance.getUserByChannel(chan)
			
			response._cmd = "logOK"
			response.id = newUser.getUserId()
			response.name = newUser.getName()
		}
		else
		{
			response._cmd = "logKO"
			response.err = error
		}
		
		_server.sendResponse(response, -1, null, chan)
	}
}

/**
* Handle a pixel change
* Sets the status of the pixel and broadcasts the change
* to all clients in the room
*
* The string protocol is used here.
* params[0] is the status of the pixel (0 = off, 1 = on)
* params[1] is the x position of the pixel in the grid
* params[2] is the y position of the pixel in the grid
*
*/
function handleUpdate(prms, rId)
{
	var room = zone.getRoom(rId)
	
	if (room != null)
	{
		var grid = room.properties.get("grid")
		
		var st = Number(prms[0])
		var px = Number(prms[1])
		var py = Number(prms[2])
		
		grid[py][px] = st
		
		var uList = room.getAllUsers()
		
		var res = []
		res[0] = "upd"
		res[1] = st
		res[2] = px
		res[3] = py
		
		_server.sendResponse(res, rId, null, uList, "str")
	}
}

/**
* Look for a room to join the user in
* If no rooms are available, it creates a new one and joins the user inside
*/
function lookForRoom(usr)
{
	var rooms = zone.getRooms()
	var found = false
	
	if (usr != null)
	{
		for (var i = 0; i < rooms.length; i++)
		{
			var rm = rooms[i]
			
			if (rm.howManyUsers() < rm.getMaxUsers())
			{
				_server.sendRoomList(usr)

				var j = _server.joinRoom(usr, -1, false, rm.getId(), "", false, true)
				
				if (!j)
					trace("Oops, user: " + usr.getName() + " couldn't join")

				found = true
				break
			}
		}
		
		if (!found)
		{
			var rName = "AutoRoom_" + roomCounter
			roomCounter++
			
			var r = makeNewRoom(rName, 4, usr)
			
			if (r != null)
			{
				_server.sendRoomList(usr)
				createGrid(r)
				var j = _server.joinRoom(usr, -1, false, r.getId(), "", false, true)
			}
			else
				trace("Failed creating room >> " + rName)

		}
	}
}

/**
* Creates a new room
*/
function makeNewRoom(rName, maxU, owner)
{
	var rObj 	= {}
	rObj.name 	= rName
	rObj.pwd 	= ""
	rObj.maxU	= maxU
	rObj.maxS 	= 0
	rObj.isGame	= false
	
	var r = _server.createRoom(rObj, owner, true)
	
	return r
}

/**
* Return a random low-case name with n characters
*/
function getRandomName(n)
{
	var res = ""
	var rnd
	
	for (var i = 0; i < n; i++)
	{
		rnd = Math.floor(Math.random() * 26)
		res += String.fromCharCode(97 + rnd)
	}
	
	return res
}

/**
* Creates an empty bi-dimensional array
* and attaches it to the room object passed.
*
* The array will be used to store the pixel board status
*/
function createGrid(room)
{
	var grid = new Array(gY)
	
	for (var y = 0; y < gY; y++)
	{
		if (grid[y] == undefined)
			grid[y] = []
			
		for (var x = 0; x < gX; x++)
		{
			grid[y][x] = 0
		}
	}
	
	// Save grid for room
	room.properties.put("grid", grid)
	
}

/**
* Sends the current pixel status to the client
* The grid of pixels is turned into a string where every
* character represents one pixel.
*/
function sendStatus(who, roomId)
{
	var currRoom = zone.getRoom(roomId)
	
	if (currRoom != null)
	{
		var grid = currRoom.properties.get("grid")
		var res = []
		var dataStr = ""
		res[0] = "grid"
		
		for (var y = 0; y < gY; y++)
		{
			for (var x = 0; x < gX; x++)
			{
				var o = grid[y][x]		
				dataStr += o.toString()
			}
		}
		
		res.push(dataStr)
		_server.sendResponse(res, roomId, who, [who], "str")
	}
	else
		trace("OUCH!! No room exist. Can't send status. ID = " + roomId)
}

