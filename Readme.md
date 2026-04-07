# Valtor AI

**Privacy proxy for LLM APIs - mask your secrets before they leave your machine.**

Valtor sits between your tools and LLM providers, automatically detecting and masking sensitive data in real-time. Your API keys, tokens, and credentials never reach external servers.

## How It Works

```
Your Code → Valtor Proxy → LLM API
              ↓
         PII Detection
         & Masking
```

**Before (what you send):**
```
Please help me debug this:
export GITHUB_TOKEN=ghp_R8x2mK9vLpQ4nJ7wT1yF3hB6cD0eA5sG2uXk
export AWS_SECRET=AKIAIOSFODNN7EXAMPLE
```

**After (what LLM sees):**
```
Please help me debug this:
export GITHUB_TOKEN=[MASKED_GITHUB_TOKEN_0]
export AWS_SECRET=[MASKED_AWS_KEY_0]
```

## Supported Platforms

- Claude Code
- Claude Web
- ChatGPT Web
- Grok

## Installation

### macOS (Homebrew)

```bash
brew install valtorai/tap/valtor
```

### Manual Install

1. Download the appropriate archive for your platform
2. Extract: `tar -xzf valtor-*.tar.gz` (or unzip for Windows)
3. Move to PATH: `sudo mv valtor /usr/local/bin/`
4. Initialize: `valtor init`
5. Start: `valtor start`

## Downloads

| Platform | Architecture | File |
|----------|--------------|------|
| macOS | Apple Silicon (M1/M2/M3) | `valtor-darwin-arm64.tar.gz` |
| macOS | Intel | `valtor-darwin-amd64.tar.gz` |
| Linux | x64 | `valtor-linux-amd64.tar.gz` |
| Linux | ARM64 | `valtor-linux-arm64.tar.gz` |
| Windows | x64 | `valtor-windows-amd64.zip` |

## Verify Checksums

```bash
sha256sum -c checksums.txt
```

## License

Proprietary - Valtor AI
