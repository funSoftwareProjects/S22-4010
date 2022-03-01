  1: package block
  2: 
  3: import (
  4:     "fmt"
  5:     "testing"
  6: )
  7: 
  8: func Test_GenesisBlock(t *testing.T) {
  9:     gb := InitGenesisBlock()
 10:     if !IsGenesisBlock(gb) {
 11:         t.Errorf("Should be genesis block")
 12:     }
 13: }
 14: 
 15: func Test_InitBlock(t *testing.T) {
 16:     bk := InitBlock(12, "Hello World", []byte{1, 2, 3})
 17:     if IsGenesisBlock(bk) {
 18:         t.Errorf("Should not be genesis block")
 19:     }
 20:     if bk.Index != 12 {
 21:         t.Errorf("Expected index of 12")
 22:     }
 23:     exp := "a5939c6b3f2c404798db8d78bc9de6d2839e8129a9c7ce5ea0c8abe4a35b2eee"
 24:     got := fmt.Sprintf("%x", bk.ThisBlockHash)
 25:     if exp != got {
 26:         t.Errorf("Block hash incorrect\nexpected: ->%s<-\nactual:   ->%s<-\n", exp, got)
 27:     }
 28: }
 29: 
 30: //
 31: func Test_SerializeBlock(t *testing.T) {
 32:     bk := InitBlock(12, "Good Morning 4010/5010 class", []byte{1, 2, 3, 4})
 33:     data := SerializeBlock(bk)
 34:     dataStr := fmt.Sprintf("%x", data)
 35:     testDataStr := "476f6f64204d6f726e696e6720343031302f3530313020636c61737301020304"
 36:     if dataStr != testDataStr {
 37:         t.Errorf("Invalid data for block\nexpected: ->%s<-\nactual:   ->%s<-\n", testDataStr, dataStr)
 38:     }
 39: }
 40: 
 41: //
 42: func Test_SerializeForSeal(t *testing.T) {
 43:     bk := InitBlock(12, "Good Morning 4010/5010 class", []byte{1, 2, 3, 4})
 44:     data := SerializeForSeal(bk)
 45:     dataStr := fmt.Sprintf("%x", data)
 46:     testDataStr := "476f6f64204d6f726e696e6720343031302f3530313020636c61737330647b743e55e60afab61e6d2e63da424bc11a1ccdd73295b9ea00825f4deda4010203040000000000000000"
 47:     if dataStr != testDataStr {
 48:         t.Errorf("Invalid data for block\nexpected: ->%s<-\nactual:   ->%s<-\n", testDataStr, dataStr)
 49:     }
 50: }
