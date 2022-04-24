  1: # Minimual contract that stores a value
  2: 
  3: stored_data: uint256
  4: 
  5: @external
  6: def set(new_value : uint256):
  7:     self.stored_data = new_value
  8: 
  9: @external
 10: @view
 11: def get() -> uint256:
 12:     return self.stored_data
