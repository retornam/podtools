FROM ubuntu:focal

LABEL "NAME"="podtools"
LABEL "VERSION"="0.0.1"
LABEL maintainer="retornam@noreply.users.github.com"
ENV \ 
 HELM_VERSION=2.16.6 \
 KUBECTL_VERSION=1.17.4 \
 STERN_VERSION=1.11.0 \
 
 COMPLETIONS_DIR=/usr/share/bash-completion/completions

ADD profile /home/deployer/.oprofile
ADD https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/wercker/stern/releases/download/${STERN_VERSION}/stern_linux_amd64 /usr/local/bin/stern

RUN apt-get update -yq \
  && apt-get install -yq \
  ca-certificates \
  curl \
  git \
  jq \
  netcat \
  vim \
  wget \
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
  && mv /tmp/linux-amd64/tiller /usr/local/bin/ \
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
