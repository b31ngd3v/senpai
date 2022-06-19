# Senpai - i use arch btw

![preview](https://user-images.githubusercontent.com/64733912/174498063-09555ee4-f545-4fc3-986e-a1f07787c5da.jpg)

## Download and Run

```
pacman -Sy git
git clone https://github.com/b31ngd3v/senpai.git
cd senpai
./installer.sh
```

## Connect to wifi

```
iwctl --passphrase=PASSPHRASE station DEVICE connect SSID
```

## Tips and Tricks

### Virtualbox

https://github.com/b31ngd3v/senpai/tree/virtualbox

### Download wallpapers

Download wallpapers from wallheaven with [waldl](https://github.com/pystardust/waldl) by [pystardust](https://github.com/pystardust). You can launch waldl from dmenu.

I modified the original script to match the font and the color scheme provided by pywal.

### Installation error git [err: key could not be imported]

Before cloning this repo, you have to download git first, if you face key import error while installing git, just update the mirrors and it will work just fine.

You can update the mirrorlist using this command: `reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist`

### Partitioning

Sometimes automatic partitioning does work, while booting for the first time it may say that it failed to mount the EFI partition, then you have to start from the scratch again and the only solution is to use manual pertitioning.

### Screen Tearing [err: DRM version X.XX.X but this driver is only compatible with X.XX.X]

If you face this error then you have an old gpu, so the TearFree option will not work for you out of the box, to fix this error first login as root, and then delete this `/etc/X11/xorg.conf.d/20-XXXXX-gpu.conf` file.
