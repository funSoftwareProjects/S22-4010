
m4_include(../../../setup.m4)

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

Let's say we want to build a document system for a law office.  This is a system
where the lawyers can take digital evidence and upload it to a system that tracks
it with a description and a case number - and signs - and attests to the authenticity
of the evidence.

So... We have to have some metadata that we track.   This is the case number and
case description and the description of the document.  We have to have the document
that we upload and save.  Then we hash the document and save the hash on chain
so that we can prove date/time/name/content of the document in a court of law.

## Let's draw a model of this...

## Server to save the metadata

```
/api/doc/law_cases
```

1. GET - retrieves a list cases
1. POST - inserts a new case
1. PUT - updates a case - saving a history of the case.
1. DELETE - marks a case as deleted

```
/api/doc/law_cases/ID
```

1. GET - Returns a single case.


```
/api/doc/law_doument?case_id=ID
```

1. GET - retrieves a list of metadata items for a case.
1. POST - inserts a new metadata item on a case.
1. PUT - updates a metadata item on a case - saving a history of the item.
1. DELETE - marks an item deleted.

```
/api/doc/law_doument?case_id=ID&item_id=ID2
```

1. GET - Returns a single item from a single case.


```
/uplaod
```

Takes a file and uploads it and returns an FILE_ID and a HASH_FILE for the
file.  The file is stored on the server.  In a real system we would need to
encrypt the file and copy it to something like Amazon S3 so that we have a
"permanent" copy of it.

We create a "key" for every case.  We "sign" every document with the key.
We keep a "signature" for the documents on chain.

```
/fetch_file?file_id=fid
```

gets a file back based on id.

```
/fetch_file?hash_file=hash
```

gets a file back based on its hash.


In PostgreSQL the tables for this:

```
m4_include(law.sql.nu)
```


