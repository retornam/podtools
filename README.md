# podtools


`podtools` contains a bunch of tools useful for working with Kubernetes:

- helm 
- kubens
- kubectl
- kubectx
- kube-ps1
- stern

## Usage

1. Deploy the pod:

   ```
   kubectl apply -f https://raw.githubusercontent.com/retornam/podtools/master/podtools.yaml
   ```

2. Attach to the pod:

   ```
   kubectl attach --namespace=podtools -ti podtools
   ```

