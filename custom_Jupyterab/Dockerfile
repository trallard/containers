#  docker-build/Jupyterlab/Dockerfile
#  pin a  specif version of the notebook as they follow a quick release pattern
#  so the latest change quite often, make sure to update every so often
FROM jupyter/minimal-notebook:87210526f381

# ensure we can install airflow
ENV SLUGIFY_USES_TEXT_UNIDECODE=yes

# due to how the base image manages the installs and the conda distribution it is best
# to install the requirements using the --user flag to ensure persistence
COPY ./requirements.txt ./requirements.txt

# install vim as root
USER root 

RUN apt-get update && apt-get install vim -y \
    && sudo apt-get install -y vim nano ssh net-tools openssh-client 

# ensure we are the unpriviledged user
USER jovyan 

# it comes with Python 3.7 so we need to downgrade the version, can be ignored 
# and leave as default 3.7
RUN conda install python=3.6 -y \
    && pip install --user --progress-bar off -r requirements.txt \
    && python3 -m nltk.downloader treebank popular punkt \
    && pip install --user --progress-bar off --extra-index-url https://nexus.hellosoda.com/repository/pypi/simple/ --upgrade dptk \
    && rm requirements.txt \
    && export PATH=$PATH:/home/jovyan/.local/bin