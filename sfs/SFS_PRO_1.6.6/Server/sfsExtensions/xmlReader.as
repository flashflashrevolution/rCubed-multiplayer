/*
* SmartFoxServer PRO
* XML Parser Example
* 
* Demonstrates how to incorporate custom Java classes
* into the Actionscript on the server side.
* 
* v 1.0.0
* 
* (c) 2005 gotoAndPlay()
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
	// Create a reference to the Java package
	// This help us building new objects from the nanoxml package.
	// Instead of typing the fully qualified Class name we'll just use:
	//
	// var obj = new nanoxml.SomeObject()
	nanoxml = Packages.net.n3.nanoxml

		
	readTheXmlFile()
}


/*
* Read and parse the XML file
*/
function readTheXmlFile()
{
	// Setup the xml parser object
	var xmlParser = nanoxml.XMLParserFactory.createDefaultXMLParser()
	
	// This is the XML Reader:
	// You can use a fileReader, to read the XML from a file
	// or the StringReader, to read the XML from a string
	var xmlReader = nanoxml.StdXMLReader.fileReader("sfsExtensions/data/books.xml")
	
	// Assign the reader to the parser
	xmlParser.setReader(xmlReader)
	
	// Finally parse the XML
	var xmlDoc = xmlParser.parse()
	
	// Get the tag called <collectionName></collectionName>
	var node = xmlDoc.getFirstChildNamed("collectionName")
	trace("Collection Name: " + node.getContent())
	
	// Get the tag called <collectionOwner></collectionOwner>
	var node = xmlDoc.getFirstChildNamed("collectionOwner")
	trace("Collection Owner: " + node.getContent() + newline)
	
	// Get the tag called <collectionOwner></collectionOwner>
        var node = xmlDoc.getFirstChildNamed("bookList")
	
	// book is a java.util.Enumeration object
	var books = node.enumerateChildren()
	
	// Cycle through each element in the Enumeration
	//
	while (books.hasMoreElements())
	{
		var book = books.nextElement()
		
		trace("Title    : " + book.getAttribute("title", ""))
		trace("Author   : " + book.getAttribute("author", "unknown"))
		trace("Year     : " + book.getAttribute("year", "unknown"))
		trace("Publisher: " + book.getAttribute("publisher", "unknown"))
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


