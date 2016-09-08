#!/bin/bash
set -e

# start supervisor
supervisord -c /etc/supervisor/supervisord.conf

#cd '/home/workspace/notebooks'; ipython3 notebook --no-browser --ip='*' --matplotlib="inline";


#case "$1" in
#  "")
#    bash
#    ;;
#  ipynb)
#    cd '/home/workspace/notebooks'
#    ipython3 notebook --no-browser --ip='*' --matplotlib="inline"
#    ;;
#  *)
#    $@
#    ;;
#esac

exit 0

