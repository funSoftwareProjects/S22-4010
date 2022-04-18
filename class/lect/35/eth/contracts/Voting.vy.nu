  1: # Voting with delegation.
  2: 
  3: # Information about voters
  4: struct Voter:
  5:     # weight is accumulated by delegation
  6:     weight: int128
  7:     # if true, that person already voted (which includes voting by delegating)
  8:     voted: bool
  9:     # person delegated to
 10:     delegate: address
 11:     # index of the voted proposal, which is not meaningful unless `voted` is True.
 12:     vote: int128
 13: 
 14: # Users can create proposals
 15: struct Proposal:
 16:     # short name (up to 32 bytes)
 17:     name: bytes32
 18:     # number of accumulated votes
 19:     voteCount: int128
 20: 
 21: voters: public(HashMap[address, Voter])
 22: proposals: public(HashMap[int128, Proposal])
 23: voterCount: public(int128)
 24: chairperson: public(address)
 25: int128Proposals: public(int128)
 26: 
 27: @view
 28: @internal
 29: def _delegated(addr: address) -> bool:
 30:     return self.voters[addr].delegate != ZERO_ADDRESS
 31: 
 32: @view
 33: @external
 34: def delegated(addr: address) -> bool:
 35:     return self._delegated(addr)
 36: 
 37: @view
 38: @internal
 39: def _directlyVoted(addr: address) -> bool:
 40:     return self.voters[addr].voted and (self.voters[addr].delegate == ZERO_ADDRESS)
 41: 
 42: @view
 43: @external
 44: def directlyVoted(addr: address) -> bool:
 45:     return self._directlyVoted(addr)
 46: 
 47: # Setup global variables / Constructor - Assume that there are a max of 4
 48: # things to vote for.
 49: @external
 50: def __init__(_proposalNames: bytes32[4]):
 51:     self.chairperson = msg.sender
 52:     self.voterCount = 0
 53:     for i in range(4):
 54:         self.proposals[i] = Proposal({
 55:             name: _proposalNames[i],
 56:             voteCount: 0
 57:         })
 58:         self.int128Proposals += 1
 59: 
 60: # Give a `voter` the right to vote on this ballot.  This may only be called by the `chairperson`.
 61: @external
 62: def giveRightToVote(voter: address):
 63:     assert msg.sender == self.chairperson # Throws if the sender is not the chairperson.
 64:     assert not self.voters[voter].voted   # Throws if the voter has already voted.
 65:     assert self.voters[voter].weight == 0 # Throws if the voter's voting weight isn't 0.
 66:     self.voters[voter].weight = 1
 67:     self.voterCount += 1
 68: 
 69: # Used by `delegate` below, callable externally via `forwardWeight`
 70: @internal
 71: def _forwardWeight(delegate_with_weight_to_forward: address):
 72:     assert self._delegated(delegate_with_weight_to_forward)
 73:     # Throw if there is nothing to do:
 74:     assert self.voters[delegate_with_weight_to_forward].weight > 0
 75: 
 76:     target: address = self.voters[delegate_with_weight_to_forward].delegate
 77:     for i in range(4):
 78:         if self._delegated(target):
 79:             target = self.voters[target].delegate
 80:             # The following effectively detects cycles of length <= 5,
 81:             # in which the delegation is given back to the delegator.
 82:             # This could be done for any int128ber of loops,
 83:             # or even infinitely with a while loop.
 84:             # However, cycles aren't actually problematic for correctness;
 85:             # they just result in spoiled votes.
 86:             # So, in the production version, this should instead be
 87:             # the responsibility of the contract's client, and this
 88:             # check should be removed.
 89:             assert target != delegate_with_weight_to_forward
 90:         else:
 91:             # Weight will be moved to someone who directly voted or
 92:             # hasn't voted.
 93:             break
 94: 
 95:     weight_to_forward: int128 = self.voters[delegate_with_weight_to_forward].weight
 96:     self.voters[delegate_with_weight_to_forward].weight = 0
 97:     self.voters[target].weight += weight_to_forward
 98: 
 99:     if self._directlyVoted(target):
100:         self.proposals[self.voters[target].vote].voteCount += weight_to_forward
101:         self.voters[target].weight = 0
102: 
103:     # To reiterate: if target is also a delegate, this function will need
104:     # to be called again, similarly to as above.
105: 
106: # Public function to call _forwardWeight
107: @external
108: def forwardWeight(delegate_with_weight_to_forward: address):
109:     self._forwardWeight(delegate_with_weight_to_forward)
110: 
111: # Delegate your vote to the voter `to`.
112: @external
113: def delegate(to: address):
114:     # Throws if the sender has already voted
115:     assert not self.voters[msg.sender].voted
116:     # Throws if the sender tries to delegate their vote to themselves or to
117:     # the default address value of 0x0000000000000000000000000000000000000000
118:     # (the latter might not be problematic, but I don't want to think about it).
119:     assert to != msg.sender
120:     assert to != ZERO_ADDRESS
121: 
122:     self.voters[msg.sender].voted = True    # Mark weight as having benn assigned.
123:     self.voters[msg.sender].delegate = to    # Send to sombody else
124: 
125:     # This call will throw if and only if this delegation would cause a loop
126:     # of length <= 5 that ends up delegating back to the delegator.
127:     self._forwardWeight(msg.sender)
128: 
129: # Give your vote (including votes delegated to you)
130: # to proposal `proposals[proposal].name`.
131: @external
132: def vote(proposal: int128):
133:     assert not self.voters[msg.sender].voted # can't vote twice
134:     assert proposal < self.int128Proposals   # can only vote on legitimate proposals
135: 
136:     self.voters[msg.sender].voted = True     # Mark as having voted
137:     self.voters[msg.sender].vote = proposal     # record what was voted for.
138: 
139:     # transfer msg.sender's weight to proposal
140:     self.proposals[proposal].voteCount += self.voters[msg.sender].weight
141:     self.voters[msg.sender].weight = 0        #  Discard weight - so can not use again.
142: 
143: # Computes the winning proposal, the proposal with the max number of botes.
144: @view
145: @internal
146: def _winningProposal() -> int128:
147:     winning_vote_count: int128 = 0    # Assume 0 votes to start
148:     winning_proposal: int128 = 0    # Assume proposal at locaiton 0
149:     for i in range(4):
150:         if self.proposals[i].voteCount > winning_vote_count:
151:             winning_vote_count = self.proposals[i].voteCount
152:             winning_proposal = i
153:     return winning_proposal
154: 
155: @view
156: @external
157: def winningProposal() -> int128:
158:     return self._winningProposal()
159: 
160: 
161: # Calls winningProposal() function to get the index
162: # of the winner contained in the proposals array and then
163: # returns the name of the winner
164: @view
165: @external
166: def winnerName() -> bytes32:
167:     return self.proposals[self._winningProposal()].name
