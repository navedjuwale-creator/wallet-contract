# Wallet V4
Wallet v4 is a proposed version of wallet to replace v3 or older wallets.

The main difference from previous versions is plugin functionality: trusted conjugated contracts may implement complex logic while still being able to use all funds from the main wallet.

That way the wallet can be extended in numerous ways, including partial, infinite or programmatic allowances, special connectors to specific DApps, and custom user-governed add-ons.

More info: [TIPS-38](https://github.com/newton-blockchain/TIPs/issues/38).

## Repository layout
- `build.sh` — root helper script for the standard build workflow.
- `func/build.sh` — contract build script.
- `func/wallet-v4-code.fc` — wallet contract source.
- `func/simple-subscription-plugin.fc` — subscription plugin source.
- `func/stdlib.fc` — shared standard library.
- `func/print-hex.fif` — helper Fift script for printing hex output.

## Prerequisites
- `func` compiler installed and available on `PATH`
- `fift` available on `PATH`
- `bash` for the root helper script

## Configure the environment
This repository installs the TON toolchain locally in `toolchain/bin`.

From the repository root, verify the required toolchain commands:

```bash
./check-prereqs.sh
```

If the script reports missing commands, ensure `toolchain/bin` exists and contains `func` and `fift`, or install the TON toolchain and update `PATH`.

## README-driven workflow
Use this repository workflow to build and inspect the wallet and plugin code.

### 1. Build the contracts
From the repository root:

```bash
./build.sh
```

This runs `func/build.sh` and generates:
- `func/wallet-v4-code.fif`
- `func/subscription-plugin-code.fif`

### 2. Inspect the generated output
After build, run:

```bash
cd func
fift print-hex.fif
```

This prints a hex representation of the generated contract code.

### 3. Iterate on source
Edit the contract sources in `func/`:
- `func/wallet-v4-code.fc`
- `func/simple-subscription-plugin.fc`

Then rebuild with `./build.sh`.

## Interface
### External messages
1. Send arbitrary owner-formed message (the same functionality as v1, v2, v3)
2. Deploy and install plugin
3. Install deployed plugin
4. Remove plugin

### Internal messages
1. Upon receiving a message with `0x706c7567` op from a plugin (plugin list is stored in wallet storage), the wallet sends requested funds to the plugin.

## Plugins
### Subscription plugin
The subscription plugin implements logic for periodic predefined payments to a fixed destination address. Payment is initiated by an anyone-can-send external message, while the plugin's logic ensures that funds are sent no more often than allowed.

Fees are subtracted from the transferred amount (payee pays for fees), including `1 Toncoin` which remains on the plugin balance until plugin destruction. Upon subscription destruction, remaining Toncoins are transferred to the destination address.
