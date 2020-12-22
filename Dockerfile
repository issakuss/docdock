FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

COPY nvimadd.txt /nvimadd.txt

RUN apt update \
&&  apt install -y tzdata
 
ENV TZ=ASIA/TOKYO \
    USER_ID=22398 \
    GROUP_ID=16003 \
    USER_NAME=issakuss \
    GROUP_NAME=cns
ENV PATH=$PATH:/home/${USER_NAME}/.cabal/bin:/home/${USER_NAME}/.local/share/nvim/plugged/zotcite/python3
 
RUN apt update \
&&  apt install -y tree \

# User / Group ID
&&  useradd -s /bin/bash -m ${USER_NAME} \
&&  export HOME=/home/${USER_NAME} \
&&  usermod -u ${USER_ID} ${USER_NAME} \
&&  groupadd -g ${GROUP_ID} ${GROUP_NAME} \
&&  usermod -g ${GROUP_NAME} ${USER_NAME} \

# Git
&&  apt install -y git git-lfs \
&&  git config --global user.email issakuss@gmail.com \
&&  git config --global user.name issakuss\
&&  git lfs install \ 
&&  ln -s /mnt/github/ ~/.ssh \
 
# Python
&&  apt install -y python3=3.8.2-0ubuntu2 python3-pip\
&&  pip3 install -U pip \
&&  pip install pandocfilters \
&&  ln -s /usr/bin/python3 /usr/bin/python \

# NeoVim
&&  apt install -y neovim curl\
&&  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
&&  cd ~/ \
&&  git clone https://github.com/issakuss/dotfiles.git \
&&  dotfiles/setup.sh \
&&  cd / \
&&  apt remove -y curl \

# Pandoc
&&  apt install -y cabal-install \
&&  cabal update \
&&  cabal install pandoc-citeproc \

# Additional Vim Plugins
&&  cat nvimadd.txt >> ~/dotfiles/init.vim \
&&  nvim +PlugInstall +GrammarousCheck +qa \

# Cleaning
&&  chown -R ${USER_ID}:${GROUP_ID} /home/${USER_NAME} \
&&  apt autoremove -y \
&&  apt clean -y \
&&  rm nvimadd.txt
