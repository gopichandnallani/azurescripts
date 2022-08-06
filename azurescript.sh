RG=development
zone=eastus
vnet=${RG}
subnet=${vnet}-subnet
nsgname=${RG}-${zone}-nsg
nsgrule=${nsgname}-rule
vmname=${vnet}-vm

echo "creating resource group $RG"
az group create -l ${zone} -n ${RG}

echo "creating VNET $vnet"
az network vnet create -n ${vnet} -g ${RG} --address-prefix 10.1.0.0/16 \
--subnet-name ${subnet}-1 --subnet-prefix 10.1.1.0/24 

echo "subnet cretaing....."
az network vnet subnet create --address-prefixes 10.1.1.0/24 -n ${subnet}-1 -g ${RG} --vnet-name ${vnet}
az network vnet subnet create --address-prefixes 10.1.2.0/24 -n ${subnet}-2 -g ${RG} --vnet-name ${vnet}
az network vnet subnet create --address-prefixes 10.1.3.0/24 -n ${subnet}-3 -g ${RG} --vnet-name ${vnet}
echo "NSG creating...."
az network nsg create --name ${nsgname} -g ${RG} --location ${zone} 

echo "nsg rule creating...."
az network nsg rule create --name ${nsgrule} --nsg-name ${nsgname} -g ${RG} --priority 100 --source-address-prefixes '*' \
--destination-address-prefixes '*' --source-port-ranges '*' --destination-port-ranges '*' \
--protocol Tcp --access allow --description "allowing all the traffic"

echo "VM creating....s"
az vm create --name ${RG}-vm --location ${zone} --image UbuntuLTS --vnet-name ${vnet} --subnet ${subnet}-1 --public-ip-sku Standard \
-g ${RG} --admin-username gopichand --admin-password "world@123456" --size Standard_B1s --nsg ${nsgname}