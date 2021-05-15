#
# Simple Python Extension
# v 1.0.0
#

def init():
	global db 
	global cmdMap
	
	cmdMap = {"getData": handleGetData}
	
	db = _server.getDatabaseManager()


def destroy():
	_server.trace( "Python extension dying" )


def handleRequest(cmd, params, who, roomId, protocol):
	if protocol == "xml":
		if cmdMap.has_key(cmd):
			cmdMap[cmd](params, who, roomId)
		

def handleInternalEvent(evt):
	evtName = evt.getEventName()
	_server.trace( "Received internal event: " + evt.getEventName() )
	

def handleGetData(params, who, roomId):
	
	sql = "SELECT * FROM contacts ORDER BY name"
	queryRes = db.executeQuery(sql)
	
	response = {}
	response["_cmd"] = "getData"
	response["db"] = {}

	if (queryRes != None) and (queryRes.size() > 0):
		
		c = 0
		for row in queryRes:
			item = {}
			item["name"] = row.getItem("name")
			item["location"] = row.getItem("location")
			item["email"] = row.getItem("email")
			
			response["db"][c] = item
			c += 1
		
	else:
		_server.trace("QUERY FAILED")

	_server.sendResponse(response, -1, None, [who])
	