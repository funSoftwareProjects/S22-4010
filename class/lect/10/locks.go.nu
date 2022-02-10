  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "sync"
  6:     "time"
  7: )
  8: 
  9: func main() {
 10:     messages := make(chan int)
 11:     var wg sync.WaitGroup
 12: 
 13:     // you can also add these one at
 14:     // a time if you need to
 15: 
 16:     wg.Add(3)
 17:     go func() {
 18:         defer wg.Done()
 19:         time.Sleep(time.Second * 3)
 20:         messages <- 1
 21:     }()
 22:     go func() {
 23:         defer wg.Done()
 24:         time.Sleep(time.Second * 2)
 25:         messages <- 2
 26:     }()
 27:     go func() {
 28:         defer wg.Done()
 29:         time.Sleep(time.Second * 1)
 30:         messages <- 3
 31:     }()
 32:     go func() {
 33:         for i := range messages {
 34:             fmt.Println(i)
 35:         }
 36:     }()
 37: 
 38:     wg.Wait()
 39:     time.Sleep(time.Second * 1)
 40: }
