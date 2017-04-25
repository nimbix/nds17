#!/bin/bash

# NDS17 PushToCompute Workshop

. /usr/local/torch/install/bin/torch-activate

cd /usr/local/neural-style/neural-style

# Note: Output should be set to /data directory (persistant storage)
th neural_style.lua -backend cudnn -output_image /data/stylized.png $@

if [ $? -gt 0 ]; then
    echo "Image stylization failed with an unknown error. Please contact the application maintainer for support."
fi

exit 0
