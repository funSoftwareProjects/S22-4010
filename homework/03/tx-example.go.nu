  1: ...
  2: type TransactionType struct {
  3:     TxOffset       int               // The position of this in the block.
  4:     Input          []TxInputType     // Set of inputs to a transaction
  5:     Output         []TxOutputType    // Set of outputs to a tranaction
  6:     SCOwnerAccount addr.AddressType  // Used in HW 6 - Smart Contracts - Owner of Contract
  7:     SCAddress      addr.AddressType  // Used in HW 6 - Smart Contracts - Address of Contract
  8:     SCOutputData   string            // Used in HW 6 - Smart Contracts - Output data from contract
  9:     Account        addr.AddressType  //
 10:     Signature      lib.SignatureType //    Used in HW 5 - Signature that this is a valid tranaction for this account
 11:     Message        string            //    Used in HW 5 - Message (hash of original) that signature signs for
 12:     Comment        string            //
 13: }
 14: 
 15: type TxInputType struct {
 16:     BlockNo     int // Which block is this from
 17:     TxOffset    int // The transaction in the block. In the block[BlockHash].Tx[TxOffset]
 18:     TxOutputPos int // Position of the output in the transaction. In the  block[BlockHash].Tx[TxOffset].Output[TxOutptuPos]
 19:     Amount      int // Value
 20: }
 21: 
 22: type TxOutputType struct {
 23:     BlockNo     int              // Which block is this in
 24:     TxOffset    int              // Which transaction in this block.  block[this].Tx[TxOffset]
 25:     TxOutputPos int              // Position of the output in this block. In the  block[this].Tx[TxOffset].Output[TxOutptuPos]
 26:     Account     addr.AddressType // Acctount funds go to (If this is ""chagne"" then this is the same as TransactionType.Account
 27:     Amount      int              // Amoutn to go to accoutn
 28: }
 29: ...
