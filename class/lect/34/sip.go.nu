  1: package main
  2: 
  3: //
  4: //import (
  5: //    "fmt"
  6: //    "math/big"
  7: //)
  8: //
  9: //// From: https://arrow.dit.ie/cgi/viewcontent.cgi?article=1031&context=itbj
 10: //// IdProtocalsInCrypto.pdf
 11: //
 12: //func main() {
 13: //    // From p40
 14: //    p := big.NewInt(88667)
 15: //    q := big.NewInt(1031)
 16: //    alpha := big.NewInt(70322)
 17: //    a := big.NewInt(755)
 18: //
 19: //    // v = (alpha ^ ( q-a )) % p
 20: //    t1 := big.NewInt(0)
 21: //    t1.Sub(q, a)
 22: //    v := big.NewInt(0)
 23: //    v.Exp(alpha, t1, p)
 24: //
 25: //    fmt.Printf("Setup Complete: v=%s\n", v)
 26: //
 27: //    // Alice is the Client:
 28: //
 29: //    // ----------------------------------------------------------
 30: //    // Message 1 - Client to Server
 31: //    // ----------------------------------------------------------
 32: //
 33: //    // Alice Chooses, and send to Bob
 34: //    r := big.NewInt(543) // Should be random, but for this example
 35: //    x := big.NewInt(0)
 36: //    x.Exp(alpha, r, p) // x=(alpha^r) % p
 37: //
 38: //    fmt.Printf("Send To Bob : x=%s\n", x)
 39: //
 40: //    // ------------------------------------------------------------------------
 41: //    // Response to Message 1, Server back to client
 42: //    // ------------------------------------------------------------------------
 43: //
 44: //    // Bob is the Server:
 45: //    // Bob sends the challenge 'e' back to Alice e to do the computation
 46: //    e := big.NewInt(1000) // how chose (random?)
 47: //
 48: //    // Alice now computes: y = a*e % q
 49: //    t2 := big.NewInt(0)
 50: //    t2.Mul(a, e)
 51: //    t2.Mod(t2, q) // 45664
 52: //    t2.Add(t2, r) // 851 is correct
 53: //
 54: //    y := t2
 55: //    fmt.Printf("y=%s\n", y) // Prints 851
 56: //
 57: //    // ------------------------------------------------------------------------
 58: //    // Message 2 - Client (Alice) with response to challenge.
 59: //    // ------------------------------------------------------------------------
 60: //
 61: //    // Bob (server) verifies: x == z == (a^y) * (v^e) % p
 62: //    // Bob (server) verifies: x == z == ((a^y)%p)*((v^e)%p) % p
 63: //
 64: //    t3 := big.NewInt(0)
 65: //    t3.Exp(alpha, y, p)
 66: //    t4 := big.NewInt(0)
 67: //    t4.Exp(v, e, p)
 68: //    t5 := big.NewInt(0)
 69: //    t5.Mul(t3, t4)
 70: //    t5.Mod(t5, p)
 71: //
 72: //    z := t5
 73: //    fmt.Printf("z=%s\n", z)
 74: //
 75: //    // ------------------------------------------------------------------------
 76: //    // Response 2 - Success/Fail message from server back to client
 77: //    // ------------------------------------------------------------------------
 78: //    if x.Cmp(z) == 0 {
 79: //        fmt.Printf("Authoized! Yea\n")
 80: //    } else {
 81: //        fmt.Printf("Nope nope nope\n")
 82: //    }
 83: //
 84: //}
