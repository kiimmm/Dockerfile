FROM nvcr.io/nvidia/pytorch:20.07-py3

EXPOSE YOUR_PORT

# install basic tool
WORKDIR /tmp
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         zip \
         unzip \
         bzip2
# install nodejs for jupyterlab-lsp
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
# clean
RUN apt-get clean && \
    apt-get autoremove && \
    rm -rf /tmp/*
# font
WORKDIR /fonts
RUN curl -LO https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip && \
        unzip ./Hack-v3.003-ttf.zip && \
        cp -r ./ttf /usr/share/fonts/truetype/Hack-font && \
        chmod 644 /usr/share/fonts/truetype/Hack-font/* && \
        fc-cache -f

# RUN pip install --upgrade pip setuptools wheel && pip install wrapt --upgrade --ignore-installed wrapt
RUN pip install --upgrade pip && pip install wrapt --upgrade --ignore-installed wrapt
# upgrade to jupyterlab v2
RUN pip install --upgrade jupyterlab==2.2.8 jupyter-tensorboard jupyterlab-git pip-autoremove pylantern jupyterlab_code_formatter

# install jupyter extensions
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \ 
        @ijmbarr/jupyterlab_spellchecker \
        @jupyterlab/latex \
        @krassowski/jupyterlab_go_to_definition \
        jupyterlab-drawio \
        @krassowski/jupyterlab-lsp \
        @telamonian/theme-darcula \
        @jupyterlab/toc \
        @aquirdturtle/collapsible_headings
RUN jupyter lab build
RUN pip install python-language-server[all]

WORKDIR YOUR_WORKING_DIR
# set password
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:YOUR_ENCRYPTED_PASSWD'">>/root/.jupyter/jupyter_notebook_config.py