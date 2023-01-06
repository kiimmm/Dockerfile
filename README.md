# Dockerfile

## Overview
JupyterLab dockerfile to use Pytorch on CUDA environment
* Dockerfile based on [nvidia/pytorch:22.10-py3](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-22-10.html#rel-22-10)
  * Ubuntu 20.04 (Python 3.8)
  * NVIDIA CUDA 11.8.0
  * Pytorch 1.13
* JupyterLab 3.X
  * Upgraded from original JupyterLab v1.x
  * [Darcula](https://github.com/telamonian/theme-darcula), [ipywidgets](https://github.com/jupyter-widgets/ipywidgets), [Code Formatter](https://github.com/ryantam626/jupyterlab_code_formatter), [Collapsable Headings](https://github.com/aquirdTurtle/Collapsible_Headings), [Spellchecker](https://github.com/jupyterlab-contrib/spellchecker), [LSP](https://github.com/krassowski/jupyterlab-lsp)
* Set default font to [Hack Font](https://github.com/source-foundry/Hack)
* Install [Spacemacs](https://github.com/syl20bnr/spacemacs)
* Install [oh-my-zsh](https://ohmyz.sh/)
* Install mscorefonts
* Some other packages...

## Some Points
* `PORT1`: port for jupyter lab
* `PORT2`: port for python lsp
* `YOUR_WORKING_DIR`: the directory where you want to begin  
  * when you run `docker run`, you can add `--mount type=bind,source=/SOURCE,target=YOUR_WORKING_DIR`
* `YOUR_ENCRYPTED_PASSWD`: SHA1 encrypted password. I hard-code encrypted password to the dockerfile to avoid type token every time. A way to generate SHA1-encrypted password:
  * ```
    > ipython
    > from IPython.lib import passwd
    > passwd()
    type your PASSWD
    > OUTPUT: sha1: SHA1-encrypted-password
    ```
* `GIT_USERNAME`, `GIT_EMAIL`: configuration for git

## References
* https://github.com/eungbean/Docker-for-AI-Researcher/blob/master/Dockerfile-jupyterlab/Dockerfile
* https://github.com/mauhai/awesome-jupyterlab