  1: package main
  2: 
  3: import (
  4:     "context"
  5:     "crypto/ecdsa"
  6:     "fmt"
  7:     "log"
  8:     "math/big"
  9:     "os"
 10:     "time"
 11: 
 12:     "github.com/ethereum/go-ethereum/accounts/abi/bind"
 13:     "github.com/ethereum/go-ethereum/common"
 14:     "github.com/ethereum/go-ethereum/crypto"
 15:     "github.com/ethereum/go-ethereum/ethclient"
 16:     "github.com/robfig/cron"
 17:     log "github.com/sirupsen/logrus"
 18: 
 19:     kv "github.com/Univ-Wyo-Education/S22-4010/class/lect/37/eth/contracts"
 20: )
 21: 
 22: func init() {
 23:     log.SetLevel(log.InfoLevel)
 24:     log.SetFormatter(&log.TextFormatter{FullTimestamp: true})
 25: }
 26: 
 27: func main() {
 28:     log.Info("Create new cron")
 29:     c := cron.New()
 30:     c.AddFunc("0 0 * * *", func() {
 31:         log.Info("[Job 1]Every day at midnight\n")
 32:         callContract()
 33:     })
 34: 
 35:     // Start cron with one scheduled job
 36:     log.Info("Start cron")
 37:     c.Start()
 38:     time.Sleep(1 * time.Minute)
 39: }
 40: 
 41: func callContract() {
 42: 
 43:     // client, err := ethclient.Dial("https://rinkeby.infura.io")
 44:     client, err := ethclient.Dial("http://127.0.0.1:8545")
 45:     if err != nil {
 46:         log.Fatal(err)
 47:     }
 48: 
 49:     privateKey, err := crypto.HexToECDSA(os.Getenv("PrivateKey_for_127"))
 50:     if err != nil {
 51:         log.Fatal(err)
 52:     }
 53: 
 54:     publicKey := privateKey.Public()
 55:     publicKeyECDSA, ok := publicKey.(*ecdsa.PublicKey)
 56:     if !ok {
 57:         log.Fatal("cannot assert type: publicKey is not of type *ecdsa.PublicKey")
 58:     }
 59: 
 60:     fromAddress := crypto.PubkeyToAddress(*publicKeyECDSA)
 61:     nonce, err := client.PendingNonceAt(context.Background(), fromAddress)
 62:     if err != nil {
 63:         log.Fatal(err)
 64:     }
 65: 
 66:     gasPrice, err := client.SuggestGasPrice(context.Background())
 67:     if err != nil {
 68:         log.Fatal(err)
 69:     }
 70: 
 71:     auth := bind.NewKeyedTransactor(privateKey)
 72:     auth.Nonce = big.NewInt(int64(nonce))
 73:     auth.Value = big.NewInt(0)     // in wei
 74:     auth.GasLimit = uint64(600000) // in units
 75:     auth.GasPrice = gasPrice
 76: 
 77:     address := common.HexToAddress(cfg.Addrs["KVPair"])
 78:     instance, err := kv.NewKVPair(address, client)
 79:     if err != nil {
 80:         log.Fatal(err)
 81:     }
 82: 
 83:     // Setup to call function that is a tranaction (requires gas) and changes data.
 84: 
 85:     key := [32]byte{}
 86:     value := [32]byte{}
 87:     copy(key[:], []byte("hello"))
 88:     copy(value[:], []byte("world"))
 89: 
 90:     tx, err := instance.SetKVPair(auth, key, value)
 91:     if err != nil {
 92:         log.Fatal(err)
 93:     }
 94: 
 95:     fmt.Printf("tx sent: %s\n", tx.Hash().Hex())
 96: 
 97:     time.Sleep(1 * time.Minute) // wait for data to be on-chain
 98: 
 99:     result, err := instance.TheData(nil, key)
100:     if err != nil {
101:         log.Fatal(err)
102:     }
103: 
104:     fmt.Printf("Key Lookup: %s\n", result) // "world"
105: }
