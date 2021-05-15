#!/bin/bash

ln -sfv /workspaces/rCubed-multiplayer/config /workspaces/rCubed-multiplayer/sfs/SFS_PRO_1.6.6/Server/
/workspaces/rCubed-multiplayer/sfs/SFS_PRO_1.6.6/Server/wrapper -c /workspaces/rCubed-multiplayer/config/wrapper.develop.conf
