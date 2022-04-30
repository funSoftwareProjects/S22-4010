  1: module.exports = {
  2:   networks: {
  3:     development: {
  4:       host: "127.0.0.1",     // Localhost (default: none)
  5:       port: 8545,            // Standard Ethereum port (default: none)
  6:       network_id: "*",       // Any network (default: none)
  7:     },
  8:   },
  9:   compilers: {
 10:     solc: {
 11:       optimizer: {
 12:         enabled: true,
 13:         runs: 200
 14:       },
 15:       version: "0.8.1",    // Fetch exact version from solc-bin (default: truffle's version)
 16:       evmVersion: "petersburg"
 17:     }
 18:   },
 19: };
