package ffr;

import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.exceptions.SFSException;
import com.smartfoxserver.v2.extensions.BaseServerEventHandler;

public class ZoneJoinEventHandler extends BaseServerEventHandler {

    @Override
    public void handleServerEvent(ISFSEvent event) throws SFSException {
        trace("handle server zone join event");
        User theUser = (User) event.getParameter(SFSEventParam.USER);
        Room lobby = getParentExtension().getParentZone().getRoomByName("The Lobby");
        getApi().joinRoom(theUser, lobby);
    }

}