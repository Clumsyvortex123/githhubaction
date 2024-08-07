FROM ubuntu:20.04

# Use bash as the default shell
SHELL ["/bin/bash", "-c"]

WORKDIR /root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake clang net-tools htop vim-nox python3-dev wget unzip\
    xfce4 xfce4-goodies tightvncserver tigervnc-standalone-server dbus-x11 xfonts-base \
    vim tmux ranger neofetch curl git fzf\
    python3 python-is-python3 python3-pip python3-venv

EXPOSE 5902

RUN mkdir /root/.vnc \
    && echo "000000" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

RUN touch /root/.Xauthority

COPY .vimrc /root/.vimrc
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

COPY .tmux.conf /root/.tmux.conf
COPY .gitconfig /root/.gitconfig

COPY .bashrc /root/.bashrc.tmp
RUN curl -o /usr/share/doc/fzf/examples/key-bindings.bash https://raw.githubusercontent.com/junegunn/fzf/0.20.0/shell/key-bindings.bash
RUN cat /root/.bashrc.tmp >> /root/.bashrc
RUN rm /root/.bashrc.tmp
