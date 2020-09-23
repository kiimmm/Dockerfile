# Dockerfile

## Overview
JupyterLab dockerfile to use Pytorch on CUDA environment
* Dockerfile based on [nvidia/pytorch:20.07-py3](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel_20-07.html#rel_20-07)  
  * Ubuntu 18.04 (Python 3.6)
  * NVIDIA CUDA 11.0.194
  * Pytorch 1.6 (currently stable version)
* JupyterLab 2.2.8  
  * Upgraded from original JupyterLab v1.x
  * With several JupyterLab extensions
* Including [Hack Font](https://github.com/source-foundry/Hack)
## Some Points
* `YOUR_PORT`: ports that you want to expose
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
* It seems that there are some incompatible issues...
## References
* https://github.com/eungbean/Docker-for-AI-Researcher/blob/master/Dockerfile-jupyterlab/Dockerfile
* https://github.com/mauhai/awesome-jupyterlab