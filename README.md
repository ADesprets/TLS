<p align="center"><img src="./images/title-banner.png"</p>

This is work in progress as of 3rd July 2020 (first version)!!!!

# Introduction
This paper is an attempt to explain TLS. I have been asked this question many times so want to share my little knowledge on the subject. You will find here the basis of better understanding what is behind and the challenges to manage keys. This should help you to configure any product when using TLS.
# Fundamentals
## Symmetric encryption
### Principle and definitions
The principle with symmetric encryption is simply to use the same key to encrypt and decrypt the plain text. The value of the key used in the sample below is 6.

![Simple symmetric encryption terminology](./images/sym-key-enc.png)

To share information in a secure fashion...
* Sender and receiver must share a secret
* Nothing (or no-one) else must know this secret
* The information to be shared is protected by modifying its content with the secret "code"
* The process of protecting the information is called "encryption"
* The process of recovering the information is called "decryption"
* Only the holders of the secret code will be able to make sense of the protected message

### Julius Caesar
Julius Caesar uses symmetric encryption to convey messages. The Caesar cipher is a simple substitution cipher in which each letter of the plaintext is rotated left or right by some number of positions down the alphabet.

Here is a sample of encrypting the message `hello caesar` with different keys:

![Simple symmetric encryption](./images/hello-caesar.png)

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
What we would like is to have a more powerful and more secured approach. That is what asymmetric encryption provides. Notice that the discovery of asymmetric algorithm requires a good level of knowledge in mathematics and it was only very recent studies that allowed for this. In 1874, there are some mentions of one-way functions by an English mathematician William Stanley Jevons, and it was just one small part to solve the all problem. The real discoveries were done from 1970. It was my intention to provide a very simple sample to explain asynchronous algorithm but after two hours of reading I failed to do that. Let's just mention one aspect of it, the use of Modular exponentiation using two large prime numbers. Anyway, asymmetric is based on a pair of keys, one called **public key** and one called **private key**. (From a mathematical perspective in most cases, this is an arbitrary selection, one playing a role or the other). The public key is shared with everyone - not just recipients, the private key is shared with no-one. The public and private keys are associated with one another but are not identical by definition. A public key may be associated with only one private key and vice versa.

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
* She will use Bob’s public key to encrypt the message.
* Alice then sends the encrypted message to Bob.
* Bob receives the encrypted message and decrypts it using his private key.
* From this, Bob is able to read the original message sent by Alice.

![Asymmetric encryption](./images/asym-encryption.png)

Alice wants to make sure the message was sent by Bob.
* Bob uses his private key to encrypt the message (in fact a hash of the message, but we will see that later).
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

Let's illustrate a hash function
What ever the lengths, the results have the same length. Changing a few characters change the results completely. This last property is what we use to improve performances of the signature scenario by hashing only a hash value of the original message instead of the full message. Of course, this is useful for signature and does not apply to encryption. (Hashing is a surjection, and we need to get the full message decrypted, not its hash!).

![Hashing](./images/hash.png)

Below illustrating the use of different SHA based algorithms on the same text will produce various lengths.

![SHA Hashing](./images/sha-hashing.png)

The common algorithms are SHA1, sha256, sha384, sha512, MD2, MD4, MD5, tigernnn,mn, ...

### Message Authentication Code MAC (HMAC)
hash code seeded with a secret


## Certificate
TO BE REVIEWED
### Certificate purpose
How does sender know the identity of recipient?
same distribution problem as earlier - secure distribution of identity instead of secret key
public-key cryptography resolves this issue with the inclusion of a trusted third party - known as a "Certificate Authority" (CA)
CA will vouch for the identity of the recipient and will present a certificate of authenticity to recipient
certificate is digitally signed by the CA and this digital signature forms the trust between sender and CA
recipient certificate contains its public key
sender simply collects the recipient's digital certificate, validates CA digital signature and extracts public key (see step 1 above)

subject - who does this certificate represent
signer - who says so
browsers etc. ship with some 50 "known" signing "Certificate Authorities

Digital certificates allow unique identification of an entity
SSL uses digital certificates for public-key cryptography
A digital certificate serves two purposes
* it establishes the owner’s identity
* it makes the owner's public key available

### Certificate content
A digital certificate contains specific pieces of information about the identity of the certificate owner and about the certificate authority
* owner's distinguished name (DN)
* owner's public key
* date of issue
* date of expiration
* issuer's distinguished name (the CA)
* issuer's digital signature

A certificate may be signed by its owner (self-signed certificate)

### Two methods for issuing certificates
* Client-side request
	* Client key pair is generated on client
	* Client creates a certificate request – this contains information about the client, such as the public key, name, email address
	* Request is signed by the client using private key and sent to a CA
	* CA identifies the client before issuing certificate
	* CA verifies if the signature in the request is valid, by decrypting signed request with attached public key
	* If client is authentic, then the certificate can be downloaded by client
* Server-side
	* The alternative method is to generate key pairs on the server
	* Problems: private key must be sent to the client, ensuring that that an unauthorised eavesdropper cannot access it whilst in transit
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

### CRL
What if a private key is exposed?
The key pair becomes invalid
The owner of the key pair may not continue using the key pair securely
The key pair is revoked and the associated certificate is placed on a "certificate revocation list" (CRL)
All users of digital certificates must check a trusted CRL before accepting a certificate
What if the certificate has expired?
The owner should request a new certificate


# TLS and SSL
## Netscape contribution
Here a small tribute to Netscape, an early player in Internet space. There are a few reasons why I want to do this tribute.
* They developed SSL
* They created the JavaScript language
* They were once a time dominant for Web Browsing
* They created the Mozilla organisation
* They reminds me a time when I was just out from university :-)

Wahoo, this is how big they change the world!

![Netscape Logo](./images/netscape-logo.png)

The genius idea of Netscape was that they combined simple ideas (math functions) together to make secure trusted messaging possible. Nothing is very difficult here (beside the mathematics behind asymmetric algorithms, or at least I feel it :-)). They only took one problem at a time and solve them with individual functions.

## Putting things together

## Understanding a Cipher Spec


sources
Wikipedia https://en.wikipedia.org/wiki/Public-key_cryptography


Acknowledgments: I want to give a small tribute to two colleagues who have retired from IBM UK a long time ago. They transmitted to me my passion for SSL. Thanks to John Owlett and Imran Tyabji.
