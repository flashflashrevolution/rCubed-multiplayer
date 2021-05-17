package ffr;

import java.util.Arrays;
import java.util.List;

import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.variables.SFSUserVariable;
import com.smartfoxserver.v2.entities.variables.UserVariable;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

public class ZoneJoinEventHandler extends BaseServerEventHandler {

    @Override
    public void handleServerEvent(ISFSEvent event) throws SFSException {
		User theUser = (User) event.getParameter(SFSEventParam.USER);
		
		// dbid is a hidden UserVariable, available only server side
		UserVariable uv_dbId = new SFSUserVariable("dbid", theUser.getSession().getProperty(MultiplayerExtension.DATABASE_ID));
		uv_dbId.setHidden(true);
		
		// The avatar UserVariable is a regular UserVariable
		UserVariable uv_avatar = new SFSUserVariable("avatar", "avatar_" + theUser.getName() + ".jpg");
		
		// Set the variables
		List<UserVariable> vars = Arrays.asList(uv_dbId, uv_avatar);
		getApi().setUserVariables(theUser, vars);
		
		// Join the user
		Room lobby = getParentExtension().getParentZone().getRoomByName("The Lobby");
		
		if (lobby == null)
			throw new SFSException("The Lobby Room was not found! Make sure a Room called 'The Lobby' exists in the Zone to make this example work correctly.");
		
		getApi().joinRoom(theUser, lobby);
    }

}
