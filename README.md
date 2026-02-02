# Aurora OS Custom

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for the original template.

## ISO

To generate a bootable iso, run `build-iso.sh` on a system with bluebuild installed.

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/blue-build/template
```

## Setup
### TailScale setup
`tailscale login` and follow instructions to log in.

`tailscale set --ssh` to enable SSH daemon.

Set up tailscale access rules in web console if needed.

### RustDesk setup
Add to `~/.config/rustdesk/RustDesk2.toml`:
```
direct-server = 'Y'
verification-method = 'use-permanent-password'
approve-mode = 'password'
allow-remote-config-modification = 'Y'
```

To set permanent rustdesk password:

`rustdesk --password <password>`

~~Allow permanent remote desktop permission for unattended access:~~

~~`sudo flatpak permission-set kde-authorized remote-desktop com.rustdesk.RustDesk yes`~~