
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


# Lecture 22 - risk transfer contract

## What is a Credit Default Swap

Let's say you purchase a bond from Turkey (sovereign debt) 
that pays 6% per year interest.  You put in $1 million
on a 5 year term.   So you are expecting to get $60,000.00
payed to you each year.

Only now it looks like Turkey may default on it's bonds.
To cover this "risk" you want insurance that if they
default that you get your million back.

This is called a "credit default swap" and you have to 
pay for this "insurance" or "risk transfer".  You pay
somebody willing to take the risk that Turkey defaults
and they give you your million (the swap) if there is
a "credit default".  Hence the name.

Last month the going rate was 6.77% per year for a 
credit default swap on Turkey's sovereign debt.  So
instead of you getting $60,000.00 a year in income
you now pay $7,700.00 a year to grantee that you get
your capital returned.

This is a good indicator of a country's risk - if the credit 
default swaps cost more than the yield on the bond then you 
have a "bad risk".

Your other option is to sell the bond.  Current the price for
Turkey $1 million bonds is around $782,000 - so you can loose
almost 1/4 million - and sell now, or you can take out insurance.

## Good money destroyers bad money

Turkey's internal velocity of the Lira has been drooping, while the
velocity of Euro's and the Dollar in Turkey has been rising.   Currently
around 40% of transactions are Dollar denominated in Turkey.  This is with
an inflation rate of 7.83% last month - that is an annualized rate of
over 100%.   What this probably means is that Turkey is going to loose
control of the national currency and end up being a Dollar denominated
country - there are a bunch of them around the world - like the Republic 
of Zimbabwe.

The rule to remember is that "good money will always destroy bad money".
This is totally true with crypto also.  If you have good and bad crypto
then all people will flee to a good crypto.

## Let's talk about a "Disintermediation" coin.

How about "beef".

| Location of Cow  | % Charged | profit |
|------------------|-----------|-------------------------------------------|
| cow/calf ranch   | 5.2%      | $1.47lb in 1974, $1.52 today.             |
| truck            | 8%        |                                           |
| backgrounder     | 6%        |                                           |
| truck            | 8%        |                                           |
| auction lot      | 7.5%      | (takes 2% to 3% of price of cow)          |
| truck            | 8%        |                                           |
| feed lot		   | 5%        |                                           |
| truck			   | 3%        |                                           |
| meat packer      | 4.8%      |                                           |
| cold storage     | 4.1%      |                                           |
| truck			   | 7%        |                                           |
| warehouse        | 5.1%      |                                           |
| truck			   | 6%        |                                           |
| retailer (store) | 5%		   | $2.91 in 1974, $6.52 today (ground beef). |
|                  | 		   | $18.24 a LB for steak                     |

Total risk is about 3% of cow dying, getting sick etc.

So add prime rate 1.2% + 3% = total risk/cost of beef should be 4.2%.

Observations:

1. The trucking companies make more than the rancher.
2. The banks make _way_ more than the rancher.
3. Most costs in the supply chain have gone down.
4. The "meat packer/cold storage" industry has consolidated (5 major packers)
5. Retailers run a 1% profit margin on a guaranteed sale.
6. Trucking has gotten "less" expensive.  Trucks are more fuel efficient - drivers are payed less.

How about disintermediation using a pre-purchase token.  Instead of organizing the
business around different layers - organize it around the product line.   The cow is
payed for at conception - and the entire lifetime of the cow is financed once.

Remove the "auction lot" completely.  A 2-3% saving and less shipping.

My best guess is that the banks are making $308.00 per cow, the 
rancher is making $28.41 per cow.  The backgrounder making $22.08.
The retail store $8.80.   Trucking makes (shipped 6 times) $76.91 or about
$11 per shipment per cow.   The "meat packer" making around $224.00.


## Searching Events on the Chain

Ethereum uses a bloom filter to index events to transactions.

### What is a "bloom" filter.


A bloom filter uses an input, 

```
	eventSignature := []byte("DataSet(bytes32,bytes32)")
```

and then takes multiple hashes of this into a bit set.  If all the bits are '1' for the
hashes then it is likely that the item can be found at that location.


### Code for Searching for Events.

The contract that generates an event:

```

```

The search  code in .go

```
  1: package main
  2: 
  3: // MIT Licensed -- Based on original code
  4: // https://goethereumbook.org/en/event-read/
  5: // the code has been fixed to work with 8.1 solc and Eth 1.10.x
  6: 
  7: import (
  8:     "context"
  9:     "fmt"
 10:     "log"
 11:     "math/big"
 12:     "strings"
 13: 
 14:     "github.com/ethereum/go-ethereum"
 15:     "github.com/ethereum/go-ethereum/accounts/abi"
 16:     "github.com/ethereum/go-ethereum/common"
 17:     "github.com/ethereum/go-ethereum/crypto"
 18:     "github.com/ethereum/go-ethereum/ethclient"
 19: 
 20:     gen_event "github.com/Univ-Wyo-Education/S22-4010/class/lect/22/scan-event/eth/contracts"
 21: )
 22: 
 23: // These are the values pulled in from ./cfg.json file.
 24: type GlobalConfig struct {
 25:     ContractAddress string   `json:"contract_address"`
 26:     ClientWSSUrl    string   `json:"client_wss_url"`
 27:     DbFlags         []string `json:"db_flags"`
 28: }
 29: 
 30: var gCfg GlobalConfig
 31: var DbOn map[string]bool = make(map[string]bool)
 32: 
 33: func main() {
 34: 
 35:     // --------------------------------------------------------------------------------------
 36:     // Read global config
 37:     // --------------------------------------------------------------------------------------
 38:     ReadJson("cfg.json", &gCfg)
 39:     if len(gCfg.DbFlags) > 0 {
 40:         for _, x := range gCfg.DbFlags {
 41:             DbOn[x] = true
 42:         }
 43:     }
 44: 
 45:     for _, k := range gCfg.DbFlags {
 46:         DbOn[k] = true
 47:     }
 48: 
 49:     if DbOn["dump-global-config"] {
 50:         fmt.Printf("Global Config:%s\n", SVarI(gCfg))
 51:     }
 52: 
 53:     client, err := ethclient.Dial(gCfg.ClientWSSUrl)
 54:     if err != nil {
 55:         log.Fatal(err)
 56:     }
 57: 
 58:     // --------------------------------------------------------------------------------------
 59:     // Process contract
 60:     // --------------------------------------------------------------------------------------
 61:     contractAddress := common.HexToAddress(gCfg.ContractAddress)
 62:     query := ethereum.FilterQuery{
 63:         FromBlock: big.NewInt(2394201),
 64:         ToBlock:   big.NewInt(2394201),
 65:         Addresses: []common.Address{
 66:             contractAddress,
 67:         },
 68:     }
 69: 
 70:     // --------------------------------------------------------------------------------------
 71:     // Search Chain / Logs
 72:     // --------------------------------------------------------------------------------------
 73:     logs, err := client.FilterLogs(context.Background(), query)
 74:     if err != nil {
 75:         log.Fatal(err)
 76:     }
 77: 
 78:     // Generated Code -- Pull in the ABI for the contract.  contractAbi, err := abi.JSON(strings.NewReader(string(gen_event.StoreABI)))
 79:     contractAbi, err := abi.JSON(strings.NewReader(string(gen_event.GenEventMetaData.ABI))) // xyzzy
 80:     if err != nil {
 81:         log.Fatal(err)
 82:     }
 83: 
 84:     for _, vLog := range logs {
 85:         fmt.Printf("0x%x\n", vLog.BlockHash.Hex()) // 0x3404b8c050aa0aacd0223e91b5c32fee6400f357764771d0684fa7b3f448f1a8
 86:         fmt.Printf("%v\n", vLog.BlockNumber)       // 2394201
 87:         fmt.Printf("0x%x\n", vLog.TxHash.Hex())    // 0x280201eda63c9ff6f305fcee51d5eb86167fab40ca3108ec784e8652a0e2b1a6
 88: 
 89:         event := struct {
 90:             Key   [32]byte
 91:             Value [32]byte
 92:         }{}
 93:         _, err := contractAbi.Unpack("DataSet", vLog.Data) // err := contractAbi.Unpack(&event, "DataSet", vLog.Data) // xyzzy
 94:         if err != nil {
 95:             log.Fatal(err)
 96:         }
 97: 
 98:         fmt.Printf("0x%x\n", string(event.Key[:]))
 99:         fmt.Printf("0x%x\n", string(event.Value[:]))
100: 
101:         var topics [4]string
102:         for i := range vLog.Topics {
103:             topics[i] = vLog.Topics[i].Hex()
104:         }
105: 
106:         fmt.Printf(topics[0]) // 0xe79e73da417710ae99aa2088575580a60415d359acfad9cdd3382d59c80281d4
107:     }
108: 
109:     eventSignature := []byte("DataSet(bytes32,bytes32)")
110:     hash := crypto.Keccak256Hash(eventSignature)
111:     fmt.Printf("%s\n", hash.Hex()) // 0xe79e73
112: }

```
