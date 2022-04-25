Ethereum Price Oracle fetching ETH price from Binance API 
Made with help of www.cryptozombies.io - Powered by LOOM 

First you need to generate keys
node scripts/gen-key.js oracle/oracle_private_key
node scripts/gen-key.js caller/caller_private_key

Then run 
npm run deploy:all
