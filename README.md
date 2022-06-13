## Download and run the installation script

```
pacman -Sy git
git clone https://github.com/b31ngd3v/senpai.git
cd arch-install
./installer.sh
```

## Connect to wifi

```
iwctl --passphrase=PASSPHRASE station DEVICE connect SSID
```

## Common errors and their solutions

### error: key could not be imported

```
pacman -Scc
gpg --refresh-keys
pacman-key --init
pacman-key --populate
```
