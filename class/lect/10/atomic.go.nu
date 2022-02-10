  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "math/rand"
  6:     "sync"
  7:     "sync/atomic"
  8:     "time"
  9: )
 10: 
 11: func main() {
 12:     state := make(map[int]int)
 13:     mutex := &sync.Mutex{}
 14: 
 15:     var nRead uint64
 16:     var nWrite uint64
 17: 
 18:     const randRange = 15
 19: 
 20:     for ii := 0; ii < 100; ii++ {
 21:         go func() {
 22:             total := 0
 23:             for {
 24:                 key := rand.Intn(randRange)
 25:                 mutex.Lock()
 26:                 total += state[key]
 27:                 mutex.Unlock()
 28:                 atomic.AddUint64(&nRead, 1)
 29:                 time.Sleep(time.Millisecond)
 30:             }
 31:         }()
 32:     }
 33:     for jj := 0; jj < 50; jj++ {
 34:         go func() {
 35:             for {
 36:                 key := rand.Intn(randRange)
 37:                 val := rand.Intn(100)
 38:                 mutex.Lock()
 39:                 state[key] = val
 40:                 mutex.Unlock()
 41:                 atomic.AddUint64(&nWrite, 1)
 42:                 time.Sleep(time.Millisecond)
 43:             }
 44:         }()
 45:     }
 46: 
 47:     time.Sleep(time.Second * 1)
 48: 
 49:     nReadTotal := atomic.LoadUint64(&nRead)
 50:     nWriteTotal := atomic.LoadUint64(&nWrite)
 51: 
 52:     mutex.Lock()
 53:     fmt.Printf("ReadOps: %d\nWriteOps: %d\nFinal State: %+v\n", nReadTotal, nWriteTotal, state)
 54:     mutex.Unlock()
 55: }
