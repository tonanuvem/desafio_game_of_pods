#!bash

# corrigir a configuração do ARQUIVO ./kube/config para a PORTA 6443
echo "Configuração do ARQUIVO ./kube/config para a PORTA 6443"
echo "cat /root/.kube/config | grep server"
cat ./.kube/config | grep server
# ex:    server: https://172.17.0.66:2379
echo 'Digite o IP que aparece acima (ex: 172.17.0.66)'
read IP_CLUSTER
sed -i 's|server: https:.*|server: https://'$IP_CLUSTER':6443|' /root/.kube/config
#sed -i 's|server: https:.*|server: https:'"$IP_CLUSTER"':6443|' /root/.kube/config
cat ./.kube/config | grep server
echo "Digite ENTER para continuar..."
read OK

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
echo "O erro esta na configuracao errada no: /etc/kubernetes/manifests/kube-apiserver.yaml"
echo "esta apontando para o: /etc/kubernetes/pki/ca-authority.crt em vez : /etc/kubernetes/pki/ca.crt"
sed -i 's|server: https:.*|server: https://'$IP_CLUSTER':6443|' /root/.kube/config

# corrigir a configuração do COREDNS
