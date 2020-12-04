FROM nvcr.io/nvidia/pytorch:20.10-py3

EXPOSE PORT1 PORT2

# install basic tool
WORKDIR /tmp
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         zip \
         unzip \
         bzip2 \
         htop

# download Hack font
RUN curl -LO https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip && \
        unzip ./Hack-v3.003-ttf.zip && \
        cp -r ./ttf /usr/share/fonts/truetype/Hack-font && \
        chmod 644 /usr/share/fonts/truetype/Hack-font/* && \
        fc-cache -f

# install basic python tool
RUN pip install --upgrade pip
RUN pip install --upgrade jupyterlab==2.3.0a1 wheel wrapt jupyter-lsp jupyterlab-git black isort jupyter-tensorboard jupytext ipywidgets

# install nodejs for jupyterlab-lsp
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# clean
RUN ldconfig && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# install jupyter extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager@2 \
        @ijmbarr/jupyterlab_spellchecker \
        @jupyterlab/latex \
        @krassowski/jupyterlab_go_to_definition \
        @krassowski/jupyterlab-lsp \
        @telamonian/theme-darcula \
        @jupyterlab/toc \
        @aquirdturtle/collapsible_headings \
        @ryantam626/jupyterlab_code_formatter \
        jupyterlab_tensorboard
RUN jupyter lab build

RUN pip install python-language-server[all] jupyterlab_code_formatter
RUN jupyter serverextension enable --py jupyterlab_code_formatter

COPY server.yml /tmp
CMD ["node","usr/local/share/jupyter/lab/staging/node_modules/jsonrpc-ws-proxy/dist/server.js","--port PORT2","--languageServers","/tmp/server.yml"]

WORKDIR YOUR_WORKING_DIR
# set password
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:YOUR_ENCRYPTED_PASSWD'">>/root/.jupyter/jupyter_notebook_config.py