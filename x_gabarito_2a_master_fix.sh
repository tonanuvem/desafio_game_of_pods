#!/bin/bash

# corrigir a configuração do ARQUIVO ./kube/config para a PORTA 6443
echo "Configuração do ARQUIVO ./kube/config para a PORTA 6443"
echo "cat /root/.kube/config | grep server"
cat /root/.kube/config | grep server
# ex:    server: https://172.17.0.66:2379
echo 'Digite o IP que aparece acima (ex: 172.17.0.66)'
read IP_CLUSTER
sed -i 's|server: https:.*|server: https://'$IP_CLUSTER':6443|' /root/.kube/config
#sed -i 's|server: https:.*|server: https:'"$IP_CLUSTER"':6443|' /root/.kube/config
cat ./.kube/config | grep server
echo "Digite ENTER para continuar..."
read OK

echo "--------"
# corrigir a configuração do API SERVER:
echo "Configuração do API SERVER"
echo "docker ps -a | grep apiserver"
docker ps -a | grep -E 'apiserver.*Exited'
# ex:    b0f77aa5b682        3de571b6587b           "kube-apiserver --..."   About a minute ago   Exited (1) About a minute 
echo 'Digite as 3 primeiras letras do ID Docker que aparece acima (ex: b0f77aa5b682)'
read ID_DOCKER
docker logs $ID_DOCKER
# error: unable to load client CA file: unable to load client CA file: open /etc/kubernetes/pki/ca-authority.crt: no suchfile or directory
echo "Digite ENTER para continuar..."
read OK
echo "O erro esta na configuracao errada no: /etc/kubernetes/manifests/kube-apiserver.yaml"
echo "esta apontando para o: /etc/kubernetes/pki/ca-authority.crt em vez : /etc/kubernetes/pki/ca.crt"
echo "cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ca-authority.crt"
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ca-authority.crt
#LINHA_ERRADA="- --client-ca-file=/etc/kubernetes/pki/ca-authority.crt"
#LINHA_CERTA="- --client-ca-file=/etc/kubernetes/pki/ca.crt"
#sed -i 's|.*--client-ca-file=/etc.*|    '$LINHA_CERTA'|' /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i 's|- --client-ca-file=/etc/kubernetes/pki/ca-authority.crt|- --client-ca-file=/etc/kubernetes/pki/ca.crt|' /etc/kubernetes/manifests/kube-apiserver.yaml
echo "Digite ENTER para continuar..."
read OK
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep ca.crt

echo "--------"
# corrigir a configuração do COREDNS
echo "O erro do DNS esta na configuracao errada da imagem definida"
echo "kubectl get all -n kube-system | grep coredns"
kubectl get all -n kube-system | grep coredns
echo "kubectl get deploy -n kube-system -o json | grep image"
kubectl get deploy -n kube-system -o json | grep image
echo "Voce vai precisar editar o arquivo e corrigir a linha da imagem para: "image":"k8s.gcr.io/coredns:1.3.1""
echo "Digite ENTER para continuar..."
read OK
kubectl edit -n kube-system deploy coredns
#kubectl patch -n kube-system deploy coredns -p '{"spec":{"template":{"spec":{"containers":{"image":"k8s.gcr.io/coredns:1.3.1"}}}}}'
#kubectl patch -n kube-system deploy coredns -p '{"spec":{"template":{"spec":{"containers":[{"name":"coredns2"}]}}}}'
kubectl get deploy -n kube-system -o json | grep image

echo "--------"
# corrigir a configuração do NODE01
# https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/
kubectl get nodes
echo "Digite ENTER para continuar..."
read OK
echo "O erro no node 01 que esta em modo manutencao. Vamos tirar"
kubectl uncordon node01
kubectl get nodes
echo "FIM..."
