  1: # Blind Auction # Adapted to Vyper from [Solidity by Example](https://github.com/ethereum/solidity/blob/develop/docs/solidity-by-example.rst#blind-auction-1)
  2: 
  3: struct Bid:
  4:   blindedBid: bytes32
  5:   deposit: uint256
  6: 
  7: # Note: because Vyper does not allow for dynamic arrays, we have limited the
  8: # number of bids that can be placed by one address to 128 in this example
  9: MAX_BIDS: constant(int128) = 128
 10: 
 11: # Event for logging that auction has ended
 12: event AuctionEnded:
 13:     highestBidder: address
 14:     highestBid: uint256
 15: 
 16: # Auction parameters
 17: beneficiary: public(address)
 18: biddingEnd: public(uint256)
 19: revealEnd: public(uint256)
 20: 
 21: # Set to true at the end of auction, disallowing any new bids
 22: ended: public(bool)
 23: 
 24: # Final auction state
 25: highestBid: public(uint256)
 26: highestBidder: public(address)
 27: 
 28: # State of the bids
 29: bids: HashMap[address, Bid[128]]
 30: bidCounts: HashMap[address, int128]
 31: 
 32: # Allowed withdrawals of previous bids
 33: pendingReturns: HashMap[address, uint256]
 34: 
 35: 
 36: # Create a blinded auction with `_biddingTime` seconds bidding time and
 37: # `_revealTime` seconds reveal time on behalf of the beneficiary address
 38: # `_beneficiary`.
 39: @external
 40: def __init__(_beneficiary: address, _biddingTime: uint256, _revealTime: uint256):
 41:     self.beneficiary = _beneficiary
 42:     self.biddingEnd = block.timestamp + _biddingTime
 43:     self.revealEnd = self.biddingEnd + _revealTime
 44: 
 45: 
 46: # Place a blinded bid with:
 47: #
 48: # _blindedBid = keccak256(concat(
 49: #       convert(value, bytes32),
 50: #       convert(fake, bytes32),
 51: #       secret)
 52: # )
 53: #
 54: # The sent ether is only refunded if the bid is correctly revealed in the
 55: # revealing phase. The bid is valid if the ether sent together with the bid is
 56: # at least "value" and "fake" is not true. Setting "fake" to true and sending
 57: # not the exact amount are ways to hide the real bid but still make the
 58: # required deposit. The same address can place multiple bids.
 59: @external
 60: @payable
 61: def bid(_blindedBid: bytes32):
 62:     # Check if bidding period is still open
 63:     assert block.timestamp < self.biddingEnd
 64: 
 65:     # Check that payer hasn't already placed maximum number of bids
 66:     numBids: int128 = self.bidCounts[msg.sender]
 67:     assert numBids < MAX_BIDS
 68: 
 69:     # Add bid to mapping of all bids
 70:     self.bids[msg.sender][numBids] = Bid({
 71:         blindedBid: _blindedBid,
 72:         deposit: msg.value
 73:         })
 74:     self.bidCounts[msg.sender] += 1
 75: 
 76: 
 77: # Returns a boolean value, `True` if bid placed successfully, `False` otherwise.
 78: @internal
 79: def placeBid(bidder: address, _value: uint256) -> bool:
 80:     # If bid is less than highest bid, bid fails
 81:     if (_value <= self.highestBid):
 82:         return False
 83: 
 84:     # Refund the previously highest bidder
 85:     if (self.highestBidder != ZERO_ADDRESS):
 86:         self.pendingReturns[self.highestBidder] += self.highestBid
 87: 
 88:     # Place bid successfully and update auction state
 89:     self.highestBid = _value
 90:     self.highestBidder = bidder
 91: 
 92:     return True
 93: 
 94: 
 95: # Reveal your blinded bids. You will get a refund for all correctly blinded
 96: # invalid bids and for all bids except for the totally highest.
 97: @external
 98: def reveal(_numBids: int128, _values: uint256[128], _fakes: bool[128], _secrets: bytes32[128]):
 99:     # Check that bidding period is over
100:     assert block.timestamp > self.biddingEnd
101: 
102:     # Check that reveal end has not passed
103:     assert block.timestamp < self.revealEnd
104: 
105:     # Check that number of bids being revealed matches log for sender
106:     assert _numBids == self.bidCounts[msg.sender]
107: 
108:     # Calculate refund for sender
109:     refund: uint256 = 0
110:     for i in range(MAX_BIDS):
111:         # Note that loop may break sooner than 128 iterations if i >= _numBids
112:         if (i >= _numBids):
113:             break
114: 
115:         # Get bid to check
116:         bidToCheck: Bid = (self.bids[msg.sender])[i]
117: 
118:         # Check against encoded packet
119:         value: uint256 = _values[i]
120:         fake: bool = _fakes[i]
121:         secret: bytes32 = _secrets[i]
122:         blindedBid: bytes32 = keccak256(concat(
123:             convert(value, bytes32),
124:             convert(fake, bytes32),
125:             secret
126:         ))
127: 
128:         # Bid was not actually revealed
129:         # Do not refund deposit
130:         if (blindedBid != bidToCheck.blindedBid):
131:             assert 1 == 0
132:             continue
133: 
134:         # Add deposit to refund if bid was indeed revealed
135:         refund += bidToCheck.deposit
136:         if (not fake and bidToCheck.deposit >= value):
137:             if (self.placeBid(msg.sender, value)):
138:                 refund -= value
139: 
140:         # Make it impossible for the sender to re-claim the same deposit
141:         zeroBytes32: bytes32 = EMPTY_BYTES32
142:         bidToCheck.blindedBid = zeroBytes32
143: 
144:     # Send refund if non-zero
145:     if (refund != 0):
146:         send(msg.sender, refund)
147: 
148: 
149: # Withdraw a bid that was overbid.
150: @external
151: def withdraw():
152:     # Check that there is an allowed pending return.
153:     pendingAmount: uint256 = self.pendingReturns[msg.sender]
154:     if (pendingAmount > 0):
155:         # If so, set pending returns to zero to prevent recipient from calling
156:         # this function again as part of the receiving call before `transfer`
157:         # returns (see the remark above about conditions -> effects ->
158:         # interaction).
159:         self.pendingReturns[msg.sender] = 0
160: 
161:         # Then send return
162:         send(msg.sender, pendingAmount)
163: 
164: 
165: # End the auction and send the highest bid to the beneficiary.
166: @external
167: def auctionEnd():
168:     # Check that reveal end has passed
169:     assert block.timestamp > self.revealEnd
170: 
171:     # Check that auction has not already been marked as ended
172:     assert not self.ended
173: 
174:     # Log auction ending and set flag
175:     log AuctionEnded(self.highestBidder, self.highestBid)
176:     self.ended = True
177: 
178:     # Transfer funds to beneficiary
179:     send(self.beneficiary, self.highestBid)
