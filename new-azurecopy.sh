RG=Testing
zone=eastus2
vnet=${RG}
subnet=${RG}-subnet
nsgname=${RG}-${zone}-nsg
nsgrule=${nsgname}-rule
vmname=${RG}-vm

echo "creating resource group $RG"
az group create -l ${zone} -n ${RG}


echo "creating VNET vnet"
az network vnet create -n ${vnet} -g ${RG}  --address-prefix 192.168.0.0/16 \
--subnet-name ${subnet}-1 --subnet-prefix 192.168.1.0/24 

echo "subnet cretaing....."
az network vnet subnet create --address-prefixes 192.168.2.0/24 -n ${subnet}-2 -g ${RG} --vnet-name ${vnet}
az network vnet subnet create --address-prefixes 192.168.3.0/24 -n ${subnet}-3 -g ${RG} --vnet-name ${vnet}

echo "NSG creating...."
az network nsg create --name ${nsgname} -g ${RG} 

echo "nsg rule creating...."
az network nsg rule create --name ${nsgrule} --nsg-name ${nsgname} -g ${RG} --priority 100 --source-address-prefixes '*' \
--destination-address-prefixes '*' --source-port-ranges '*' --destination-port-ranges '*' \
--protocol Tcp --access allow --description "allowing all the traffic"

echo "VM creating...."
az vm create --name ${vnet}-vm --location ${zone} --image UbuntuLTS --vnet-name ${vnet} --subnet ${subnet}-1 --public-ip-sku Standard \
-g ${RG} --admin-username gopichand --admin-password "world@123456" --size Standard_B1s --nsg ${nsgname}

echo "VM creating...."
az vm create --name webserver-2 --zone 2 --image UbuntuLTS --vnet-name test-vnet --subnet subnet-2 \
-g Testing-RG --admin-username testuser --admin-password "India@123456" --size Standard_B1s --nsg test-nsg --custom-data ./clouddrive/cloud-init.txt

echo "VM creating...."
az vm create --name webserver-3 --zone 3 --image UbuntuLTS --vnet-name test-vnet --subnet subnet-3 \
-g Testing-RG --admin-username testuser --admin-password "India@123456" --size Standard_B1s --nsg test-nsg --custom-data ./clouddrive/cloud-init.txt
