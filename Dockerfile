FROM codercom/code-server:latest

ENV VSCODE_EXTENSIONS="/root/.local/share/code-server/extensions" \
    LANG=en_US.UTF-8 \
    DISABLE_TELEMETRY=true

WORKDIR /
# Install dev dependencies
RUN apt-get update && apt-get install -y npm nodejs wget curl git bsdtar \
    && mkdir -p code-server \
    && locale-gen en_US.UTF-8 \
    && mkdir /root/project
RUN apt-get update && apt-get install -y libssl-dev libffi-dev python-dev apt-transport-https lsb-release software-properties-common node-typescript
RUN mkdir -p ${VSCODE_EXTENSIONS}/babelextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/mgmcdermott/vsextensions/vscode-language-babel/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/babelextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/eslintextextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/dbaeumer/vsextensions/vscode-eslint/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/eslintextextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/restclientextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/humao/vsextensions/rest-client/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/restclientextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/dockerextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/PeterJausovec/vsextensions/vscode-docker/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/dockerextension extension \
    && mkdir -p ${VSCODE_EXTENSIONS}/gitblameextension \
    && curl -JLs --retry 5 https://marketplace.visualstudio.com/_apis/public/gallery/publishers/waderyan/vsextensions/gitblame/latest/vspackage | bsdtar --strip-components=1 -xf - -C ${VSCODE_EXTENSIONS}/gitblameextension extension \
    && apt-get remove -y bsdtar

WORKDIR /root/project
EXPOSE 8443
ENTRYPOINT ["code-server"]