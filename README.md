
## Running the script

Clone the project

```bash
  git clone https://github.com/tyree-z/tailscale-sign-mullvad.git
```

Go to the project directory

```bash
  cd tailscale-sign-mullvad
```

Edit the script

```bash
  nano tailnetlock.sh
```

Go to https://login.tailscale.com/admin/machines/ find a "Signing Node" and copy "Tailnet lock key" under "Machine Details" and replace 

```bash
 tlpub="tlpub:<Signing Node TLPUB>"
```

Run the script

```bash
  sh tailnetlock.sh
```

