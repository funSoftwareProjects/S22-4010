  1: package main
  2: 
  3: // https://medium.com/@hirzani/implementing-cronjob-in-golang-82e7608ae6d6
  4: // See:
  5: // -rw-r--r--@   1 philip      181141 Apr 22 08:27 cron-scheduler-in-go.html
  6: // drwx------@  83 philip        2656 Apr 22 08:27 cron-scheduler-in-go_files
  7: 
  8: // See: https://pkg.go.dev/github.com/robfig/cron
  9: 
 10: import (
 11:     "time"
 12: 
 13:     "github.com/robfig/cron"
 14:     log "github.com/sirupsen/logrus"
 15: )
 16: 
 17: func init() {
 18:     log.SetLevel(log.InfoLevel)
 19:     log.SetFormatter(&log.TextFormatter{FullTimestamp: true})
 20: }
 21: 
 22: func main() {
 23:     log.Info("Create new cron")
 24:     c := cron.New()
 25:     c.AddFunc("*/1 * * * *", func() {
 26:         log.Info("[Job 1]Every minute job\n")
 27:     })
 28: 
 29:     // Start cron with one scheduled job
 30:     log.Info("Start cron")
 31:     c.Start()
 32:     printCronEntries(c.Entries())
 33:     time.Sleep(2 * time.Minute)
 34: 
 35:     // Funcs may also be added to a running Cron
 36:     log.Info("Add new job to a running cron")
 37:     entryID2, _ := c.AddFunc("*/2 * * * *", func() { log.Info("[Job 2]Every two minutes job\n") })
 38:     printCronEntries(c.Entries())
 39:     time.Sleep(5 * time.Minute)
 40: 
 41:     //Remove Job2 and add new Job2 that run every 1 minute
 42:     log.Info("Remove Job2 and add new Job2 with schedule run every minute")
 43:     c.Remove(entryID2)
 44:     c.AddFunc("*/1 * * * *", func() { log.Info("[Job 2]Every one minute job\n") })
 45:     time.Sleep(5 * time.Minute)
 46: 
 47: }
 48: 
 49: func printCronEntries(cronEntries []cron.Entry) {
 50:     log.Infof("Cron Info: %+v\n", cronEntries)
 51: }
