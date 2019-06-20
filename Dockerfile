FROM node:latest

ENV CSVERSION=1.1156-vsc1.33.1
ENV CODESERVER=https://github.com/codercom/code-server/releases/download/${CSVERSION}/code-server${CSVERSION}-linux-x64.tar.gz \
    VSCODE_EXTENSIONS="/root/.local/share/code-server/extensions" \
    LC_ALL=en_US.UTF-8      \
    LANG=en_US.UTF-8        \
    LANGUAGE=en_US.UTF-8    \
    DISABLE_TELEMETRY=true

RUN apt-get update -y &&  \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends git locales htop curl wget tmux bsdtar net-tools gzip unzip && \
    locale-gen en_US.UTF-8 && \
    mkdir /root/project

WORKDIR /tmp

RUN mkdir -p ${VSCODE_EXTENSIONS}/babelextension && \
    wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/mgmcdermott/vsextensions/vscode-language-babel/latest/vspackage --output-document=preview.zip.gz && \
    gunzip preview.zip.gz && unzip preview.zip && mv extension ${VSCODE_EXTENSIONS}/babelextension && rm -rf *

RUN mkdir -p ${VSCODE_EXTENSIONS}/eslintextextension && \
    wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/dbaeumer/vsextensions/vscode-eslint/latest/vspackage --output-document=preview.zip.gz && \
    gunzip preview.zip.gz && unzip preview.zip && mv extension ${VSCODE_EXTENSIONS}/eslintextextension && rm -rf *

RUN mkdir -p ${VSCODE_EXTENSIONS}/restclientextension && \
    wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/humao/vsextensions/rest-client/latest/vspackage --output-document=preview.zip.gz && \
    gunzip preview.zip.gz && unzip preview.zip && mv extension ${VSCODE_EXTENSIONS}/restclientextension && rm -rf *

RUN mkdir -p ${VSCODE_EXTENSIONS}/dockerextension && \
    wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-azuretools/vsextensions/vscode-docker/latest/vspackage --output-document=preview.zip.gz && \
    gunzip preview.zip.gz && unzip preview.zip && mv extension ${VSCODE_EXTENSIONS}/dockerextension && rm -rf *

RUN mkdir -p ${VSCODE_EXTENSIONS}/gitblameextension && \
    wget https://marketplace.visualstudio.com/_apis/public/gallery/publishers/waderyan/vsextensions/gitblame/latest/vspackage --output-document=preview.zip.gz && \
    gunzip preview.zip.gz && unzip preview.zip && mv extension ${VSCODE_EXTENSIONS}/gitblameextension && rm -rf *

ADD $CODESERVER code-server.tar
RUN mkdir -p code-server && \
    tar -xf code-server.tar -C code-server --strip-components 1 && \
    cp code-server/code-server /usr/local/bin && \
    rm -rf code-server* && \
    apt-get remove bsdtar gzip unzip -y --allow-remove-essential

WORKDIR /root/project
EXPOSE 8443
ENTRYPOINT ["code-server"]