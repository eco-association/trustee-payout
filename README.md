# Trustee Payout Test

To start up the enviroment, run:

```
forge install
```

There may be an issue with the op-ethereum libraries not being found in the `op-eco` git submodule. If this occurs, run:

```
cd lib/currency-1.5
yarn install
cd -
forge remappings > remappings.txt
```

To build, run:

```
forge build
```

To test, run:

```
forge test
```