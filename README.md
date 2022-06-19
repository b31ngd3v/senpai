# Senpai - i use arch btw

![preview](https://user-images.githubusercontent.com/64733912/174498063-09555ee4-f545-4fc3-986e-a1f07787c5da.jpg)

## Download and Run

```
pacman -Sy git
git clone -b virtualbox https://github.com/b31ngd3v/senpai.git
cd senpai
./installer.sh
```

## Keyboard Shortcuts

### dwm shortcuts

| Keyboard Shortcut                                    | Function                                         |
| ---------------------------------------------------- | ------------------------------------------------ |
| <kbd>mod</kbd> + <kbd>return</kbd>                   | st                                               |
| <kbd>mod</kbd> + <kbd>space</kbd>                    | dmenu                                            |
| <kbd>mod</kbd> + <kbd>b</kbd>                        | toggle bar                                       |
| <kbd>mod</kbd> + <kbd>j</kbd>                        | focus on the left window                         |
| <kbd>mod</kbd> + <kbd>k</kbd>                        | focus on the right window                        |
| <kbd>mod</kbd> + <kbd>h</kbd>                        | resize the window (left)                         |
| <kbd>mod</kbd> + <kbd>l</kbd>                        | resize the window (right)                        |
| <kbd>mod</kbd> + <kbd>i</kbd>                        | window side by side                              |
| <kbd>mod</kbd> + <kbd>d</kbd>                        | window on top of each other                      |
| <kbd>mod</kbd> + <kbd>w</kbd>                        | close window                                     |
| <kbd>mod</kbd> + <kbd>t</kbd>                        | tiling layout                                    |
| <kbd>mod</kbd> + <kbd>f</kbd>                        | floating layout                                  |
| <kbd>mod</kbd> + <kbd>m</kbd>                        | monocle layout                                   |
| <kbd>mod</kbd> + <kbd>p</kbd>                        | switch between tiling layout and floating layout |
| <kbd>mod</kbd> + <kbd>shift</kbd> + <kbd>space</kbd> | floating window                                  |
| <kbd>mod</kbd> + <kbd>0</kbd>                        | all windows in one tag                           |
| <kbd>mod</kbd> + <kbd>F5</kbd>                       | reload color scheme                              |
| <kbd>mod</kbd> + <kbd>1 - 9</kbd>                    | switch between tags                              |
| <kbd>mod</kbd> + <kbd>shift</kbd> + <kbd>q</kbd>     | restart dwm                                      |

### st shortcuts

| Keyboard Shortcut             | Function                                    |
| ----------------------------- | ------------------------------------------- |
| <kbd>alt</kbd> + <kbd>c</kbd> | copy                                        |
| <kbd>alt</kbd> + <kbd>v</kbd> | paste                                       |
| <kbd>alt</kbd> + <kbd>u</kbd> | scroll up (page up)                         |
| <kbd>alt</kbd> + <kbd>d</kbd> | scroll down (page down)                     |
| <kbd>alt</kbd> + <kbd>k</kbd> | scroll up (line up)                         |
| <kbd>alt</kbd> + <kbd>j</kbd> | scroll down (line down)                     |
| <kbd>alt</kbd> + <kbd>l</kbd> | loop through all links in terminal and copy |
| <kbd>alt</kbd> + <kbd>o</kbd> | open copied link                            |

### sxhkd shortcuts

| Keyboard Shortcut                 | Function                 |
| --------------------------------- | ------------------------ |
| <kbd>mod</kbd> + <kbd>a</kbd>     | firefox                  |
| <kbd>mod</kbd> + <kbd>x</kbd>     | lock                     |
| <kbd>PrtSc</kbd>                  | screenshot (select)      |
| <kbd>mod</kbd> + <kbd>PrtSc</kbd> | screenshot (full screen) |

## Tips and Tricks

### Download wallpapers

Download wallpapers from wallheaven with [waldl](https://github.com/pystardust/waldl) by [pystardust](https://github.com/pystardust). You can launch waldl from dmenu.

I modified the original script to match the font and the color scheme provided by pywal.

### Change Screen Resolution

You can set your screen resolution with xrandr. Type `xrandr -s <width>x<height>`.

And to make the change permanent add this line `xrandr -s <width>x<height> &` to your `.xinitrc` file.
