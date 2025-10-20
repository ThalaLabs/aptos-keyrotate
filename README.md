# aptos-keyrotate

Like rotating your keys, but simpler. Handles Aptos account key rotation with automatic backups and safety checks.

## Why use this?

`aptos-keyrotate` wraps `aptos account rotate-key` with three key improvements:

1. **Auto-generates keys** - No need to manually generate keys first
2. **Automatic backups** - Saves your old key to timestamped backup files
3. **Verification** - Confirms rotation succeeded by checking on-chain auth key

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/ThalaLabs/aptos-keyrotate/main/install.sh | bash
```

This will download and install `aptos-keyrotate` to `/usr/local/bin`.

## Usage

```bash
# Basic rotation (auto-generate new key)
aptos-keyrotate --profile my-wallet

# Rotate with specific new key
aptos-keyrotate --profile my-wallet --new-private-key-file ./new-key

# Save to new profile with custom backup location
aptos-keyrotate --profile my-wallet --save-to-profile my-wallet-rotated --backup-dir ~/backups

# Skip backup and confirmations
aptos-keyrotate --profile my-wallet --skip-backup --yes
```

## Options

```
Usage: aptos-keyrotate [OPTIONS]

Options:
    --profile PROFILE              Existing Aptos CLI profile name (required)
    --new-private-key-file FILE    Path to new private key (auto-generated if omitted)
    --save-to-profile PROFILE      Save rotated config to new profile name
    --backup-dir DIR               Backup directory for old keys (default: ./backups)
    --skip-backup                  Skip creating backup of old private key
    --yes                          Skip confirmation prompts
    -h, --help                     Show this help message
    -v, --version                  Show version information
```
