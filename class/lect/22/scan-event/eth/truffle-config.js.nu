  1: /**
  2:  * Use this file to configure your truffle project. It's seeded with some
  3:  * common settings for different networks and features like migrations,
  4:  * compilation and testing. Uncomment the ones you need or modify
  5:  * them to suit your project as necessary.
  6:  *
  7:  * More information about configuration can be found at:
  8:  *
  9:  * trufflesuite.com/docs/advanced/configuration
 10:  *
 11:  * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 12:  * to sign your transactions before they're sent to a remote public node. Infura accounts
 13:  * are available for free at: infura.io/register.
 14:  *
 15:  * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 16:  * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 17:  * phrase from a file you've .gitignored so it doesn't accidentally become public.
 18:  *
 19:  */
 20: 
 21: // const HDWalletProvider = require('@truffle/hdwallet-provider');
 22: //
 23: // const fs = require('fs');
 24: // const mnemonic = fs.readFileSync(".secret").toString().trim();
 25: 
 26: module.exports = {
 27:   /**
 28:    * Networks define how you connect to your ethereum client and let you set the
 29:    * defaults web3 uses to send transactions. If you don't specify one truffle
 30:    * will spin up a development blockchain for you on port 9545 when you
 31:    * run `develop` or `test`. You can ask a truffle command to use a specific
 32:    * network from the command line, e.g
 33:    *
 34:    * $ truffle test --network <network-name>
 35:    */
 36: 
 37:   networks: {
 38:     // Useful for testing. The `development` name is special - truffle uses it by default
 39:     // if it's defined here and no other network is specified at the command line.
 40:     // You should run a client (like ganache-cli, geth or parity) in a separate terminal
 41:     // tab if you use this network and you must also set the `host`, `port` and `network_id`
 42:     // options below to some value.
 43:     //
 44:     // development: {
 45:     //  host: "127.0.0.1",     // Localhost (default: none)
 46:     //  port: 8545,            // Standard Ethereum port (default: none)
 47:     //  network_id: "*",       // Any network (default: none)
 48:     // },
 49:     // Another network with more advanced options...
 50:     // advanced: {
 51:     // port: 8777,             // Custom port
 52:     // network_id: 1342,       // Custom network
 53:     // gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
 54:     // gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
 55:     // from: <address>,        // Account to send txs from (default: accounts[0])
 56:     // websocket: true        // Enable EventEmitter interface for web3 (default: false)
 57:     // },
 58:     // Useful for deploying to a public network.
 59:     // NB: It's important to wrap the provider as a function.
 60:     // ropsten: {
 61:     // provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/YOUR-PROJECT-ID`),
 62:     // network_id: 3,       // Ropsten's id
 63:     // gas: 5500000,        // Ropsten has a lower block limit than mainnet
 64:     // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
 65:     // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
 66:     // skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
 67:     // },
 68:     // Useful for private networks
 69:     // private: {
 70:     // provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
 71:     // network_id: 2111,   // This network is yours, in the cloud.
 72:     // production: true    // Treats this network as if it was a public net. (default: false)
 73:     // }
 74:     development: {
 75:       host: "127.0.0.1",     // Localhost (default: none)
 76:       port: 8545,            // Standard Ethereum port (default: none)
 77:       network_id: "*",       // Any network (default: none)
 78:     },
 79:   },
 80: 
 81:   // Set default mocha options here, use special reporters etc.
 82:   mocha: {
 83:     // timeout: 100000
 84:   },
 85: 
 86:   // Configure your compilers
 87:   compilers: {
 88:     solc: {
 89:       optimizer: {
 90:         enabled: true,
 91:         runs: 200
 92:       },
 93:       // version: "0.5.1",    // Fetch exact version from solc-bin (default: truffle's version)
 94:       // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
 95:       // settings: {          // See the solidity docs for advice about optimization and evmVersion
 96:       //  optimizer: {
 97:       //    enabled: false,
 98:       //    runs: 200
 99:       //  },
100:       //  evmVersion: "byzantium"
101:       // }
102:       version: "0.8.1",    // Fetch exact version from solc-bin (default: truffle's version)
103:       evmVersion: "petersburg"
104:     }
105:   },
106: 
107:   // Truffle DB is currently disabled by default; to enable it, change enabled:
108:   // false to enabled: true. The default storage location can also be
109:   // overridden by specifying the adapter settings, as shown in the commented code below.
110:   //
111:   // NOTE: It is not possible to migrate your contracts to truffle DB and you should
112:   // make a backup of your artifacts to a safe location before enabling this feature.
113:   //
114:   // After you backed up your artifacts you can utilize db by running migrate as follows: 
115:   // $ truffle migrate --reset --compile-all
116:   //
117:   // db: {
118:     // enabled: false,
119:     // host: "127.0.0.1",
120:     // adapter: {
121:     //   name: "sqlite",
122:     //   settings: {
123:     //     directory: ".db"
124:     //   }
125:     // }
126:   // }
127: };
