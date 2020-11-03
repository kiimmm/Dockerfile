# Dockerfile

## Overview
JupyterLab dockerfile to use Pytorch on CUDA environment
* Dockerfile based on [nvidia/pytorch:20.10-py3](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-10.html#rel_20-10)
  * Ubuntu 18.04 (Python 3.6)
  * NVIDIA CUDA 11.1.0
  * Pytorch 1.7 (currently stable version)
* JupyterLab 2.3.0a1
  * Upgraded from original JupyterLab v1.x
  * With several JupyterLab extensions
* Set default font to [Hack Font](https://github.com/source-foundry/Hack)
## Some Points
* `PORT1`: port for jupyter lab
* `PORT2`: port for python lsp
* `YOUR_WORKING_DIR`: the directory where you want to begin  
  * when you run `docker run`, you can add `--mount type=bind,source=/SOURCE,target=YOUR_WORKING_DIR`
* `YOUR_ENCRYPTED_PASSWD`: SHA1 encrypted password. I hard-code encrypted password to the dockerfile to avoid type token every time. A way to generate SHA1-encrypted password:
  * ```
    > ipython
    > from notebook.auth import passwd
    > passwd()
    type your PASSWD
    > OUTPUT: sha1: SHA1-encrypted-password
    ```
## References
* https://github.com/eungbean/Docker-for-AI-Researcher/blob/master/Dockerfile-jupyterlab/Dockerfile
* https://github.com/mauhai/awesome-jupyterlab