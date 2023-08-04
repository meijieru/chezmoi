## Common

### Settings

#### Font

- [Fix Chinese charactors](https://iamcristye.github.io/Font/)

#### System

- disable [shift-alt](https://superuser.com/a/1385457)

Optional

- Intel Laptop
  - Disable `Display Power Saving Technology` in intel control panel's power setting

#### App

##### SharpKeys

- Exchange `CapsLock` with `Left control`.
- Load settings from `${Onedrive_jhu}/program/sharpkeys/win_keyboard.skl`

##### AutoHotKey

- Load setting by create shortcut from `${Onedrive_jhu}/program/ahk/*.ahk`
- `win+r` and enter `shell:startup`, paste the shortcut

##### Everything

prompt for uac everytime, which doesn't occur in previous install

- Just use the service when first start

##### Chrome

For 2-in-1, disable [tablet mode](https://www.howtogeek.com/790530/how-to-disable-tablet-mode-in-google-chrome/) which result in huge title bar

If installed through scoop, setting it as the default browser need a [modification](https://github.com/ScoopInstaller/Scoop/issues/3657#issuecomment-534673530)

Ensure `chrome://gpu` doesn't show any problem. If hw decode disabled, go to `chrome://flags` and enable `Override software rendering list`

##### Windows terminal

Config file `${ROAMING_DIR}/windows_terminal/settings.json`

```cmd
# Use soft link
mklink ${dst} ${src}
```

##### Lightroom

Setting up the data following the [guide](https://www.tenforums.com/tutorials/131182-create-soft-hard-symbolic-links-windows.html)

<!-- - lrcat & dir by `mklink /h ${dst} ${src}` -->

```powershell
cd ${data}/picture/lrcat/
New-Item -ItemType HardLink -Path "meijieru.lrcat" -Target "C:\Users\meiji\OneDrive - Johns Hopkins\picture\lrcat\meijieru.lrcat"
```

##### Sogou Pinyin

Disable `ctrl+,` by changing to others, TODO: check it later

##### Wechat

- Disable auto update
- Move files to `${data}/document/wechat`

### Uninstall unneccesary apps

### Apps from win store

- LiquidText
- Ditto
- Auto Dark Mode X
- Huorong
- snipaste

Optional

- GestureSign
- Nebo
- X410
  - use wslg instead

### Apps from scoop

- [Search](https://scoop.sh)

```ps1
scoop install git

scoop bucket add main
scoop bucket add extras
scoop bucket add nonportable
scoop bucket add dorado https://github.com/chawyehsu/dorado

scoop install 7zip aria2 git
scoop install vscode wezterm neovide
scoop install autohotkey sharpkeys everything powertoys mathpix
scoop install fsviewer potplayer
scoop install nextcloud zoom rufus teamviewer freedownloadmanager
scoop install displaycal argyllcms@2.1.2

# wsl utility
scoop bucket add .oki https://github.com/okibcn/Bucket  # for wslcompact
scoop install wslcompact

# other
scoop install wechat qqmusic obsidian bitwarden

# games
scoop bucket add games
scoop install yuzu vcredist2022
# scoop install cemu-dev

echo "Check the optional packages"

# optional
# scoop install discord
# scoop install calibre-normal  # don't use calibre https://github.com/ScoopInstaller/Extras/issues/1765#issuecomment-466762524
# scoop install dropbox-np
# scoop install LICEcap
```

### Apps from website

- [BloatyNosy](https://github.com/builtbybel/BloatyNosy/releases)
- [Chrome](https://www.google.com/chrome/)
- [Sogou](https://shurufa.sogou.com/)
- [Mind Master](https://www.edrawsoft.cn/mindmaster/)
- [Ivacy](TODO)
- [Pulse Secure](TODO)
- [WizNote X](TODO)
- [Office](TODO)
- [Huawei Store](TODO)
- [Steam](TODO)
  - Install through the official website
  - Problematic through scoop

Optional

- Install [CC](https://creativecloud.adobe.com/apps/all/desktop?action=install&source=apps&productId=creative-cloud) & [Lightroom](https://www.cybermania.ws/software/adobe-genp/)
- [BaiduNetDisk](TODO)

### StartUp

TODO

### WSL

```sh
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

TODO

### Android Subsystem

## Machine Specific
