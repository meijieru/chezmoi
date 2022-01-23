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

- Windows Terminal
  - Config file `${ROAMING_DIR}/windows_terminal/settings.json`
  - Use soft link
    ```cmd
    mklink ${dst} ${src}
    ```
- X410
  - Will deprecate once wsl2 GUI is supported
- Snipaste
- Skype
- LiquidText

Optional

- GestureSign
- 弹弹 play
- Pulse Secure
  - **Currently not able to connect to school vpn**

### Apps from scoop

- [Search](https://rasa.github.io/scoop-directory/search) from [scoop-directory](https://github.com/rasa/scoop-directory)

```ps1
scoop install git

scoop bucket add extras
scoop bucket add nonportable
scoop bucket add dorado https://github.com/chawyehsu/dorado
scoop bucket add user_carrot https://github.com/huangnauh/carrot.git  # for chezmoi

scoop install 7zip aria2 git
scoop install vscode wezterm
scoop install AutoHotKey sharpkeys everything powertoys ditto chezmoi
scoop install fsviewer LICEcap potplayer
scoop install nextcloud zoom rufus teamviewer freedownloadmanager

echo "Check the optional packages"
# optional

# scoop install discord
# scoop install calibre-normal  # don't use calibre https://github.com/ScoopInstaller/Extras/issues/1765#issuecomment-466762524
# scoop install alacritty
# scoop install dropbox-np
```

- Steam

- SharpKeys
  - Exchange `CapsLock` with `Left control`.
  - Load settings from `${ROAMING_DIR}/sharpkeys/win10_keyboard.skl`
- AutoHotKey
  - Load setting by create shortcut from `${Onedrive_jhu}/program/ahk/*.ahk`
  - `win+r` and enter `shell:startup`, paste the shortcut
- Ditto
  - Set the `General/Database Path = C:\Users\meiji\OneDrive\应用程序\ditto\Ditto.db`
- PotPlayer
  - enable [Bluesky frame rate converter](https://bluesky-soft.com/en/BlueskyFRC.html)

**TODO: Reinstall**

- Adobe PDF Reader
- Chrome
- Wechat

**FIXME**

- everything prompt for uac everytime, which doesn't occur in previous install
- PotPlayer frame

### Apps from website

- [DisplayCal](https://displaycal.net/#download)
- [Bandzip](https://www.bandisoft.com/bandizip/old/6/)
- [Huorong](https://www.huorong.cn/person5.html)
- [Ivacy](TODO)
- [Pulse Secure](TODO)
- [TIM](TODO)
- [WizNote X](TODO)
- [Office](TODO)
- [Auto Dark Mode X](https://github.com/AutoDarkMode/Windows-Auto-Night-Mode/releases)
- [Bluesky Frame Rate Converter](TODO)

Optional

- [Lightroom](https://www.weidown.com/xiazai/5606.html)

  - Setting up the data following the [guide](https://www.tenforums.com/tutorials/131182-create-soft-hard-symbolic-links-windows.html)

    <!-- - lrcat & dir by `mklink /h ${dst} ${src}` -->

    ```cmd
    mklink /h D:picture\lrcat\meijieru.lrcat D:document\nextcloud\picture\lrcat\meijieru.lrcat
    ```

- [EasyCanvas](http://www.easynlight.com/)
- [MacType](TODO)
- [Mathpix Snipping Tool](TODO)
- [QQ Music](TODO)
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
