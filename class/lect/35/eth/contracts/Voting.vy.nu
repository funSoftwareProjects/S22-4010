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
 27: 
 28: @view
 29: @internal
 30: def _delegated(addr: address) -> bool:
 31:     return self.voters[addr].delegate != ZERO_ADDRESS
 32: 
 33: 
 34: @view
 35: @external
 36: def delegated(addr: address) -> bool:
 37:     return self._delegated(addr)
 38: 
 39: 
 40: @view
 41: @internal
 42: def _directlyVoted(addr: address) -> bool:
 43:     return self.voters[addr].voted and (self.voters[addr].delegate == ZERO_ADDRESS)
 44: 
 45: 
 46: @view
 47: @external
 48: def directlyVoted(addr: address) -> bool:
 49:     return self._directlyVoted(addr)
 50: 
 51: 
 52: # Setup global variables
 53: @external
 54: def __init__(_proposalNames: bytes32[2]):
 55:     self.chairperson = msg.sender
 56:     self.voterCount = 0
 57:     for i in range(2):
 58:         self.proposals[i] = Proposal({
 59:             name: _proposalNames[i],
 60:             voteCount: 0
 61:         })
 62:         self.int128Proposals += 1
 63: 
 64: # Give a `voter` the right to vote on this ballot.
 65: # This may only be called by the `chairperson`.
 66: @external
 67: def giveRightToVote(voter: address):
 68:     # Throws if the sender is not the chairperson.
 69:     assert msg.sender == self.chairperson
 70:     # Throws if the voter has already voted.
 71:     assert not self.voters[voter].voted
 72:     # Throws if the voter's voting weight isn't 0.
 73:     assert self.voters[voter].weight == 0
 74:     self.voters[voter].weight = 1
 75:     self.voterCount += 1
 76: 
 77: # Used by `delegate` below, callable externally via `forwardWeight`
 78: @internal
 79: def _forwardWeight(delegate_with_weight_to_forward: address):
 80:     assert self._delegated(delegate_with_weight_to_forward)
 81:     # Throw if there is nothing to do:
 82:     assert self.voters[delegate_with_weight_to_forward].weight > 0
 83: 
 84:     target: address = self.voters[delegate_with_weight_to_forward].delegate
 85:     for i in range(4):
 86:         if self._delegated(target):
 87:             target = self.voters[target].delegate
 88:             # The following effectively detects cycles of length <= 5,
 89:             # in which the delegation is given back to the delegator.
 90:             # This could be done for any int128ber of loops,
 91:             # or even infinitely with a while loop.
 92:             # However, cycles aren't actually problematic for correctness;
 93:             # they just result in spoiled votes.
 94:             # So, in the production version, this should instead be
 95:             # the responsibility of the contract's client, and this
 96:             # check should be removed.
 97:             assert target != delegate_with_weight_to_forward
 98:         else:
 99:             # Weight will be moved to someone who directly voted or
100:             # hasn't voted.
101:             break
102: 
103:     weight_to_forward: int128 = self.voters[delegate_with_weight_to_forward].weight
104:     self.voters[delegate_with_weight_to_forward].weight = 0
105:     self.voters[target].weight += weight_to_forward
106: 
107:     if self._directlyVoted(target):
108:         self.proposals[self.voters[target].vote].voteCount += weight_to_forward
109:         self.voters[target].weight = 0
110: 
111:     # To reiterate: if target is also a delegate, this function will need
112:     # to be called again, similarly to as above.
113: 
114: # Public function to call _forwardWeight
115: @external
116: def forwardWeight(delegate_with_weight_to_forward: address):
117:     self._forwardWeight(delegate_with_weight_to_forward)
118: 
119: # Delegate your vote to the voter `to`.
120: @external
121: def delegate(to: address):
122:     # Throws if the sender has already voted
123:     assert not self.voters[msg.sender].voted
124:     # Throws if the sender tries to delegate their vote to themselves or to
125:     # the default address value of 0x0000000000000000000000000000000000000000
126:     # (the latter might not be problematic, but I don't want to think about it).
127:     assert to != msg.sender
128:     assert to != ZERO_ADDRESS
129: 
130:     self.voters[msg.sender].voted = True
131:     self.voters[msg.sender].delegate = to
132: 
133:     # This call will throw if and only if this delegation would cause a loop
134:         # of length <= 5 that ends up delegating back to the delegator.
135:     self._forwardWeight(msg.sender)
136: 
137: # Give your vote (including votes delegated to you)
138: # to proposal `proposals[proposal].name`.
139: @external
140: def vote(proposal: int128):
141:     # can't vote twice
142:     assert not self.voters[msg.sender].voted
143:     # can only vote on legitimate proposals
144:     assert proposal < self.int128Proposals
145: 
146:     self.voters[msg.sender].vote = proposal
147:     self.voters[msg.sender].voted = True
148: 
149:     # transfer msg.sender's weight to proposal
150:     self.proposals[proposal].voteCount += self.voters[msg.sender].weight
151:     self.voters[msg.sender].weight = 0
152: 
153: # Computes the winning proposal taking all
154: # previous votes into account.
155: @view
156: @internal
157: def _winningProposal() -> int128:
158:     winning_vote_count: int128 = 0
159:     winning_proposal: int128 = 0
160:     for i in range(2):
161:         if self.proposals[i].voteCount > winning_vote_count:
162:             winning_vote_count = self.proposals[i].voteCount
163:             winning_proposal = i
164:     return winning_proposal
165: 
166: @view
167: @external
168: def winningProposal() -> int128:
169:     return self._winningProposal()
170: 
171: 
172: # Calls winningProposal() function to get the index
173: # of the winner contained in the proposals array and then
174: # returns the name of the winner
175: @view
176: @external
177: def winnerName() -> bytes32:
178:     return self.proposals[self._winningProposal()].name
