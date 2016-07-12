#!/bin/bash
set -e

case "$1" in
  "")
    bash
    ;;
  ipynb)
    cd '/home/workspace/notebooks'
    ipython3 notebook --no-browser --ip='*' --matplotlib="inline"
    ;;
  *)
    $@
    ;;
esac

exit 0

