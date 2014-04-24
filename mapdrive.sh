#!/bin/bash

# The VM user to use for guest control.
guest_user="IEUser"

# The VM user password to use for guest control.
guest_pass="Passw0rd!"

# Execute a command with arguments on a virtual machine.
guest_control_exec() {
    local vm="${1}"
    local image="${2}"
    shift; shift
    VBoxManage guestcontrol "${vm}" exec --image "${image}" \
        --username "${guest_user}" --password "${guest_pass}" \
        --wait-exit --wait-stderr -- "$@"
}

vm='IE8 - WinXP'

# TODO: are these idempotent?
VBoxManage sharedfolder add "${vm}" --name 'mathdown' --hostpath '/home/beni/mathdown' --automount
# Auto mounting seesm to assign E: but it might not be stable, so let'smap to our own letter.
guest_control_exec "${vm}" cmd.exe /C net use /persistent:yes M: '\\VBOXSVR\mathdown'
