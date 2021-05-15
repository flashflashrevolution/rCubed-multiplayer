/*
* SmartFoxServer PRO
* Test LoadVars
* v 1.1.0 beta
*
*/

function init()
{
	var _send = new LoadVars()
	var _load = new LoadVars()
	
	// Set parameters to send
	_send.name 		= "Albert"
	_send.surname 	= "Einstein"
	_send.job 		= "genius"
	_send.location 	= "Germany"
	
	// Handle the remote data
	_load.onLoad = function(success, errorMsg)
	{
		if (success)
		{
			trace("Data received:")
			
			trace("Name    : " + this.name)
			trace("Surname : " + this.surname)
			trace("Job     : " + this.job)
			trace("Location: " + this.location)
		}
		else
		{
			trace("Loadvar Failed. " + errorMsg)
		}
	}
	
	// Send data with POST method and receive it back in the _load object
	_send.sendAndLoad("http://www.smartfoxserver.com/temp/loadvars.php", _load, "post")
}


function destroy()
{
	trace("Bye bye!")
}


function handleRequest(cmd, params, user, fromRoom)
{
	//
}


function handleInternalEvent(evt)
{
	//
}
