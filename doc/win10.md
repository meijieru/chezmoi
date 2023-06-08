# Win10 Setup

## Common

```bash
# First setting up onedrive
export ROAMING_DIR='${Onedrive-JHU}/settings/win10'
```

### System settings

- disable [shift-tab](https://superuser.com/a/1385457)

### Uninstall unneccesary apps

- Cortana
- 电影与电视
- 3D 查看器
- OneNote for win10

### Apps from win store

- Adobe PDF Reader
- Windows Terminal
  - Config file `${ROAMING_DIR}/windows_terminal/settings.json`
  - Use soft link
    ```cmd
    mklink ${dst} ${src}
    ```
- X410
  - TODO: use wslg instead
- LiquidText
- Ditto
- Auto Dark Mode X

Optional

- GestureSign

### Apps from scoop

- [Search](https://scoop.sh)

```ps1
scoop install git

scoop bucket add main
scoop bucket add extras
scoop bucket add nonportable
scoop bucket add dorado https://github.com/chawyehsu/dorado

scoop install 7zip aria2 git
scoop install vscode wezterm
scoop install autohotkey2 sharpkeys everything powertoys snipaste thisiswin11
scoop install fsviewer LICEcap potplayer
scoop install nextcloud zoom rufus teamviewer freedownloadmanager

# wsl utility
scoop bucket add .oki https://github.com/okibcn/Bucket  # for wslcompact
scoop install wslcompact

# other
scoop install wechat QQMusic obsidian bitwarden

# games
scoop bucket add games
scoop install yuzu vcredist2022
scoop install cemu-dev

echo "Check the optional packages"

# optional
# scoop install discord
# scoop install calibre-normal  # don't use calibre https://github.com/ScoopInstaller/Extras/issues/1765#issuecomment-466762524
# scoop install dropbox-np
```

- SharpKeys
  - Exchange `CapsLock` with `Left control`.
  - Load settings from `${Onedrive_jhu}/program/sharpkeys/win_keyboard.skl`
- AutoHotKey
  - Load setting by create shortcut from `${Onedrive_jhu}/program/ahk/*.ahk`
  - `win+r` and enter `shell:startup`, paste the shortcut
- Everything prompt for uac everytime, which doesn't occur in previous install
    - Just use the service when first start

### Apps from website

- [DisplayCal](https://displaycal.net/#download)
- [Huorong](https://www.huorong.cn/person5.html)
- [Ivacy](TODO)
- [Pulse Secure](TODO)
- [WizNote X](TODO)
- [Office](TODO)
- [Huawei Store](TODO)
- [Steam](TODO)
  - Install through the official website
  - Problematic through scoop

Optional

- [Lightroom](https://www.weidown.com/xiazai/5606.html)

  - Setting up the data following the [guide](https://www.tenforums.com/tutorials/131182-create-soft-hard-symbolic-links-windows.html)

    <!-- - lrcat & dir by `mklink /h ${dst} ${src}` -->

    ```cmd
    mklink /h D:picture\lrcat\meijieru.lrcat D:document\nextcloud\picture\lrcat\meijieru.lrcat
    ```

- [EasyCanvas](http://www.easynlight.com/)
- [Mathpix Snipping Tool](TODO)
- [SFTP Net Drive](TODO)
- [Slack](TODO)
- [Feishu](TODO)
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

### Matebook X Pro

#### Drivers

- [HW PCManager](https://consumer.huawei.com/cn/support/laptops/matebook-x-pro/)
  - Enable fingerprint
    - TODO
- Disable `Display Power Saving Technology` in intel control panel's power setting
