# RDP Toolkit

A Python toolkit for basic RDP operations:

- Test for RDP connectivity
- Initiate RDP connection
- Push payloads (files) to remote hosts

## Usage

```
python rdp_toolkit.py
```

Edit the script to provide your target host, credentials, and payload paths.

## Requirements

Install dependencies:

```
pip install -r requirements.txt
```

## Note

- RDP initiation is platform-dependent (Windows: mstsc, Linux: xfreerdp/rdesktop).
- Payload push is a placeholder; implement SMB or other file transfer as needed. 