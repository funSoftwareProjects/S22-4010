  1: package transactions
  2: 
  3: import (
  4:     "bytes"
  5:     "encoding/binary"
  6: 
  7:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/addr"
  8:     "github.com/Univ-Wyo-Education/S22-4010/homework/04/bsvr/lib"
  9: )
 10: 
 11: /*
 12: Transactions
 13: -------------------------------
 14: 
 15: In bitcoin and Ethereum you can send funds from one account to another.
 16: This activity is captured in a transaction.
 17: 
 18: */
 19: 
 20: type TransactionType struct {
 21:     TxOffset       int               // The position of this in the block.
 22:     Input          []TxInputType     // Set of inputs to a transaction
 23:     Output         []TxOutputType    // Set of outputs to a tranaction
 24:     SCOwnerAccount addr.AddressType  // Used in HW 6 - Smart Contracts - Owner of Contract
 25:     SCAddress      addr.AddressType  // Used in HW 6 - Smart Contracts - Address of Contract
 26:     SCOutputData   string            // Used in HW 6 - Smart Contracts - Output data from contract
 27:     Account        addr.AddressType  //
 28:     Signature      lib.SignatureType //    Used in HW 5 - Signature that this is a valid tranaction for this account
 29:     Message        string            //    Used in HW 5 - Message (hash of original) that signature signs for
 30:     Comment        string            //
 31: }
 32: 
 33: type TxInputType struct {
 34:     BlockNo     int // Which block is this from
 35:     TxOffset    int // The transaction in the block. In the block[BlockHash].Tx[TxOffset]
 36:     TxOutputPos int // Position of the output in the transaction. In the  block[BlockHash].Tx[TxOffset].Output[TxOutptuPos]
 37:     Amount      int // Value
 38: }
 39: 
 40: type TxOutputType struct {
 41:     BlockNo     int              // Which block is this in
 42:     TxOffset    int              // Which transaction in this block.  block[this].Tx[TxOffset]
 43:     TxOutputPos int              // Position of the output in this block. In the  block[this].Tx[TxOffset].Output[TxOutptuPos]
 44:     Account     addr.AddressType // Acctount funds go to (If this is ""chagne"" then this is the same as TransactionType.Account
 45:     Amount      int              // Amoutn to go to accoutn
 46: }
 47: 
 48: func NewEmptyTx(memo string, passedAcct addr.AddressType) *TransactionType {
 49:     return &TransactionType{
 50:         Input:          make([]TxInputType, 0, 1),  // Set of inputs to a transaction
 51:         Output:         make([]TxOutputType, 0, 1), // Set of outputs to a tranaction
 52:         SCOwnerAccount: []byte{},
 53:         SCAddress:      []byte{},
 54:         SCOutputData:   "",
 55:         Account:        passedAcct,
 56:         Signature:      lib.SignatureType([]byte{}),
 57:         Message:        "",
 58:         Comment:        memo,
 59:     }
 60: }
 61: 
 62: // SearalizeTransaction searializes into bytes the fields that will be hashed the hash of the block.
 63: // This is the hash that the next block will use to point to this block and the hash that
 64: // this block will be saved as.
 65: func SerializeTransaction(tx *TransactionType) []byte {
 66:     var buf bytes.Buffer
 67: 
 68:     for _, inp := range tx.Input {
 69:         SerializeTransactionInput(&buf, &inp)
 70:     }
 71:     for _, out := range tx.Output {
 72:         SerializeTransactionOutput(&buf, &out)
 73:     }
 74:     buf.Write([]byte(tx.SCOwnerAccount))
 75:     buf.Write([]byte(tx.SCAddress))
 76:     buf.Write([]byte(tx.SCOutputData))
 77:     buf.Write([]byte(tx.Account))
 78:     buf.Write([]byte(tx.Signature))
 79:     buf.Write([]byte(tx.Message))
 80:     buf.Write([]byte(tx.Comment))
 81: 
 82:     return buf.Bytes()
 83: }
 84: 
 85: // SearalizeForSeal searializes into bytes the fields that will be hashed for the mining seal.
 86: func SerializeForSeal(tx *TransactionType) []byte {
 87:     return SerializeTransaction(tx)
 88: }
 89: 
 90: func SerializeTransactionInput(buf *bytes.Buffer, inp *TxInputType) {
 91:     // binary.Write(buf, binary.BigEndian, inp.BlockNo)
 92:     // buf.Write([]byte(inp.BlockHash))
 93:     binary.Write(buf, binary.BigEndian, inp.BlockNo)
 94:     binary.Write(buf, binary.BigEndian, inp.TxOffset)
 95:     binary.Write(buf, binary.BigEndian, inp.TxOutputPos)
 96:     binary.Write(buf, binary.BigEndian, inp.Amount)
 97: }
 98: 
 99: func SerializeTransactionOutput(buf *bytes.Buffer, out *TxOutputType) {
100:     binary.Write(buf, binary.BigEndian, out.BlockNo)
101:     binary.Write(buf, binary.BigEndian, out.TxOffset)
102:     binary.Write(buf, binary.BigEndian, out.TxOutputPos)
103:     buf.Write([]byte(out.Account))
104:     binary.Write(buf, binary.BigEndian, out.Amount)
105: }
106: 
107: func CreateTxOutputWithFunds(to addr.AddressType, amount int) (txo *TxOutputType, err error) {
108:     txo = &TxOutputType{
109:         Account: to,
110:         Amount:  amount,
111:     }
112:     return
113: }
114: 
115: func AppendTxOutputToTx(tx *TransactionType, txo *TxOutputType) {
116:     txo.TxOutputPos = len(tx.Output)
117:     tx.Output = append(tx.Output, *txo)
118: }
119: 
120: func CreateTxInputsFromOldOutputs(oldOutput []*TxOutputType) (txIn []TxInputType, err error) {
121:     for _, vv := range oldOutput {
122:         txIn = append(txIn, TxInputType{
123:             BlockNo:     vv.BlockNo,
124:             TxOffset:    vv.TxOffset,
125:             TxOutputPos: vv.TxOutputPos,
126:             Amount:      vv.Amount,
127:         })
128:     }
129:     return
130: }
