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
    npm install --save axios vuedraggable moment

ENV PLUGIN_INDEX_ORIGINAL /app/DuetWebControl/src/plugins/index.original.js

RUN echo "Patching DWC to work with Docker" && \
    mv /app/DuetWebControl/src/plugins/index.js $PLUGIN_INDEX_ORIGINAL && \
    result_run_dwc=$(cat /app/DuetWebControl/vue.config.js | sed "s|configureWebpack: {|configureWebpack: {resolve: { symlinks: false, alias: { dwc: '/app/DuetWebControl/src' } },|") && \
    result_build_plugin=$(cat /app/DuetWebControl/vue.config.js | sed "s|configureWebpack: {|configureWebpack: {resolve: { alias: { dwc: '/app/DuetWebControl/src' } },|") && \
    mv /app/DuetWebControl/vue.config.js /app/DuetWebControl/vue.config.original.js && \
    echo "$result_run_dwc" > /app/DuetWebControl/vue.config.run_dwc.js && \
    echo "$result_build_plugin" > /app/DuetWebControl/vue.config.build_plugin.js

ADD ./build_plugin /usr/bin/build_plugin
ADD patch_plugins.py /usr/bin/patch_plugins.py
ADD ./run_dwc /usr/bin/run_dwc

RUN echo "Installing DSF..." && \
    pip3 install dsf-python
    
WORKDIR /app/DuetWebControl
CMD ["sleep", "infinity"]