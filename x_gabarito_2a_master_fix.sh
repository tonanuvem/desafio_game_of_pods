#!bash

# corrigir a configuração do ARQUIVO ./kube/config para a PORTA 6443
cat ./.kube/config | grep server
# ex:    server: https://172.17.0.66:2379
echo 'Digite o IP que aparece acima (ex: 172.17.0.66)'
read IP_CLUSTER
sed -i 's|server: https:.*:2379|server: https:'$IP_CLUSTER':6443|' /root/.kube/config

# corrigir a configuração do API SERVER:

# corrigir a configuração do COREDNS
