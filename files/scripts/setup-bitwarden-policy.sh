#!/usr/bin/env bash
set -euo pipefail

chown root:root /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy

chcon system_u:object_r:usr_t:s0 /usr/share/polkit-1/actions/com.bitwarden.Bitwarden.policy
