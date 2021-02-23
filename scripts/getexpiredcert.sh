#!/bin/bash
# Programm to identify expired certificates or about to expire certificates
# Author: Arnauld Desprets help appreciated Pierre Richelle
# email: arnauld_desprets@fr.ibm.com
# Version: 1.0
# Date: 10th Feb 2021
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
echo "# file generated to delete secrets including expired certificates" > delete-TLS-secrets.sh


exp_dur_sec=$((expiry_duration * 86400))
echo "Checks certificates in $namespace namespace that will be expired in $expiry_duration days"
# Get all the secrets inside the namespace
tls_secrets=$(kubectl get secret -n $namespace --field-selector type=kubernetes.io/tls --no-headers=true | awk {'print $1'})
for tls_secret in $tls_secrets
do
  # echo 'checking tls secret: ' $tls_secret
  # get the data object value that describes the certificates (need to be parsed)
  secret_certs=$(kubectl get secret $tls_secret -n $namespace  -o jsonpath='{.data}')
  # remove leading and trailing characters
  secret_certs=$(echo $secret_certs | cut -d '[' -f 2 | cut -d ']' -f 1)
  # ${secret_certs:4:-1}
  # separating each certificate
  for cert in $secret_certs
  do
    certname=$(echo $cert | awk -F ':' '{print $1}')
    # echo 'cert: ' $certname
    # this is a certificate if extension is crt
    ext=$(echo $certname | cut -d '.' -f 2)
    if [ $ext = "crt" ]
    then      # check expiration
      check_expiry=$(echo $cert | awk -F ':' '{print $2}' | base64 --decode | openssl x509 -noout -checkend $exp_dur_sec)
      expired_code=$?
      expiry_date=$(echo $cert | awk -F ':' '{print $2}' | base64 --decode | openssl x509 -noout -enddate)
      expiry_date=${expiry_date#"notAfter="}
      if [ $expired_code -eq 1 ]
      then
      	echo "**** $tls_secret : $certname -- Expired : $expiry_date"
        echo "kubectl delete secret $tls_secret -n $namespace" >> delete-TLS-secrets.sh
      else
        echo "$tls_secret : $certname -- Valid : $expiry_date"
      fi
    fi
  done
done
exit 0