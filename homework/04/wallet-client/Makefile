
all:
	go build

# verify command line params work
test000: 
	./wallet-client --cmd echo

# verify server can respond
test001: 
	./wallet-client --cmd "server-status"


# test that we get back a list of accounts - probably just 1 in the list.
test002:
	./wallet-client --cmd list-accts

# get value of to account
test003:
	./wallet-client --cmd acct-value --acct 0x9d41e5938767466af28865e1c33071f1561d57a8

# Validate Signed Message
test004:
	./wallet-client --cmd validate-signed-message --acct 0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A \
		--password 78S2tAIfk4VP2xv2

# Send Funds with Signature
test005:
	go build
	./wallet-client --cmd send-funds-to --from 0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A \
		--password 78S2tAIfk4VP2xv2 --to 0x9d41e5938767466af28865e1c33071f1561d57a8 \
		--amount 55 --memo "memo:test005"


# get value of account (of the from account
test006:
	./wallet-client --cmd acct-value --acct 0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A 


# AT: File: /home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4010-a04/wallet-client/ins_main.go LineNo:44 raw msg ->{"from":"0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A", "to":"0x9d41e5938767466af28865e1c33071f1561d57a8", "amount":55}<-
# Match of Acct [7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A] to fn [UTC--2018-08-27T00-03-50.008098186Z--7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A]
# AT:File: /home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4010-a04/wallet-client/ins_main.go LineNo:54 msg ->7b2266726f6d223a22307837653361464563303438624337626537343564306641304635616639374433393738433430453941222c2022746f223a22307839643431653539333837363734363661663238383635653163333330373166313536316435376138222c2022616d6f756e74223a35357d<- keyFile ->wallet-data/UTC--2018-08-27T00-03-50.008098186Z--7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A<- password ->78S2tAIfk4VP2xv2<- sig ->01886f5908a87a8fb58b69d4cdaf42987378131701454a7c5f40c26e093ecb9b41269db9951536a3e960ce90f57b7ccf441ab77f5abb11d1509b793008c8d83c00<- acct ->0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A<- 
# Client-AT: File: /home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4010-a04/wallet-client/client-main.go LineNo:286, url=http://0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A:237801@127.0.0.1:9191/api/send-funds-to?from=0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A&to=0x9d41e5938767466af28865e1c33071f1561d57a8&amount=55&signature=01886f5908a87a8fb58b69d4cdaf42987378131701454a7c5f40c26e093ecb9b41269db9951536a3e960ce90f57b7ccf441ab77f5abb11d1509b793008c8d83c00&msg=7b2266726f6d223a22307837653361464563303438624337626537343564306641304635616639374433393738433430453941222c2022746f223a22307839643431653539333837363734363661663238383635653163333330373166313536316435376138222c2022616d6f756e74223a35357d&memo=memo%3Atest005

test007:
	./wallet-client --cmd acct-value --acct 0x7e3aFEc048bC7be745d0fA0F5af97D3978C40E9A 

