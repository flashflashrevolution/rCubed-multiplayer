/*
* SmartFoxServer PRO
* Simple setIntervalExample
* v 1.0.0
* 
* (c) 2005 gotoAndPlay()
*
*  
*/


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
	cnt = 0
	myInterval = setInterval("intervallicFunction", 1000)
	
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
	clearInterval(myInterval)
	trace("Quitting extension")
}


/*
*  This function is called by the setInterval
*/
function intervallicFunction()
{
	trace("SetInterval being called, count = " + (cnt++))

	if (cnt > 10)
	{
		clearInterval(myInterval)
		trace("Interval killed")
	}

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
	//
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


