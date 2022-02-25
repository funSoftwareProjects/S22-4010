
all:
	go build

FN1=UTC--2021-03-05T20-05-55.293635561Z--86BbDbf7FcF5f0596a3DE769B4F4b99B38EDC9Ed
PW1=T8SdFvWsu5WhYqpt

PW2=8zH6G7Ard6eeQXJ5
FN2=UTC--2021-03-05T20-08-04.951958492Z--cE39067dFdc05d0bB560d7e9a2fD5A9cE9Fc85b9

sign1: 
	echo "Password Is ${PW1} - just type something (should not be able to sign)"
	./sig-test sign-message ${FN1} "some data to sign" .

sign2: 
	echo Password Is: ${PW2} Cut and Paste It
	./sig-test sign-message ${FN2} "some data to sign" .


#
# 4 prameters to verify-message
#
# 1. the accont address
# 2. the signature
# 3. the hash of the message itself
# 4. the message itself
#

d1=cE39067dFdc05d0bB560d7e9a2fD5A9cE9Fc85b9
h1=736f6d65206461746120746f207369676e
s1=a867a6940837d64a70b7060fc6f157aa66080fec17e3d5660d1efe96e5230b3931d19f122b0952e7d87436454a7ee6a29bb379869a8458214996d9ebe8a70e9c00
m1="some data to sign"

# Should Verify
verify1:
	./sig-test verify-message ${d1} ${s1} ${h1} ${m1}

# Should not verify
verify2:
	./sig-test verify-message 6E11C0aC0d8fEa2B53D70b32f9b01077a4B66A59 797a53a6886c5e0cd8e69e3ce43a041db49b86a403dcb3f751829eecd0cd48a41a41a7412cc61d58284bcec191ab4061e6f3de0a28fd71433da5367fac793d7e00 736f6d65206461746120746f207369676e ${m1}

# Should Verify
verify3:
	./sig-test verify-message 7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A 01886f5908a87a8fb58b69d4cdaf42987378131701454a7c5f40c26e093ecb9b41269db9951536a3e960ce90f57b7ccf441ab77f5abb11d1509b793008c8d83c00 7b2266726f6d223a22307837653361464563303438624337626537343564306641304635616639374433393738433430453941222c2022746f223a22307839643431653539333837363734363661663238383635653163333330373166313536316435376138222c2022616d6f756e74223a35357d '{"from":"0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A", "to":"0x9d41e5938767466af28865e1c33071f1561d57a8", "amount":55}'


