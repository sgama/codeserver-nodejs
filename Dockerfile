FROM codercom/code-server:latest as binary

FROM node:latest
ENV VSCODE_EXTENSIONS="/root/.local/share/code-server/extensions" \
    LC_ALL=en_US.UTF-8      \
    LANG=en_US.UTF-8        \
    LANGUAGE=en_US.UTF-8    \
    DISABLE_TELEMETRY=true

COPY --from=binary /usr/local/bin/code-server /usr/local/bin/code-server
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends git locales htop curl tmux net-tools && \
    locale-gen en_US.UTF-8 && \
    mkdir /root/project && \
    code-server --install-extension mgmcdermott.vscode-language-babel && \
    code-server --install-extension humao.rest-client && \
    code-server --install-extension ms-azuretools.vscode-docker && \
    code-server --install-extension eamodio.gitlens
WORKDIR /root/project
EXPOSE 8443
ENTRYPOINT ["code-server"]