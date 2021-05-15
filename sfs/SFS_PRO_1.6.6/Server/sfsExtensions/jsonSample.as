/**
	JSON protocol example
	version 1.0.0
	
	JSON works exactly as XML does, serializing and deserializing objects transparently
	between client-server and viceversa.
	The big advantage is that JSON uses a lot less bandwidth and it's the recommended choice instead of XML
*/

var retro_8bit = null
var retro_16bit = null

function init()
{
	// Using trace will send data to the server console
	trace("JSON Example initialized")
	
	// 8 bit retro computer list
	retro_8bit = 	[
						{brand:"Commodore", model:"VIC 20", cpu:"MOS 6502", ram:"5Kb"},
						{brand:"Commodore", model:"C64", cpu:"MOS 6510", ram:"64Kb"},
						{brand:"Philips", model:"MSX2", cpu:"Z80", ram:"128Kb ram, 128kb video"},
					]
	
	// 16 bit retro computer list
	retro_16bit = 	[
						{brand:"Commodore", model:"Amiga 500", cpu:"Motorola 68000", ram:"512Kb"},
						{brand:"Atari", model:"ST", cpu:"Motorola 68000", ram:"512Kb"},
						{brand:"Apple", model:"Macintosh 128K", cpu:"Motorola 68000", ram:"128Kb"},
					]
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
	trace("JSON example destroyed")
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
function handleRequest(cmd, params, user, fromRoom, proto)
{
	/**
		You can use the following 3 constants for the 3 available protocols:
		
		_server.PROTOCOL_XML
		_server.PROTOCOL_STR
		_server.PROTOCOL_JSON
		
	**/
	if (proto == _server.PROTOCOL_JSON)
	{
		if (cmd == "getComps")
		{
			var compList = null
			
			if (params.cpuType == 8)
				compList = retro_8bit
			else
				compList = retro_16bit

			res = {}
			res._cmd = "getComps"
			res.compList = compList
			
			_server.sendResponse(res, fromRoom, user, [user], _server.PROTOCOL_JSON)
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
		//
}


