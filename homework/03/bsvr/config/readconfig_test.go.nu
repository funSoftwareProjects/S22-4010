  1: package config
  2: 
  3: import "testing"
  4: 
  5: func TestMineBlock(t *testing.T) {
  6: 
  7:     tests := []struct {
  8:         FileName     string
  9:         expectedPath string
 10:     }{
 11:         {
 12:             FileName:     "./testdata/a.json",
 13:             expectedPath: "./a/b/c.json",
 14:         },
 15:     }
 16: 
 17:     for ii, test := range tests {
 18:         ReadConfig(test.FileName)
 19:         cfg := GetGlobalConfig()
 20:         if cfg.DataDir != test.expectedPath {
 21:             t.Errorf("Test %d, expected %s got %s\n", ii, test.expectedPath, cfg.DataDir)
 22:         }
 23:     }
 24: 
 25: }
