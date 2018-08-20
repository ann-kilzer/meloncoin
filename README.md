# meloncoin

![Image](meloncoin-logo.png?raw=true)

Meloncoin is an expiring cryptocurrency backed by the famously expensive Hokkaido Melon.

Check out the [website](http://melonco.in) or follow the project on [twitter](https://twitter.com/meloncointoken).

Why melons? I live in Japan, and fruit is incredibly expensive here. It's not just for eating -- melons and other high-end fruits are given as gifts, and frequently carry price tags of upwards of $100USD. While this example is somewhat whimsical, the idea of an expiring token is generalizable. Consider concert tickets, video game pre-sales, or any item where the product peaks at a specific point in time. Value builds until that moment and no further.

When I researched expiring tokens, there wasn't much out there, aside from a [stack exchange thread](https://ethereum.stackexchange.com/questions/27379/is-it-possible-to-create-an-expiring-ephemeral-erc-20-token) and an [article from ConsenSys](https://medium.com/@ConsenSys/tokens-on-ethereum-e9e61dac9b4e) pointing to some [dead (expired?)](http://inflekt.us/) [links](http://farmshare.space/). Please send more my way if you fine anything.


Prerequisites:

* [Truffle v4.1.11](https://truffleframework.com/truffle)
* [Solidity v0.4.24](https://github.com/ethereum/solidity)
* [Ganache v6.1.6.](https://truffleframework.com/ganache)
* [NPM 5.6.0](https://www.npmjs.com/)
* [Metamask](https://metamask.io/)

Runs on
Mac OS X High Sierra 10.13.6.

TODO Get running on Linux.

How to run it:

In terminal 1, run
```
ganache-cli
```

This starts up a local blockchain on port 8545, perfect for our demo.

Take note of the 12 word phrase and enter that into Metamask for the private net connection.

TODO add screenshot


Open another terminal and run:

```
npm install
truffle compile && truffle migrate
npm run dev
```

Open up your browser at http://localhost:3000/
