# aptos-keyrotate

Handles Aptos account key rotation with automatic backups, safety checks, and rollback.

## Why use this?

`aptos-keyrotate` wraps `aptos account rotate-key` with key safety improvements:

1. **Auto-generates keys** - No need to manually generate keys first
2. **Mandatory backups** - Always saves your old key to timestamped backup files
3. **In-place updates** - Updates your profile directly (no profile proliferation)
4. **Automatic rollback** - Restores old key if rotation verification fails
5. **Verification** - Confirms rotation succeeded by checking on-chain auth key and testing profile functionality

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/ThalaLabs/aptos-keyrotate/main/install.sh | bash
```

This will download and install `aptos-keyrotate` to `/usr/local/bin`.

## Usage

```bash
# Basic rotation (auto-generate new key, backup to ./backups)
aptos-keyrotate --profile my-wallet

# Rotate with specific new key
aptos-keyrotate --profile my-wallet --new-private-key-file ./new-key

# Use custom backup location
aptos-keyrotate --profile my-wallet --backup-dir ~/backups

# Skip confirmation prompts
aptos-keyrotate --profile my-wallet --yes
```

## Options

```
Usage: aptos-keyrotate [OPTIONS]

Options:
    --profile PROFILE              Existing Aptos CLI profile name (required)
    --new-private-key-file FILE    Path to new private key (auto-generated if omitted)
    --backup-dir DIR               Backup directory for old keys (default: ./backups)
    --yes                          Skip confirmation prompts
    -h, --help                     Show this help message
    -v, --version                  Show version information

Safety Features:
    • Old private key is ALWAYS backed up before rotation
    • Profile is updated in-place with new key after successful rotation
    • Automatic rollback if rotation verification fails
```

## How it works

1. **Backup**: Creates timestamped backup of your current private key (mandatory)
2. **Rotate**: Executes the on-chain key rotation transaction
3. **Update**: Updates your profile in-place with the new private key
4. **Verify**:
   - Checks the on-chain authentication key actually changed
   - Tests that the new profile can query account info
5. **Rollback**: If verification fails, automatically restores the old key from backup

Your old private keys are safely stored in the backup directory for recovery if needed.
