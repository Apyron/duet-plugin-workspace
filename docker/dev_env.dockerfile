FROM debian:buster-slim
MAINTAINER Peter Willemsen <peter@codebuffet.co>

RUN echo "Installing dependencies..." && \
    apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs nano python3 python3-pip git && \ 
    apt-get dist-upgrade -y && \
	rm -rf /var/lib/apt/lists/*

RUN echo "Installing DWC..." && \
    mkdir -p /app && cd /app && \
    # TODO: change branch/URL later when 3.4 is out!
    git clone -b v3.3-plugin-builder --depth=1 https://github.com/peterwilli/DuetWebControl.git DuetWebControl && \
    cd /app/DuetWebControl && \
    npm install && \
    # Dependencies used by our plugins
    npm install --save axios vuedraggable

ENV PLUGIN_INDEX_ORIGINAL /app/DuetWebControl/src/plugins/index.original.js

RUN echo "Patching DWC to work with Docker" && \
    result=$(cat /app/DuetWebControl/vue.config.js | sed "s/configureWebpack: {/configureWebpack: {resolve: {symlinks: false},/") && \
    mv /app/DuetWebControl/vue.config.js /app/DuetWebControl/vue.config.original.js && \
    mv /app/DuetWebControl/src/plugins/index.js $PLUGIN_INDEX_ORIGINAL && \
    echo "$result" > /app/DuetWebControl/vue.config.docker.js

ADD ./build_plugin /usr/bin/build_plugin
ADD patch_plugins.py /usr/bin/patch_plugins.py
ADD ./run_dwc /usr/bin/run_dwc

RUN echo "Installing DSF..." && \
    pip3 install dsf-python
    
WORKDIR /app/DuetWebControl
CMD ["sleep", "infinity"]