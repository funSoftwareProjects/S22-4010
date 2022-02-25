...
type TransactionType struct {
	TxOffset       int               // The position of this in the block.
	Input          []TxInputType     // Set of inputs to a transaction
	Output         []TxOutputType    // Set of outputs to a tranaction
	SCOwnerAccount addr.AddressType  // Used in HW 6 - Smart Contracts - Owner of Contract
	SCAddress      addr.AddressType  // Used in HW 6 - Smart Contracts - Address of Contract
	SCOutputData   string            // Used in HW 6 - Smart Contracts - Output data from contract
	Account        addr.AddressType  //
	Signature      lib.SignatureType //	Used in HW 5 - Signature that this is a valid tranaction for this account
	Message        string            //	Used in HW 5 - Message (hash of original) that signature signs for
	Comment        string            //
}

type TxInputType struct {
	BlockNo     int // Which block is this from
	TxOffset    int // The transaction in the block. In the block[BlockHash].Tx[TxOffset]
	TxOutputPos int // Position of the output in the transaction. In the  block[BlockHash].Tx[TxOffset].Output[TxOutptuPos]
	Amount      int // Value
}

type TxOutputType struct {
	BlockNo     int              // Which block is this in
	TxOffset    int              // Which transaction in this block.  block[this].Tx[TxOffset]
	TxOutputPos int              // Position of the output in this block. In the  block[this].Tx[TxOffset].Output[TxOutptuPos]
	Account     addr.AddressType // Acctount funds go to (If this is ""chagne"" then this is the same as TransactionType.Account
	Amount      int              // Amoutn to go to accoutn
}
...
