  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "os"
  6:     "sync"
  7:     "time"
  8: )
  9: 
 10: func main() {
 11:     msg := make(chan string)
 12:     msg2 := make(chan string)
 13:     var wg sync.WaitGroup
 14:     for i := 0; i < 10; i++ {
 15:         wg.Add(1)
 16:         go func(n int) {
 17:             for {
 18:                 time.Sleep(time.Millisecond * 50)
 19:                 msg <- fmt.Sprintf("ping:%d", n)
 20:             }
 21:         }(i)
 22:     }
 23:     for i := 0; i < 10; i++ {
 24:         wg.Add(1)
 25:         go func(n int) {
 26:             for {
 27:                 time.Sleep(time.Millisecond * 55)
 28:                 msg2 <- fmt.Sprintf("PONG:%d", n)
 29:             }
 30:         }(i)
 31:     }
 32:     nMsg := 0
 33:     for {
 34:         select {
 35:         case out := <-msg:
 36:             nMsg++
 37:             fmt.Printf("%s\n", out)
 38:         case out := <-msg2:
 39:             nMsg++
 40:             fmt.Printf("%s\n", out)
 41:         }
 42:         if nMsg > 20 {
 43:             os.Exit(0)
 44:         }
 45:     }
 46:     wg.Wait()
 47: }
