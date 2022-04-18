  1: # Open Auction
  2: 
  3: # Auction params
  4: # Beneficiary receives money from the highest bidder
  5: beneficiary: public(address)
  6: auctionStart: public(uint256)
  7: auctionEnd: public(uint256)
  8: 
  9: # Current state of auction
 10: highestBidder: public(address)
 11: highestBid: public(uint256)
 12: 
 13: # Set to true at the end, disallows any change
 14: ended: public(bool)
 15: 
 16: # Keep track of refunded bids so we can follow the withdraw pattern
 17: pendingReturns: public(HashMap[address, uint256])
 18: 
 19: # Create a simple auction with `_auction_start` and
 20: # `_bidding_time` seconds bidding time on behalf of the
 21: # beneficiary address `_beneficiary`.
 22: @external
 23: def __init__(_beneficiary: address, _auction_start: uint256, _bidding_time: uint256):
 24:     self.beneficiary = _beneficiary
 25:     self.auctionStart = _auction_start  # auction start time can be in the past, present or future
 26:     self.auctionEnd = self.auctionStart + _bidding_time
 27:     assert block.timestamp < self.auctionEnd # auction end time should be in the future
 28: 
 29: # Bid on the auction with the value sent
 30: # together with this transaction.
 31: # The value will only be refunded if the
 32: # auction is not won.
 33: @external
 34: @payable
 35: def bid():
 36:     # Check if bidding period has started.
 37:     assert block.timestamp >= self.auctionStart
 38:     # Check if bidding period is over.
 39:     assert block.timestamp < self.auctionEnd
 40:     # Check if bid is high enough
 41:     assert msg.value > self.highestBid
 42:     # Track the refund for the previous high bidder
 43:     self.pendingReturns[self.highestBidder] += self.highestBid
 44:     # Track new high bid
 45:     self.highestBidder = msg.sender
 46:     self.highestBid = msg.value
 47: 
 48: # Withdraw a previously refunded bid. The withdraw pattern is
 49: # used here to avoid a security issue. If refunds were directly
 50: # sent as part of bid(), a malicious bidding contract could block
 51: # those refunds and thus block new higher bids from coming in.
 52: @external
 53: def withdraw():
 54:     pending_amount: uint256 = self.pendingReturns[msg.sender]
 55:     self.pendingReturns[msg.sender] = 0
 56:     send(msg.sender, pending_amount)
 57: 
 58: # End the auction and send the highest bid
 59: # to the beneficiary.
 60: @external
 61: def endAuction():
 62:     # It is a good guideline to structure functions that interact
 63:     # with other contracts (i.e. they call functions or send Ether)
 64:     # into three phases:
 65:     # 1. checking conditions
 66:     # 2. performing actions (potentially changing conditions)
 67:     # 3. interacting with other contracts
 68:     # If these phases are mixed up, the other contract could call
 69:     # back into the current contract and modify the state or cause
 70:     # effects (Ether payout) to be performed multiple times.
 71:     # If functions called internally include interaction with external
 72:     # contracts, they also have to be considered interaction with
 73:     # external contracts.
 74: 
 75:     # 1. Conditions
 76:     # Check if auction endtime has been reached
 77:     assert block.timestamp >= self.auctionEnd
 78:     # Check if this function has already been called
 79:     assert not self.ended
 80: 
 81:     # 2. Effects
 82:     self.ended = True
 83: 
 84:     # 3. Interaction
 85:     send(self.beneficiary, self.highestBid)
