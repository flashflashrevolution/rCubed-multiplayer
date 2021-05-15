// By Chris Lindsey
// 30Jan2006
// Email: chrislindsey218@gmail.com
// Free to distribute as long as code remains intact and credit is given where due.

var letters = new Object();
var userlist = new Array();
var idlist = new Array();

var stageh = 500;
var stagew = 800;

function init()
{
	var count = 0;
	
	trace("Letters script running.");
	
	for(var i = 0; i < 6; i++)
	{
		for(var j = 0; j < 26; j++)
		{
			letters[count] = new Object();
			
			letters[count].letter = String.fromCharCode(j + 65);
			letters[count].x = j * 20;
			letters[count].y = i * 20;
			letters[count].col = rgbtohex(j, j, j);
			
			count++;
		};
		
		for(var j = 0; j < 26; j++)
		{
			letters[count] = new Object();
			
			letters[count].letter = String.fromCharCode(j + 33);
			letters[count].x = j * 20;
			letters[count].y = i * 20 + 120;
			letters[count].col = rgbtohex(j, j, j);
			
			count++;
		};
	};
};

function destroy()
{
	trace("Letters script shuting down.");
};

function handleRequest(cmd, params, user, fromroom)
{
	if(cmd == "move")
	{
		var resp = new Object();
		
		letters[params.let].x = params.x;
		letters[params.let].y = params.y;
		
		if(letters[params.let].x < 0) letters[params.let].x = 0;
		if(letters[params.let].x > stagew) letters[params.let].x = stagew - 20;
		if(letters[params.let].y < 0) letters[params.let].y = 0;
		if(letters[params.let].y > stageh) letters[params.let].y = stageh - 20;
		
		resp._cmd = "update";
		
		resp.let = params.let;
		resp.x = letters[params.let].x;
		resp.y = letters[params.let].y;
		
		_server.sendResponse(resp, -1, null, userlist, "xml");
	};
};

function handleInternalEvent(evt)
{
	if(evt.name == "userJoin")
	{
		var user = evt.user;
		var resp = new Object();
		
		userlist.push(user);
		idlist.push(user.getUserId());
		
		resp._cmd = "locs";
		resp.letters = letters;
		
		_server.sendResponse(resp, -1, null, [user], "xml");
	};
	
	if(evt.name == "userExit" || evt.name == "userLost")
	{
		for(var i = 0; i < idlist.length; i++)
		{
			if(idlist[i] == evt.userId)
			{
				idlist.splice(i, 1);
				userlist.splice(i, 1);
			};
		};
	};
};

function rgbtohex(r, g, b)
{
    return ( "0x" + (r<<16 | g<<8 | b))
}