<p align="center"><img src="./images/title-banner.png"</p>

# Introduction
This paper is an attempt to explain TLS. You will find here the basis of better understanding what is behind and the challenges to manage keys. This should help you to configure any product when using TLS.
# Fundamentals
In this first chapter, I provide the building blocks needed to understand correctly how SSL (/TLS) is working. The very good idea around SSL is that the inventors used cryptographic methodology, mitigated risks and took in consideration performance at any steps so at the end SSL was both secured and fast.

## Symmetric encryption
### Principle and definitions
The principle with symmetric encryption is simply to use the same key to encrypt and decrypt the plain text. The value of the key used in the sample below is 6, and the algorithm is to rotate the letter (on the right or on the left).

![Simple symmetric encryption terminology](./images/sym-key-enc.png)

To share information in a secure fashion...
* Sender and receiver must share a secret
* Nothing (or no-one) else must know this secret
* The information to be shared is protected by modifying its content with the secret "code"
* The process of protecting the information is called "encryption"
* The process of recovering the information is called "decryption"
* Only the holders of the secret code will be able to make sense of the protected message

### Julius Caesar
Julius Caesar used symmetric encryption to convey messages. The Caesar cipher is a simple substitution cipher in which each letter of the plaintext is rotated left or right by some number of positions (key) down the alphabet.

Here is a sample of encrypting the message `hello caesar` with different keys:

![Simple symmetric encryption](./images/hello-caesar.png)

### The wheel of Thomas Jefferson
The future president of the United invented a more robust mechanism but also very simple.
The wheel are made of a good number (for example between 30 and 40, 36 for the original model) of small disks. Each disk gets the 26 letters of the alphabet in any order and different between each disk. Like with Caesar, you roll all the disks with a key (rotation mechanism).
The big advantage of this system is that now, you not only need to know the key (to rotate the disk correctly) but also get the same (physically) wheel used to encrypt the data, so a combination of what you know and what you have. Of course, it raises the challenge of distributing securely the wheel. The wheel of Jefferson was used under the name of M.94 by the United States army between 1924 and 1942.

![Jefferson wheel](./images/jefferson.jpg)

### Enigma
The famous Enigma machine, invented in 1918, is again an evolution following a measure and counter measure evolution. The problem with existing cryptographic system at the time, like with the wheel of Jefferson, is that using a pretty small amount of time a brute force attack can be done by a human. This concept is important, if the difference of time to encrypt and decrypt is small then the system is not efficient. One reason is that the value of confidential information usually decreases over time. Enigma is going to use the latest technology, and in particular the use of electricity and electro-mechanic in order to make the number of combinations very large (4,64 * 10^22). It is some ways similar to the wheel of Jefferson but where you had 26 different keys for each wheel, here using 3 rotors of 26 letters, the number is so large that a human would not be able to decipher the message especially with a brute force attack. One additional concept used in Enigma is also that the association between each letter change every time a letter is typed using the three rotors, which improves greatly the algorithm. Only Alan Turing was able to create a machine to perform automatic testing and brute attack.

![Enigma](./images/Enigma_1940.JPG)

### Secure distribution of secret keys is a challenge
Symmetric algorithms are simple, fast way of encrypting and decrypting, but have many challenges.
* How can a key be received by intended recipient without interference?
* Eavesdropper can modify or simply read secret key
* How can we be sure the intended recipient has received the secret key?
* Eavesdropper can read secret key and masquerade as intended recipient
* A sender of information will need to store a unique secret key for each recipient, this could easily become unmanageable

### Some symmetric algorithms
Below a non-exhaustive list of symmetric algorithms.
* Blowfish
* AES
* DES
* Triple DES
* Mars
* RC2
* RC4
* RC5
* Seal
* PKCS5Key
* PBKDF1 and PBKDF2(PKCS5Derived Key)

## Asymmetric encryption
As discussed in previous chapter, using a symmetric algorithm is beneficial for simplicity and performance, but somewhat limited in its usage.
What we would like is to have a more powerful and more secured approach. That is what asymmetric encryption provides. Notice that the discovery of asymmetric algorithm requires a good level of knowledge in mathematics and it was only very recent studies that allowed for this. In 1874, there are some mentions of one-way functions by an English mathematician William Stanley Jevons, and it was just one small part to solve the all problem. The real discoveries were done from 1970. It was my intention to provide a very simple sample to explain asynchronous algorithm but after two hours of reading I failed to do that. Let's just mention one aspect of it, the use of Modular exponentiation using two large prime numbers. Anyway, asymmetric encryption/signature is based on a pair of keys, one called **public key** and one called **private key**. (From a mathematical perspective in most cases, this is an arbitrary selection, one playing a role or the other). The public key is shared with everyone - not just recipients, the private key is shared with no-one. The public and private keys are associated with one another but are not identical by definition and should be "different enough" for better security (Not two successive prime numbers). A public key may be associated with only one private key and vice versa.

**Key pair generator algorithms** in common use:
* Blowfish
* DiffieHellman
* DSA
* AES
* DES
* TripleDES
* HmacMD5
* HmacSHA1
* Mars
* RC2
* RC4
* RSA
* Seal

Some asymmetric algorithms:
* 1 To be completed

## Signature / Encryption
With an asymmetric scenario, a message may be sent securely without the need to share a secret key
* Sender must collect the recipient's public key
* Sender protects a plaintext message by encrypting  with recipient's public key
* Sender sends the encrypted message to the intended recipient
* Only those who have access to the recipient's private key will be able to decrypt the message
* Recipient decrypts encrypted message with their private key and recovers the plaintext
* Sender is assured that only the recipient will understand secret message

Alice wants to communicate securely with Bob but she does not want anybody to read the messages.
* **She will use Bob’s public key to encrypt the message**.
* Alice then sends the encrypted message to Bob.
* Bob receives the encrypted message and decrypts it using his private key.
* From this, Bob is able to read the original message sent by Alice.

![Asymmetric encryption](./images/asym-encryption.png)

Alice wants to make sure the message was sent by Bob.
* **Bob uses his private key to sign (encrypt) the message** (in fact a hash of the message, but we will see that later).
* Bob then sends the message and the signature to Alice (the location of the signature will be discussed later).
* Alice receives the message and the signature, she uses Bob’s public key to validate the hash of the message.
* From this, if the validation is successful Alice is confident that this message comes from Bob, because he is the only one to have the private key associated to Bob's public key.

![Signature](./images/signature.png)

Let's look in more detail what does it mean to validate the signature. I need to introduce a new function (and a correlated one): Hash function and HMAC function.
One problem with asymmetric encryption/signature is that it is resource intensive. Creating a signature of the full message would be expensive. In order to avoid this we use the concept of hashing.

### One way Hash function
A hash function is what we called a one way function, in other words, a surjection. The great thing with hash function is that you know the length of the result, and another thing is that if you change one character of the input you get a complete different value. The name of the result is called the hash value.

Here is the mathematical definition of a surjection:

![Surjection](./images/surjection.png)

Let's illustrate a hash function. What ever the lengths, the results have the same length. Changing a few characters change the results completely. This last property is what we use to improve performances of the signature scenario by signing only a hash value of the original message instead of the full message. Of course, this is useful for signature and does not apply to encryption. (Hashing is a surjection, and we need to get the full message decrypted, not its hash!).

![Hashing](./images/hash.png)

Below illustrating the use of different SHA based algorithms on the same text will produce various lengths.

![SHA Hashing](./images/sha-hashing.png)

The common algorithms are SHA1, sha256, sha384, sha512, MD2, MD4, MD5, tigernnn,mn, ...

### Message Authentication Code MAC (HMAC)
HMAC is a variant of hashing, by adding a key it makes the overall process more secure, in simple terms, it is a hash code seeded with a secret.

### Putting things together for the signature part
Let's revisit the signature scenario taking in account the hashing.
So when Bob signed the message, what he really did was:
* Took a hash of the message
* Encrypted the hash with his private key
* Sent the message and the hash value
* Alice hashed the message she received
* She decrypted the value of the hash sent by Bob
* And she compared both values

![Full signature](./images/full-signature.png)

## Certificate
In the previous chapters, we assume that the identity Bob said something easy to define. But how does sender know the identity of recipient? And vice-versa how the recipient knows the identity of the sender. This is where the certificate comes to play.

### Certificate content
A **digital certificate** contains specific pieces of information about the **identity** of the certificate **owner** and about the **certificate authority**.
* The subject - who does this certificate represent
* Signer - who says so

Digital certificates allows unique identification of an entity. SSL uses digital certificates for public-key cryptography.
A digital certificate serves two purposes
* It establishes the owner’s identity
* It makes the owner's public key available

In more details, we find the following information.
* Owner's distinguished name (DN)
* Date of issue
* Date of expiration
* Issuer's distinguished name (the CA)
* Issuer's digital signature
* Serial number

### Certificate trust model - Certificates chain
One problem is how do we trust the information discussed earlier? Well simply following the same approach used for signature. The sender can sign the information contained in the certificate and provide the signature and the public key inside the certificate. We know, then, than only the sender could create this certificate and assured the data has not been tempered.

But we have the same distribution problem as earlier - secure distribution of identity instead of secret key. Again the public-key cryptography resolves this issue with the inclusion of a trusted third party - known as a "Certificate Authority" (CA)
* CA will vouch for the identity of the recipient and will present a certificate of authenticity to recipient
* certificate is digitally signed by the CA and this digital signature forms the trust between sender and CA
recipient certificate contains its public key
* sender simply collects the recipient's digital certificate, validates CA digital signature and extracts public key.

At then end, we have a chain of certificates. A certificate is signed with the private key associated to the public key of the signer provided with the signer certificate. And again, and again, etc ... Of course, there is an end, there is a special certificate, called a root certificate where the private key associated to the public key is the one used to sign this certificate. This is a certificate signed by its owner a self-signed certificate. Instead of having each certificate to trust, we only need to trust one level (at the minimum), it can be root, an intermediary or the top certificate. This is the reason why browsers ship with some 50 "known" signing "Certificate Authorities. Those certificate authorities follow a strict process to create the root and chain of certificates.

Usually the number of certificate in the chain is limited, around 3 or 4. Below a sample of the chain of certificates from the IBM cloud website (https://cloud.ibm.com/):

![Certificate chain from IBM Cloud web site](./images/ibm-cloud-certificate_chain.png)

Notice that Firefox has a very nice way of getting information on the certificate chain.

![Firefox certificates chain presentation](./images/fireFox_certificate-chain.png)

A quick study of the dates of each certificates allows you to understand the roll out phases needed to replace expired certificates. At the end of the day, it is important to have no expired certificates at any time.

![Rollout](./images/certificate-rollout.png)

There are many more information contained in the certificate that we will look at later.

### Two methods for issuing certificates
There are two ways to generate certificate.

* Client-side request
	* Client key pair is generated on client
	* Client creates a certificate request (CSR - Certificate signing Request) – this contains information about the client, such as the public key, name, email address
	* Request is signed by the client using private key and sent to a CA
	* CA identifies the client before issuing certificate
	* CA verifies if the signature in the request is valid, by decrypting signed request with attached public key
	* If client is authentic, then the certificate can be downloaded by client

* Server-side
	* The alternative method is to generate key pairs on the server
	* Problems: private key must be sent to the client, ensuring that that an unauthorized eavesdropper cannot access it whilst in transit
	* Distribution medium needs to be controlled - e.g. issue certificates for a small closed group of users and deliver personally on a smartcard

## PKI
A PKI system acts as a trusted third party authentication system. It issues digital certificates for the communication parties (for users and applications).

Some of its tasks are:
* Issuing of certificates
* Revoking of certificates
* Renewal of certificates
* Suspension and resumption of certificates
* Management of issued certificates
* Issuing a list of revoked certificates
* Protection of the private key

### Elements of a certification authority
* Certificate Authority – provides the stamp of authenticity on the certificate. It is this authority that clients must trust since the CA signs a certificate request with it private key
* Registration Authority – responsible for the registration process, which determines the authenticity of the client
* Certificate Repository – stores valid certificates that can be trusted
* Certificate Revocation List – stores certificates that are invalid and should not be trusted

### CRL and OCSP
What if a private key is exposed?
The key pair becomes invalid
The owner of the key pair may not continue using the key pair securely
The key pair is revoked and the associated certificate is placed on a "certificate revocation list" (CRL)
All users of digital certificates must check a trusted CRL before accepting a certificate
What if the certificate has expired?
The owner should request a new certificate.
OCSP stands for Online Certificate Status Protocol: instead of replicating the CRL from time to time, you have a direct call (real time) to a service that provide the status of the certificate (revoked or not). This is better, but this service usually is not free.

# TLS and SSL
## Netscape contribution
Here a small tribute to Netscape, an early player in Internet space. There are a few reasons why I want to do this tribute.
* They developed SSL
* They created the JavaScript language
* They were once a time dominant for Web Browsing
* They created the Mozilla organisation
* They reminds me a time when I was just out from university :-)

Wahoo, this is how big they changed the world!

![Netscape Logo](./images/netscape-logo.png)

The genius idea of Netscape was that they combined simple ideas (math functions) together to make secure trusted messaging possible. Nothing is very difficult here (beside the mathematics behind asymmetric algorithms, or at least I feel it :-)). They only took one problem at a time and solve them with individual functions.

## Putting things together
As discussed before, to create a secured channel, we need to encrypt the data for data protection, we need to make sure the sender (Bob) for authentication purpose is who he claims to be, we may need to make sure the receiver (Alice) is who he claims to be for authentication and on top of this it needs to be efficient.
As you must have understood by now, all these challenges are solved by the small pieces seen previously.
* Asymmetric algorithms are not efficient, so let's use symmetric to encrypt data
* Symmetric key are a problem to distribute, let's generate them every time in a secure manner
* We need to authenticate the server, let's use signature to exchange information along side the certificates of the sender
* We need to sign the message, we just sign small pieces of information and use a hash function
* etc ...

TLS is a client-server model defined by 2 series of protocols:
* TLS Handshaking (High cost): The client produces an encrypted premaster key and encrypts it with the public key of the server certificate. This information is encrypted a second time with the public key of the server (and not the public key of the server certificate) received in the Server Key Exchange message. One of the important purpose of the handshake is to generate the symmetric keys along the authentication of the parties.
* TLS Record: The Record Protocol takes messages to be transmitted, fragments the data into manageable blocks, optionally compresses the data, applies a MAC, encrypts, and transmits the result.

![Understanding a cipher specification](./images/TLS-protocole.png)

## Understanding a Cipher Spec
![Understanding a cipher specification](./images/cipher-spec.png)

## Key store and Trust store
So far we have discussed of the protocol, and interactions, but how do we store in a secure manner the private keys and public certificates?
Keys need to be protected and stored securely. Certificates need to be accessible when used during the SSL/TLS handshake.

There are several formats for the stores:
* pem - Base 64 encoding, may contains keys and certificates. Contains the following prefixes (line): For Key -----BEGIN PRIVATE KEY----- and -----END PRIVATE KEY-----". For Certificate -----BEGIN CERTIFICATE----- and -----END CERTIFICATE-----".
* pkcs11 (p11) - For cryptographic token such as HSM - Hardware Security Module, or Smart Card.
* pkcs12 (p12) - (Soft) file format for storing several cryptography objects
* pfx -
* arm - Base 64 encoding, contains several certificates
* crt - Base 64 encoding, contains only a certificate
* CMS (Certificate Management System)
* Key database (kdb)
* der - Binary encoding
* p7b - PKCS7 based store

To configure SSL/TLS, you need to add the server certificate if not present (or a parent in the chain of certificates) into the trust store of the client (red arrow).
If you use mutual SSL/TLS, you need to add the client certificate if not present (or a parent in the chain of certificates) on the trust store of the server (green arrow).

![Trust store and key store](./images/trust-key-stores.png)

## SSL/TLS versions
* SSL V1.0 - deprecated
* SSL V2.0 - deprecated
* SSL V3.0 - deprecated
* TLS V1.1 - deprecated
* TLS V1.2 - previous version used significantly
* TLS V1.3 - Current version

## Performances aspect
![Cipher specs performance impact](./images/cipher-spec-perfomance-comparison.png)

# SSL and TLS in practice

## Tooling: openssl, keytool, ikeyman, ...
To retrieve the certificate from a server
`openssl.exe s_client -showcerts -connect cloud.ibm.com:443`
To create Certificate Signing Request
`openssl req -new -newkey rsa:2048 -nodes -out servername.csr -keyout servername.key`

### Script to create a chain of certificate with 2 levels
It provides a lot of controls on how the certificates are created.

```
# This script is used to generate a chain of certificates with 2 levels
# File name: create-cert-chain.sh
# It generates p12 and pem files for the root and leaf certificates.
# The labels are specified with the option -name if you want to change it
# It is very likely that you will want to update the serverFQDN and serverShortName at least.
# You will also probably change the configuration used to build the DN of the certificates
# This link is pretty interesting though it is a different approach: https://www.golinuxcloud.com/openssl-create-certificate-chain-linux/

# serverFQDN=cp4i-apic-egw-event-gw-client-cp4i.cp4i-cluster-b34dfa42ccf328c7da72e2882c1627b1-0000.eu-de.containers.appdomain.cloud
serverFQDN=cp4i-apic-gw-gateway-cp4i.cp4i-cluster-b34dfa42ccf328c7da72e2882c1627b1-0000.eu-de.containers.appdomain.cloud
# serverShortName=cp4i-apic-egw-event-gw-client-cp4i
serverShortName=cp4i-apic-gw-gateway-cp4i

# First we start to generate several files used to generate keys and certificate later, you may have to configure the content

# generate password file used in several places
cat > password.txt << EOF
secretin
secretout
EOF

# generate password file used in several places, this file is used for converting the P12 into pem
# so the first line is the one to access the p12 (which is the second line of the password.txt)
cat > passwordout.txt << EOF
secretout
secretout
EOF

# generate root serial number file 
cat > root.ser << EOF
$(uuidgen)
EOF

# generate root certificate conf file
cat > root.conf << EOF
[ req ]
default_bits       = 2048
distinguished_name = req_DN
string_mask        = nombstr
prompt             = no

[ req_DN ]
C            = FR
ST           = Herault
L            = Montpellier
O            = IBM
OU           = APIC
CN           = rootca
emailAddress = admin@fr.ibm.com
EOF

# generate root extension file
cat > root.ext << EOF
extensions = x509v3

[ x509v3 ]
basicConstraints        = CA:true,pathlen:2
keyUsage                = digitalSignature,nonRepudiation,keyEncipherment,keyCertSign,cRLSign
extendedKeyUsage        = serverAuth,clientAuth,emailProtection,codeSigning,timeStamping
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer
authorityInfoAccess     = OCSP;URI:http://ocsp.mydummycompany.com/,caIssuers;URI:http://www.ca.mydummycompany.com/ca.html
crlDistributionPoints   = URI:http://www.ca.mydummycompany.com/myca.crl
nsComment               = "My Dummy Company Root CA"
EOF

# Generate private key for root certificate
openssl genrsa -aes256 -passout file:password.txt -out root.key 2048

# Generate certificate request for root certificate
openssl req -config root.conf -new -key root.key -passin file:password.txt -out root.csr

# Generate certificate for root certificate
openssl x509 -days 7200 -extfile root.ext -signkey root.key -CAserial root.ser -passin file:password.txt -in root.csr -req -out root.crt

# Generate PKC12 key store with the root certificate
openssl pkcs12 -export -in root.crt -inkey root.key -passin file:password.txt -name RootCertificate -out root.p12 -passout file:password.txt

# Debug information
# openssl req -in root.csr -noout -text

# Below all the configuration for the eaf certificate

# generate leaf serial number file 
cat > leaf.ser << EOF
$(uuidgen)
EOF

# generate leaf configuration file 
cat > leaf.conf << EOF
[ req ]
default_bits               = 2048
distinguished_name         = req_DN
string_mask                = nombstr
prompt                     = no

[ req_DN ]
C            = FR
ST           = Herault
L            = Montpellier
O            = IBM
OU           = APIC
CN           = server
emailAddress = eegadmin@fr.ibm.com
EOF

# Generate extension file (important here is the SAN)
cat > leaf.ext << EOF
extensions = x509v3

[ x509v3 ]
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature,nonRepudiation,keyEncipherment
extendedKeyUsage        = serverAuth,clientAuth
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer
authorityInfoAccess     = OCSP;URI:http://ocsp.mydummycompany.com/,caIssuers;URI:http://www.ca.mydummycompany.com/ca.html
crlDistributionPoints   = URI:http://www.ca.mydummycompany.com/myca.crl
subjectAltName          = DNS:$serverFQDN,DNS:$serverShortName
EOF

# Generate private key for leaf certificate
openssl genrsa -aes256 -passout file:password.txt -out leaf.key 2048

# Generate certificate request for leaf certificate
openssl req -config leaf.conf -new -key leaf.key -passin file:password.txt -out leaf.csr

# Generate certificate for leaf certificate
openssl x509 -days 1825 -extfile leaf.ext -CA root.crt -CAkey root.key -passin file:password.txt -CAserial leaf.ser -in leaf.csr -req -out leaf.crt

# It is important to put the root at the end
cat leaf.crt > chain.pem
cat root.crt >> chain.pem

# Generate PKC12 key store with the root certificate
# openssl pkcs12 -export -in leaf.crt -inkey leaf.key -CAfile root.crt -passin file:password.txt -name LeafCertificate -certfile chain.pem -out leafwithchain.p12 -passout file:password.txt
openssl pkcs12 -export -in leaf.crt -inkey leaf.key -CAfile chain.pem -passin file:password.txt -name LeafCertificate -chain -out leafwithchain.p12 -passout file:password.txt

# Generate several pem files with or without keys
openssl pkcs12 -in leafwithchain.p12 -out server-cert.pem -clcerts -passin file:passwordout.txt -passout file:passwordout.txt
openssl pkcs12 -in leafwithchain.p12 -out server-cert-signers.pem -cacerts -passin file:passwordout.txt -passout file:passwordout.txt -nokeys
# Perform some cleaning (most files are generated in this script)
rm chain.pem leaf.conf leaf.csr leaf.ext leaf.key leaf.ser passwordout.txt root.conf root.csr root.ext root.key root.ser

```

## Debugging
### In Kubernetes world
The following command will return the validity of a certificate
kubectl get secret <secret> -o yaml | grep "\.crt" | awk '{ print $2 }' | base64 --decode | openssl x509 -in - -text |grep Validity -A 2
![Debug Certificate validity](./images/debug-get-cert-validity.png)

Below a script to find expired or about to expire certificates:

```
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


```

# Scenario
## Ajouter TLS invocation API
## Utilisation du Certificate Manager
## Sécurisation d'un flux toolkit
## Sécurisation application designer

#Interesting link: https://www.ssllabs.com/ssl-pulse/

# Sources
Wikipedia https://en.wikipedia.org/wiki/Public-key_cryptography


Acknowledgments: I want to give a small tribute to two colleagues who have retired from IBM UK a long time ago. They transmitted to me my passion for SSL. Thanks to John Owlett and Imran Tyabji.
