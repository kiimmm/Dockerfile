FROM nvcr.io/nvidia/pytorch:20.07-py3

EXPOSE 8888

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         zip \
         unzip \
         bzip2 \
         nodejs

# font
WORKDIR /fonts
RUN curl -O https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip && \
        unzip Hack-v3.003-ttf.zip

# install jupyterlab extensions
RUN pip install --upgrade pip && pip install pylantern 
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager \ 
        @ijmbarr/jupyterlab_spellchecker \
        @jupyterlab/latex \
        @jupyterlab/git \
        @krassowski/jupyterlab_go_to_definition \
        jupyterlab-drawio \
        @krassowski/jupyterlab-lsp \
        @telamonian/theme-darcula \
        @jupyterlab/toc \
        @aquirdturtle/collapsible_headings \
        @ryantam626/jupyterlab_code_formatter
RUN jupyter lab build
RUN pip install python-language-server[all]

#CleanUp
RUN apt-get clean && \
    apt-get autoremove && \