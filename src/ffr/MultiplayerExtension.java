package ffr;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;
import it.gotoandplay.smartfoxserver.lib.SmartFoxLib;

import java.util.function.Function;

import com.healthmarketscience.sqlbuilder.BinaryCondition;
import com.healthmarketscience.sqlbuilder.SelectQuery;
import com.healthmarketscience.sqlbuilder.dbspec.basic.DbColumn;
import com.healthmarketscience.sqlbuilder.dbspec.basic.DbSchema;
import com.healthmarketscience.sqlbuilder.dbspec.basic.DbSpec;
import com.healthmarketscience.sqlbuilder.dbspec.basic.DbTable;

public class MultiplayerExtension extends AbstractExtension {

	public void init() {
		trace("MultiplayerExtension Initialized");
		TryToLogIn("asdf", "asdf");
	}

	public void destroy() {
		trace("Bye bye!");
	}

	private void TryToLogIn(String username, String password) {
		username = SmartFoxLib.escapeQuotes(username);
		password = SmartFoxLib.escapeQuotes(password);

		var spec = new DbSpec();
		var schema = spec.addSchema("ffr_vb2");
		var ffrLoginSessionsTable = new DbTable(schema, "vb_user");
		var passwordColumn = ffrLoginSessionsTable.addColumn("password", "varchar", 255);
		var userNameColumn = ffrLoginSessionsTable.addColumn("username", "varchar", 100);
		var userIdColumn = ffrLoginSessionsTable.addColumn("userid", "number", null);
		var userGroupIdColumn = ffrLoginSessionsTable.addColumn("usergroupid", "number", null);

		Function<Integer, Double> ourFunc = i -> i * 10.0;
		ourFunc.apply(10);

		String selectSession = new SelectQuery()
			.addCustomColumns(
				passwordColumn,
				userIdColumn,
				userGroupIdColumn
			)
			.addFromTable(ffrLoginSessionsTable)
			.addCondition(
				BinaryCondition.equalTo(userNameColumn, username)
			)
			.validate()
			.toString();
		
		trace(selectSession);
	}

	/**
	 * Handle client requests sent in XML format. The AS objects sent by the client
	 * are serialized to an ActionscriptObject
	 * 
	 * @param ao       the ActionscriptObject with the serialized data coming from
	 *                 the client
	 * @param cmd      the cmd name invoked by the client
	 * @param fromRoom the id of the room where the user is in
	 * @param u        the User who sent the message
	 */
	public void handleRequest(String cmd, ActionscriptObject ao, User u, int fromRoom) {
		trace("The command -> " + cmd + " was invoked by user -> " + u.getName());
	}

	/**
	 * Handle client requests sent in String format. The parameters sent by the
	 * client are split in a String[]
	 * 
	 * @param params   an array of data coming from the client
	 * @param cmd      the cmd name invoked by the client
	 * @param fromRoom the id of the room where the user is in
	 * @param u        the User who sent the message
	 */
	public void handleRequest(String cmd, String[] params, User u, int fromRoom) {
		trace("The command -> " + cmd + " was invoked by user -> " + u.getName());
	}

	/**
	 * Handles an event dispateched by the Server
	 * 
	 * @param ieo the InternalEvent object
	 */
	public void handleInternalEvent(InternalEventObject ieo) {
		trace("Received a server event --> " + ieo.getEventName());
	}
}
