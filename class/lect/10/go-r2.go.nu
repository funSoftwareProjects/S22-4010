  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "sync"
  6: )
  7: 
  8: func main() {
  9:     var wg sync.WaitGroup
 10:     for i := 0; i < 10; i++ {
 11:         wg.Add(1)
 12:         go func(a int) {
 13:             defer wg.Done()
 14:             fmt.Printf("a=%d\n", a)
 15:         }(12 + i)
 16:     }
 17:     wg.Wait()
 18: }
