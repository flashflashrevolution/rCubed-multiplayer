/*
* SmartFoxServer PRO
* "File Manager" extension example.
* v 1.0.0
*
* The example shows how an extension can work in conjunction with the
* embedded webserver to handle a file upload.
* 
* (c) 2005-2006 gotoAndPlay()
* www.gotoandplay.it
* www.smartfoxserver.com
*/

var imageList = null
var imagePath = "./webserver/webapps/default/uploads/"
var zone = null

/* 
* Initializion point
*/
function init()
{
	zone = _server.getCurrentZone()
	imageList = []

	// Get the list of images in the folder
	var dir = _server.getFileList(imagePath)
	
	// Cycle through all files
	for (var i in dir)
	{
		var file = dir[i]
		
		// Check if the current file is a jpg or png image 
		if (file.indexOf(".jpg") > -1 || file.indexOf(".png") > -1)
		{
			// Add it to the local list
			imageList.push(String(dir[i]))
		}
		
	}
	
	trace("Image Manager extension starts...")
}


/*
* This method is called by the server when an extension
* is being removed / destroyed.
*/
function destroy()
{
	delete imageList
	trace("Image Manager extension stops...")
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
	// get image list
	if (cmd == "getImgList")
	{
		var resp = {}
		resp._cmd = cmd
		resp.imgList = imageList
		
		_server.sendResponse(resp, -1, null, [user], _server.PROTOCOL_JSON)
	}
	
	// delete image list
	else if (cmd == "delImg")
	{
		var fileToDelete = "webserver/webapps/default/uploads/" + params.fName
		var success =_server.removeFile(fileToDelete)
		
		if (success)
		{
			trace("File: " + fileToDelete +  " successfully removed")
			removeFromLocalList(params.fName)
			
			// Notify all users that a file was deleted
			var resp = {}
			resp._cmd = "delImg"
			resp.fName = params.fName
			
			var room = zone.getRoom(user.getRoom())
			
			_server.sendResponse(resp, -1, null, room.getAllUsers(), _server.PROTOCOL_JSON)
		}
			
		else
			trace("Failed removing file: " + fileToDelete)
	}
}

/*
* Remove a file from the local file list
*/
function removeFromLocalList(fname)
{
	for (var i in imageList)
	{
		if (fname == imageList[i])
		{
			imageList.splice(i,1)
			break
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
	/*
		File upload event. 
		Passed parameters are:
		
		files	an array of objects. 
				each object represents an uploaded file
				each object contain 2 properties:
					fileName 		-> the name of the file that was saved in the uploads/ folder
					originalName	-> the original file name
					
		user	the user that uploaded the file 
	*/
	if (evt.name == "fileUpload")
	{
		var files = evt.files
		var user = evt.user
		var room = zone.getRoom(user.getRoom())
		var fList = []
		
		for (var i in files)
		{
			trace("Upload file: " + files[i].fileName + ", " + files[i].originalName)
			imageList.push(files[i].fileName)
			fList.push(files[i].fileName)
		}
		
		var resp = {}
		resp._cmd = "fileAdd"
		resp.files = fList
		
		_server.sendResponse(resp, -1, null, room.getAllUsers(), _server.PROTOCOL_JSON)
	}
}


