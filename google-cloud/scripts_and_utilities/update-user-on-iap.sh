#!/bin/bash

declare -a NEW_EMAILS=(risbonyasse@gmail.com boris@blockchainpourtous.com)


echo "--> Clean all previous emails from IAP"
for email in $(gcloud iap web get-iam-policy --resource-type=app-engine --format='json(bindings)' | jq '.bindings[].members')
do  
    cleanEmail=$(echo $email | sed 's/,/ /g' | tr -d '"') 
    [[ $cleanEmail == *"user:"* ]] &&  echo " remove policy for $cleanEmail"  &&  gcloud iap web remove-iam-policy-binding --resource-type=app-engine --member=$cleanEmail --role='roles/iap.httpsResourceAccessor'
done

echo "--> Add new emails"
for email in "${NEW_EMAILS[@]}"
do
    echo " add iam policy binding for $email"  &&  gcloud iap web add-iam-policy-binding --resource-type=app-engine --member=user:$email --role='roles/iap.httpsResourceAccessor'
done