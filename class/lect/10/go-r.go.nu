  1: package main
  2: 
  3: import "fmt"
  4: 
  5: func main() {
  6:     for i := 0; i < 10; i++ {
  7:         go func(a int) {
  8:             fmt.Printf("a=%d\n", a)
  9:         }(12 + i)
 10:     }
 11: }
