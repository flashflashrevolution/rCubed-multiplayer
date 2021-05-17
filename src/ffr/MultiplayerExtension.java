package ffr;

import com.smartfoxserver.v2.core.SFSEventType;
import com.smartfoxserver.v2.extensions.SFSExtension;

public class MultiplayerExtension extends SFSExtension {

    @Override
    public void init() {
        trace("Multiplayer Extension -- started");
        addEventHandler(SFSEventType.USER_LOGIN, LoginEventHandler.class);
        addEventHandler(SFSEventType.USER_JOIN_ZONE, ZoneJoinEventHandler.class);
    }

    @Override
    public void destroy() {
        super.destroy();
        trace("Multiplayer Extension -- stopped");
    }
}
