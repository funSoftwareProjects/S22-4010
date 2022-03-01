  1: package config
  2: 
  3: import (
  4:     "encoding/json"
  5:     "fmt"
  6:     "io/ioutil"
  7:     "os"
  8: 
  9:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/addr"
 10:     "github.com/Univ-Wyo-Education/S22-4010/homework/03/bsvr/lib"
 11: )
 12: 
 13: type InitialAccountType struct {
 14:     AcctStr string
 15:     Value   int
 16:     Acct    addr.AddressType `json:"-"` // Converted from AcctStr above with validation.
 17: }
 18: 
 19: // GlobalConfigData is the gloal configuration data.
 20: // It holds all the data from the cfg.json file.
 21: type GlobalConfigData struct {
 22:     DataDir          string
 23:     MiningReward     int
 24:     MiningDifficulty string // "MiningDifficulty":"0"
 25:     InitialAccounts  []InitialAccountType
 26:     MiningRewardAcct string
 27:     AcctCoinbase     addr.AddressType `json:"-"`
 28:     ControlAcct      string
 29:     AcctPin          map[string]string // map from 0x00000 -> PIN for auth to use.
 30: }
 31: 
 32: var gCfg GlobalConfigData // global configuration data.
 33: 
 34: // ReadConfig will read a configuration file into the global congiguration structure.
 35: func ReadConfig(filename string) (err error) {
 36:     // Create Defaults
 37:     gCfg.MiningDifficulty = "0000"
 38: 
 39:     var buf []byte
 40:     buf, err = ioutil.ReadFile(filename)
 41:     if err != nil {
 42:         // TODO - xyzzy
 43:     }
 44:     err = json.Unmarshal(buf, &gCfg)
 45:     if err != nil {
 46:         fmt.Fprintf(os.Stderr, "Invalid initialization - Unable to parse JSON file, %s\n", err)
 47:         os.Exit(1)
 48:     }
 49:     for ii, aa := range gCfg.InitialAccounts {
 50:         if !lib.IsValidAddress(aa.AcctStr) {
 51:             fmt.Fprintf(os.Stderr, "Invalid initialization - invalid account at [%d] value [%s] in list of initial account values\n", ii, aa.AcctStr)
 52:             os.Exit(1)
 53:         }
 54:         tmp, _ := lib.ConvAddrStrToAddressType(aa.AcctStr)
 55:         aa.Acct = tmp
 56:         gCfg.InitialAccounts[ii] = aa
 57:         if aa.Value < 0 {
 58:             fmt.Fprintf(os.Stderr, "Invalid initialization - invalid alue at [%d] value [%d] in list of initial account values\n", ii, aa.Value)
 59:             os.Exit(1)
 60:         }
 61:     }
 62:     tmp, err := lib.ConvAddrStrToAddressType(gCfg.MiningRewardAcct)
 63:     if err != nil {
 64:         fmt.Fprintf(os.Stderr, "Invalid initialization - invalid account for MiningRewardAcct value [%s]\n", gCfg.MiningRewardAcct)
 65:         os.Exit(1)
 66:     }
 67:     gCfg.AcctCoinbase = tmp
 68:     return err
 69: }
 70: 
 71: // GetGlobalConfig returns a copy of the global config structure.
 72: func GetGlobalConfig() (rv GlobalConfigData) {
 73:     return gCfg
 74: }
