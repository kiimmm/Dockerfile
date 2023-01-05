FROM nvcr.io/nvidia/pytorch:22.10-py3

EXPOSE PORT1 PORT2

ARG DEBIAN_FRONTEND=noninteractive
# install basic ubuntu tools
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         zip \
         unzip \
         bzip2 \
         htop \
         fonts-powerline \
         software-properties-common \
         tmux \
         cloc

# ---------
# MULTIVERSE
# ---------
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common curl
RUN apt-add-repository multiverse
RUN apt-get update

# msttcorefonts
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
RUN apt-get install -y --no-install-recommends fontconfig ttf-mscorefonts-installer
RUN fc-cache -f -v

# Hack as basic font
WORKDIR /tmp
RUN curl -LO https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip && \
        unzip ./Hack-v3.003-ttf.zip && \
        cp -r ./ttf /usr/share/fonts/truetype/Hack-font && \
        chmod 644 /usr/share/fonts/truetype/Hack-font/* && \
        fc-cache -f

# install nodejs for jupyterlab-lsp
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# oh-my-zsh
RUN apt-get install -y zsh
RUN curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
RUN chsh -s $(which zsh)
CMD [ "/bin/zsh" ]

# install emacs 27
RUN add-apt-repository ppa:kelleyk/emacs
RUN apt-get update
RUN apt-get install -y emacs27
# install spacemacs
RUN git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

# install basic python tools
RUN pip install --upgrade pip
RUN pip install --upgrade jupyterlab theme-darcula tqdm ipywidgets jupyterlab_code_formatter black isort aquirdturtle_collapsible_headings jupyterlab-spellchecker jupyterlab-lsp visdom timm torchtoolbox wandb einops pandas munch Pillow tsai scikit-learn matplotlib seaborn fastai
RUN pip install 'python-language-server[all]'

RUN jupyter lab clean
RUN jupyter lab build

COPY server.yml /tmp
CMD ["node","usr/local/share/jupyter/lab/staging/node_modules/jsonrpc-ws-proxy/dist/server.js","--port PORT2","--languageServers","/tmp/server.yml"]

# clean
RUN ldconfig && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

WORKDIR YOUR_WORKING_DIR
RUN jupyter server --generate-config
RUN echo "c.ServerApp.token=''">>/root/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.open_browser = False">>/root/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.password=u'sha1:YOUR_ENCRYPTED_PASSWD'">>/root/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.allow_password_change=False">>/root/.jupyter/jupyter_server_config.py
RUN echo "c.ServerApp.port = PORT1">>/root/.jupyter/jupyter_server_config.py

# Github config
RUN git config --global user.name GIT_USERNAME
RUN git config --global user.email GIT_EMAIL