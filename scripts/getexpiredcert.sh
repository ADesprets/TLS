#!/bin/bash
# Programm to identify expired certificates or about to expire certificates
# Author: Arnauld Desprets help appreciated Pierre Richelle
# email: arnauld_desprets@fr.ibm.com
# Version: 2.0
# CreateDate: 10th Feb 2021
# UpdatedDate: 13th Jan 2022
# Arg: $1 namespace (required): The namespace containing the secrets
# Arg: $2 expiry_duration (optional): The duration in days before it expires (default 7 days if not indicated)
# Arg: $3 -v (optional): to display the valid certificate information
usage="getexpiredcert.sh apic 60"
# ########### start validation arguments ############
if [ $# -gt 2 ]
then
  echo "Too many arguments. Usage: $usage"
  exit 0
fi
if [ $# -eq 0 ]
then
  echo "Need at least one argument. Usage: $usage"
  exit 0
fi
namespace=$1
# Default value for duration
expiry_duration=7
intregex='^[0-9]+$'
if ! [[ $2 =~ $intregex ]] ; then
  echo "Duration in days must be an integer. Usage: $usage"
  exit 0
else
  expiry_duration=$2
fi
# ########### end validation arguments ############
# Initialisation
echo "# file generated to delete secrets including expired certificates" > deleteTlSSecret.sh


exp_dur_sec=$((expiry_duration * 86400))
echo "Checks certificates in $namespace namespace that will be expired in $expiry_duration days"

# Get all the secrets inside the namespace
tls_secrets=$(kubectl get secret -n $namespace --field-selector type=kubernetes.io/tls --no-headers=true | awk {'print $1'})
for tls_secret in $tls_secrets
do
  echo 'checking tls secret: ' $tls_secret
  # get the data object value that describes the certificates (need to be parsed)
  secret_certs=$(kubectl get secret $tls_secret -n $namespace  -o jsonpath='{.data}')

  # use regex experession to filter by key *.crt
  secret_certs=$(echo $secret_certs | jq 'with_entries(if (.key|test(".*.crt$")) then ( {key: .key, value: .value } ) else empty end )')

  # echo "secret cert: $secret_certs"
  
  echo $secret_certs | jq -r -c '.[]' | while read cert;
    do
       # echo $cert
      check_expiry=$(echo $cert | base64 --decode | openssl x509 -noout -checkend $exp_dur_sec)
      expired_code=$?
      expiry_date=$(echo $cert | base64 --decode | openssl x509 -noout -enddate)
      # echo $expiry_date
      expiry_date=${expiry_date#"notAfter="}
      if [ $expired_code -eq 1 ]
      then
      	echo "**** $tls_secret : $certname -- Expired : $expiry_date"
        echo "kubectl delete secret $tls_secret -n $namespace" >> deleteTlSSecret.sh
      else
        echo "$tls_secret : $certname -- Valid : $expiry_date"
      fi
    done
done
exit 0
