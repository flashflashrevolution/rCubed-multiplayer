#!/bin/bash

ln -sfv /workspaces/sfs-new/config /workspaces/sfs-new/sfs/SFS_PRO_1.6.6/Server/
/workspaces/sfs-new/sfs/SFS_PRO_1.6.6/Server/wrapper -c /workspaces/sfs-new/config/wrapper.develop.conf
