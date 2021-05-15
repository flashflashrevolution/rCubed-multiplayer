var zone

/**
* This simple example shows how you can easily access
* RoomVariables from the server side
*/
function init()
{
	// Get the current zone
	zone = _server.getCurrentZone()
	
	// Get the room called "The Hall"
	var hall = zone.getRoomByName("The Hall")
	
	// Now let's get all its variables
	// The returned object is a java.util.HashMap
	//
	// You can find the list of methods for this object here : http://java.sun.com/j2se/1.4.2/docs/api/java/util/HashMap.html
	var rVars = hall.getVariables()
	
	// We cycle through the HashMap and trace each variable
	for (var i = rVars.entrySet().iterator(); i.hasNext();)
	{
		var rVar = i.next()
		var varName = rVar.getKey()
		var varValue = rVar.getValue().getValue()
		
		trace("var: " + varName + ", val: " + varValue)
	}
	
}

function destroy()
{
	//
}

function handleRequest()
{
	//
}

function handleInternalEvent(e)
{
	//
}