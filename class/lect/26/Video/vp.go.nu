  1: package main
  2: 
  3: import (
  4:     "fmt"
  5:     "io/ioutil"
  6:     "os"
  7:     "strings"
  8: )
  9: 
 10: func main() {
 11: 
 12:     arg := "youtube.md"
 13:     if len(os.Args) > 1 {
 14:         arg = os.Args[1]
 15:     }
 16: 
 17:     buf, err := ioutil.ReadFile(arg)
 18:     if err != nil {
 19:         fmt.Printf("Unable to open v.txt : %s\n", err)
 20:         os.Exit(1)
 21:     }
 22: 
 23:     lines := strings.Split(string(buf), "\n")
 24:     for _, line := range lines {
 25:         s2 := strings.Split(line, " ")
 26:         if len(s2) == 0 {
 27:         } else if len(s2) == 2 {
 28:             fmt.Printf("[%s - %s](%s)<br>\n", s2[0], s2[1], s2[0])
 29:         }
 30:     }
 31: 
 32:     fmt.Printf("\nFrom Amazon S3 - for download (same as youtube videos)\n\n")
 33: 
 34:     for line_no, line := range lines {
 35:         s2 := strings.Split(line, " ")
 36:         if len(s2) <= 1 {
 37:         } else if len(s2) >= 2 {
 38:             // [http://uw-s20-2015.s3.amazonaws.com/Lect-20-4010-pt1-news.mp4](http://uw-s20-2015.s3.amazonaws.com/Lect-20-4010-pt1-news.mp4)<br>
 39:             fmt.Printf("[http://uw-s20-2015.s3.amazonaws.com/%s](http://uw-s20-2015.s3.amazonaws.com/%s)<br>\n", s2[1], s2[1])
 40:         } else {
 41:             fmt.Fprintf(os.Stderr, "Error on line %d - missing field ->%s<- len=%d\n", line_no+1, s2, len(s2))
 42:         }
 43:     }
 44: 
 45: }
