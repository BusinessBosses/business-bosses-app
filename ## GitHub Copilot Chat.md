## GitHub Copilot Chat

- Extension Version: 0.28.3 (prod)
- VS Code: vscode/1.101.1
- OS: Mac

## Network

User Settings:
```json
  "github.copilot.advanced.debug.useElectronFetcher": true,
  "github.copilot.advanced.debug.useNodeFetcher": false,
  "github.copilot.advanced.debug.useNodeFetchFetcher": true
```

Connecting to https://api.github.com:
- DNS ipv4 Lookup: 140.82.121.6 (3565 ms)
- DNS ipv6 Lookup: ::ffff:140.82.121.6 (2 ms)
- Proxy URL: None (0 ms)
- Electron fetch (configured): HTTP 200 (2821 ms)
- Node.js https: HTTP 200 (4329 ms)
- Node.js fetch: HTTP 200 (1418 ms)
- Helix fetch: HTTP 200 (1504 ms)

Connecting to https://api.individual.githubcopilot.com/_ping:
- DNS ipv4 Lookup: 140.82.112.21 (399 ms)
- DNS ipv6 Lookup: ::ffff:140.82.112.21 (2 ms)
- Proxy URL: None (1 ms)
- Electron fetch (configured): HTTP 200 (4023 ms)
- Node.js https: HTTP 200 (4853 ms)
- Node.js fetch: HTTP 200 (2340 ms)
- Helix fetch: HTTP 200 (3159 ms)

## Documentation

In corporate networks: [Troubleshooting firewall settings for GitHub Copilot](https://docs.github.com/en/copilot/troubleshooting-github-copilot/troubleshooting-firewall-settings-for-github-copilot).flutter run