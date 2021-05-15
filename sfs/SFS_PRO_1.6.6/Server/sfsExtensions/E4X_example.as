/*
* SmartFoxServer PRO
* E4X Example based on the  XML Parser Example
* 
* Demonstrates how to use E4X languages inside an actionscript extension
* 
* v 1.0.0
* 
* (c) 2005-2006 gotoAndPlay()
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

// Global extension variables
var xmlObj = null

function init()
{
	// Read xml file from disk
	var xmlData = _server.readFile("sfsExtensions/data/books.xml")
	
	// Create an XML object
	xmlObj = new XML(xmlData)
	
	// Show data
	readTheXmlFile()
	
	
	// Example #1: search all books published in 2003
	/*
	var books = xmlObj.bookList.book.(@year == 2003)

	for (var i = 0; i < books.length(); i++)
	{
		trace("Title    : " + books[i].@title)
		trace("Author   : " + books[i].@author)
		trace("Year     : " + books[i].@year)
		trace("Publisher: " + books[i].@publisher)
		trace("-------------------------------------")
	}*/
	
	// Example #2: match a substring in name attribute
	/*
	var books = xmlObj.bookList.book.(@title.toString().indexOf("Java") > -1)

	for (var i = 0; i < books.length(); i++)
	{
		trace("Title    : " + books[i].@title)
		trace("Author   : " + books[i].@author)
		trace("Year     : " + books[i].@year)
		trace("Publisher: " + books[i].@publisher)
		trace("-------------------------------------")
	}
	*/
	
}


/*
* Read and parse the XML file
*/
function readTheXmlFile()
{
	// Show the <collectionName> and <collectionOwner> nodes
	trace("Collection Name: " + xmlObj.collectionName)
	trace("Collection Owner: " + xmlObj.collectionOwner + newline)
	
	var bookList = xmlObj.bookList.book

	for (var i = 0; i < bookList.length(); i++)
	{
		trace("Title    : " + bookList[i].@title)
		trace("Author   : " + bookList[i].@author)
		trace("Year     : " + bookList[i].@year)
		trace("Publisher: " + bookList[i].@publisher)
		trace("-------------------------------------")
	}
}


/*
* This method is called by the server when an extension
* is being removed / destroyed.
* 
* Always make sure to release resources like setInterval(s)
* open files etc in this method.
*
*/
function destroy()
{
	//
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


