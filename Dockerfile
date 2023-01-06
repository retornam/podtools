FROM ubuntu:focal

LABEL "NAME"="podtools"
LABEL "VERSION"="0.0.2"
LABEL maintainer="retornam@noreply.users.github.com"
ENV \
 HELM_VERSION=3.10.3 \
 KUBECTL_VERSION=1.26.0 \
 STERN_VERSION=1.22.0 \

 COMPLETIONS_DIR=/usr/share/bash-completion/completions

ADD profile /home/deployer/.oprofile
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl

RUN apt-get update --fix-missing -yq \
  && apt-get install -yq \
  ca-certificates \
  curl \
  git \
  jq \
  netcat \
  ldap-utils \
  vim \
  wget \
  sudo \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  && curl -LO https://github.com/stern/stern/releases/download/v${STERN_VERSION}/stern_${STERN_VERSION}_linux_arm64.tar.gz \
  && tar -xvf stern_${STERN_VERSION}_linux_arm64.tar.gz \
  && rm -rf stern_${STERN_VERSION}_linux_arm64.tar.gz \
  && mv stern /usr/local/bin \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && echo 'tzdata tzdata/Zones/America select Los_Angeles' | debconf-set-selections \
  && DEBIAN_FRONTEND="noninteractive" apt-get install  -yq docker-ce \
  docker-ce-cli containerd.io docker-compose-plugin iputils-ping traceroute dnsutils\
  && cd /tmp \
  && useradd deployer --create-home --uid 7676 --gid 100 --groups sudo --shell /bin/bash \
  && chmod +x /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/stern \
  && echo "source .oprofile" >> ~/.bashrc \
  && kubectl completion bash > ${COMPLETIONS_DIR}/kubectl.sh \
  && stern --completion bash > ${COMPLETIONS_DIR}/stern.sh \
  && curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && tar zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && mv /tmp/linux-amd64/helm /usr/local/bin/ \
  && helm completion bash > ${COMPLETIONS_DIR}/helm.sh \
  && git clone https://github.com/ahmetb/kubectx \
  && mv /tmp/kubectx/kubectx /usr/local/bin/kubectx \
  && mv /tmp/kubectx/kubens /usr/local/bin/kubens \
  && mv /tmp/kubectx/completion/*.bash ${COMPLETIONS_DIR} \
  && git clone https://github.com/jonmosco/kube-ps1 \
  && cp kube-ps1/kube-ps1.sh /etc/profile.d/  \
  && kubectl config set-context kubernetes --namespace=default \
  && kubectl config use-context kubernetes \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apt/* \
  && apt-get clean -yq \
  && apt-get autoremove -yq

WORKDIR /home/deployer

ENTRYPOINT ["tail", "-f", "/dev/null"]
