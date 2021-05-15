/**
* 
* SmartMessenger v. 1.0.0
* ServerSide extension

* Instant Messagges with SmartFoxServer - Example app -
*
* @author Lapo - Marco Lapi
* @version 1.0.0
* 
* (c) 2005-2006 gotoAndPlay()
* www.smartfoxserver.com
* www.gotoandplay.it
* 
*/

var zone
var userData
var limboRoom

/**
* Initialize the rooms
*/
function init()
{
	zone = _server.getCurrentZone()
	limboRoom = zone.getRoomByName("Main")
	
	userData = []
	initUserData()
}

function destroy()
{
	// Nothing to destroy
}

/**
* Dispatchs client requests
* 
* @param	cmd			command name
* @param	params		call params
* @param	user		the invoker
* @param	fromRoom	room id
* @param	proto		protocol type
*/
function handleRequest(cmd, params, user, fromRoom, proto)
{
	if (proto == "xml")
	{
		if (cmd == "nextU")
		{
			handleNextUser(user, params, fromRoom)
		}
		else if (cmd == "prevU")
		{
			handlePrevUser(user, params, fromRoom)
		}
	}
	else if (proto == "str")
	{
		if (cmd == "stat")
		{
			handleStatusChange(user, params, fromRoom)
		}
	}
}

/**
* Handle internal events
* 
* @param	e	the event object
*/
function handleInternalEvent(e)
{
	/*
	* If room creation will be enabled on the client side
	* we'll need to catch the creation of a room and attach
	* a list to it, in order to hold the drawing data
	*/
	
	var evtName = e.name
	
	if (evtName == "loginRequest")
	{
		var error = ""
		
		var nick = e["nick"]
		var pass = e["pass"]
		var chan = e["chan"]	
		
		var userOk = verifyUser(nick)
		var u;
		
		if (userOk != null)
		{
			var obj = _server.loginUser(nick, pass, chan)
			
			if (obj.success == false)
			{
				error = obj.error
			}
			else
			{
				u = _server.getUserByChannel(chan)
			}
			
		}
		else
		{
			error = "User not recognized"
		}
		
		// Send response to client
		var response = new Object()
		
		if (error == "")
		{
			response._cmd = "logOK"
			response.name = nick;
			response.id = u.getUserId();
		}
		else
		{
			response._cmd = "logKO"
			response.err = error		}
		
		/*
		* NOTE:
		* usually the 4th parameter of the sendResponse is a list of users object that will
		* receive this message.
		* 
		* Only when handling a login request you can pass a channel instead of a list of Users
		*/
		
		_server.sendResponse(response, -1, null, chan)

	}

}

/**
* Check if a user is exist
*
* @param	nick	the nick name to check
* @return 	object	the user profile
*/
function verifyUser(nick)
{
	var res = null
	
	for (var i in userData)
	{
		if (userData[i].nick == nick)
		{
			res = userData[i]
			break
		}
	}
	
	return res;
}

/**
* Send the next user to the client
*
* @param	user		the request sender
* @param	params		req. parameters
* @param	fromRoom	the room id
*
*/
function handleNextUser(user, params, fromRoom)
{
	var item = null
	var id = params.id
	
	if (id < 0)
	{
		item = userData[0]
		id = 0;
	}
	else
	{
		id++
		
		if (id >= 0 && id < userData.length)
		{
			item = userData[id]
		}
	}
	
	if (item != null)
	{
		var response = {}
		response._cmd = "usr"
		response.usr = item
		response.id = id
		
		_server.sendResponse(response, -1, null, [user])
	}
}

/**
* Send the previous user to the client
*
* @param	user		the request sender
* @param	params		req. parameters
* @param	fromRoom	the room id
*
*/
function handlePrevUser(user, params, fromRoom)
{
	var item = null
	var id = params.id

	if (id <= 0)
	{
		item = userData[0]
		id = 0;
	}
	else
	{
		id--;
		
		if (id >= 0 && id < userData.length)
		{
			item = userData[id]
		}
	}
	
	if (item != null)
	{
		var response = {}
		response._cmd = "usr"
		response.usr = item
		response.id = id
		
		_server.sendResponse(response, -1, null, [user])
	}
}

/**
* Create some temporary data 
* In a real world application this data should come from a database
*/
function initUserData()
{
	userData.push( {nick:"jimi", age:20, location:"U.S.A", email:"jimi@mail.us", interest:"Rock Guitar"} )
	userData.push( {nick:"blaise", age:30, location:"France", email:"blaise@mail.fr", interest:"Math and Physiscs"} )
	userData.push( {nick:"wolfgang", age:17, location:"Germany", email:"wolf@mail.de", interest:"Orchestral Music"} )
	userData.push( {nick:"pablo", age:20, location:"Spain", email:"pablo@mail.sp", interest:"Painting"} )
	userData.push( {nick:"leonardo", age:20, location:"Italy", email:"leo@mail.it", interest:"Painting, architecture, science"} )
	userData.push( {nick:"dante", age:20, location:"Italy", email:"dante@mail.it", interest:"Literature"} )
	userData.push( {nick:"miles", age:20, location:"U.S.A.", email:"miles@mail.us", interest:"Jazz music, trumpet"} )
	userData.push( {nick:"agatha", age:20, location:"U.K.", email:"agatha@mail.co.uk", interest:"Mystery, thrillers"} )
}


