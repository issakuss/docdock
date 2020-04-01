FROM alpine:latest

RUN apk update \
&&  apk upgrade --available \
&&  apk add -f --no-cache --virtual .temp \
      wget build-base make cmake gcc gmp curl xz perl cpio coreutils \
      binutils-gold tar gzip unzip libc-dev musl-dev ncurses-dev gmp-dev \
      zlib-dev expat-dev libffi-dev gd-dev postgresql-dev linux-headers cabal \
&&  apk add -f --no-cache vim git git-lfs ghc openjdk11-jre-headless python3 \

# Python
&&  ln -s /usr/bin/python3 /usr/bin/python \
&&  pip3 install pandocfilters \

# Pandoc
&&  cd /usr/bin \
&&  ./cabal new-update \
&&  ./cabal new-install pandoc pandoc-citeproc pandoc-crossref \

# dotfiles
&&  cd /root \
&&  git clone https://github.com/issakuss/dotfiles.git \
&&  dotfiles/setup_vim.sh \
&&  dotfiles/setup.sh \

# Vim Plugins
&&  echo "set colorcolumn=0" >> ~/.vimrc \
&&  echo "Plugin 'rhysd/vim-grammarous'" >> ~/.vimrc \
&&  echo "let g:grammarous#enable_spell_check=1" >> ~/.vimrc \
&&  echo "Plugin 'benshuailyu/online-thesaurus-vim'" >> ~/.vimrc \
&&  echo "Plugin 'jalvesaq/zotcite'" >> ~/.vimrc \
&&  vim +PluginInstall +GrammarousCheck +qall \

# Cleaning
&&  apk del --purge .temp

ENV PATH $PATH:/root/.cabal/bin:/root/.vim/bundle/zotcite/python3
