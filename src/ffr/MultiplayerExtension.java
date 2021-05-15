package ffr;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

public class MultiplayerExtension extends AbstractExtension
{
	private ExtensionHelper helper;
	
    public void init() {
        helper = ExtensionHelper.instance();

        trace("Hi! The Simple Extension is initializing");
        trace("Less exceptional things.");
    }


    public void destroy() {
		trace("Bye bye! SimpleExtension is shutting down!");
		trace("Farewell change, I will miss you.");
    }

	/**
	 * Handle client requests sent in XML format.
	 * The AS objects sent by the client are serialized to an ActionscriptObject
	 * 
	 * @param ao 		the ActionscriptObject with the serialized data coming from the client
	 * @param cmd 		the cmd name invoked by the client
	 * @param fromRoom 	the id of the room where the user is in
	 * @param u 		the User who sent the message
	 */
	public void handleRequest(String cmd, ActionscriptObject ao, User u, int fromRoom)
	{
		trace("The command -> " + cmd + " was invoked by user -> " + u.getName());
    }

	/**
	 * Handle client requests sent in String format.
	 * The parameters sent by the client are split in a String[]
	 * 
	 * @param params 	an array of data coming from the client
	 * @param cmd 		the cmd name invoked by the client
	 * @param fromRoom 	the id of the room where the user is in
	 * @param u 		the User who sent the message
	 */
	public void handleRequest(String cmd, String[] params, User u, int fromRoom)
	{
		trace("The command -> " + cmd + " was invoked by user -> " + u.getName());
    }

    	/**
	 * Handles an event dispateched by the Server
	 * @param ieo the InternalEvent object
	 */
    public void handleInternalEvent(InternalEventObject ieo) {
		trace("Received a server event --> " + ieo.getEventName());
    }
}
