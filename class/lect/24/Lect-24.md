

<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
.markdown-body {
	font-size: 12px;
}
.markdown-body td {
	font-size: 12px;
}
</style>


# Lecture 24 - Key Custodian

Last time we looked at a app that kept the keys in MetaMask (the hello world) 
with the user holding the private keys.

This has a number of problems that have to be dealt with.

1. System failure - did the person make backups of the keys
2. Loss of password to the keys - they are encrypted.  It is AES 128 encryption!
3. Theft of keys - poor security on individuals computers.
4. Inheritance - what happens to crypto when a person dies.
5. Know Your Customer - Money Laundering - how do you "know" your customer if all you have is an account number.
6. Limitations on what you can do - Document System, Disintermediation Tokens etc.

Your bank uses keys like this - but you don't know about it.

The alternative is to use a username/password system that we are all familiar with
and keep the keys for the user.

You loose the "distributed" nature of the blockchain - but gain all the features of
a client/server.

An example.  Document Attestation System.


