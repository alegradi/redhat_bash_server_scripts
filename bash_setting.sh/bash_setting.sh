#!/bin/bash

BASH_PROFILE=$'
## Additional settings for bash_profile ##
export HISTTIMEFORMAT="%d-%m-%y %T "
export HISTSIZE=5000'

echo "$BASH_PROFILE" >> /root/.bash_profile

exit 0


