# Applications installed on my Android

__Note__: Two solutions for rebooting in recovery mode

1. By command line
    1. Make sure adb and fastboot are installed
    2. sudo adb reboot bootloader
2. Manually
    1. Power off smartphone
    2. Hold Volume Down & Power simultaneously

## 1. Install ADB & fastboot

```bash
sudo apt update
sudo apt install android-tools-adb android-tools-fastboot
```

To check that ADB is working:

1. Switch on the phone
2. Enable developper options (Click 7 seven times on Settings > About the phone > Build number)
3. Enable Settings > Developper options > Android debugging
4. On the phone authorized the computer to debug
5. Run `sudo adb devices`
6. Example output: "List of devices attached \n ZX1B34LQFB      device"

```bash
sudo adb reboot bootloader
# when the smartphone is asking to choose what to boot ("Normal", "Recovery"...)
sudo fastboot devices
```

## 2. Update TWRP

### 2.1 With the application (didn't work last time)

Didn't work last time:

- Couldn't go in recovery anymore, the error was: `wrong size boot partition`

1. Install "Official TWRP App" on the play store
2. Check for update in the app
3. If already up to date, there is nothing to do
4. If update available
    1. Download the `.img` through the application
    2. Reboot in recovery mode
    3. Select Install
    4. Select "Install image"
    5. Go in downloads and select the twrp.img
    6. Select the recovery partition
    7. Follow the instructions and boot the smartphone
    7. Reboot in recovery mode and check that it works

### 2.2 Manually (worked last time)

1. Go here: https://twrp.me/
2. Download the last release
3. Install it

```bash
wget <url_to_the_.img>
`[ "618e8e268d3808bbfbf7083ec9a44472  twrp-3.1.1-0-condor.img" = "`md5sum twrp-3.1.1-0-condor.img`" ] && echo OK || echo NOK`
mv twrp-3.1.1-0-condor.img twrp.img
sudo adb reboot bootloader
sudo fastboot flash recovery twrp.img
sudo fastboot reboot
```

## 3. Install new OS on smartphone

### 3.1 Download last condor version

Source: https://wiki.lineageos.org/devices/condor

1. Go on https://download.lineageos.org/condor
2. Check that the downloaded file is correct
    1. [ "`sha256sum lineage-14.1-20170821-nightly-condor-signed.zip`" = "54ef2d2b741e454763d1e011ada195047f385f7358352957ca49242c86dcea56  lineage-14.1-20170821-nightly-condor-signed.zip" ] && echo OK || echo NOK

### 3.2 Download the google apps

1. Download OpenGapps here http://opengapps.org/?api=7.1&variant=nano
    1. Select ARM Android 7.1 with aroma
    2. Check the file
    3. [ "`cat open_gapps-arm-7.1-aroma-20170825.zip.md5`" = "`md5sum open_gapps-arm-7.1-aroma-20170825.zip`" ] && echo OK || echo NOK

### 3.3 Upgrade

1. Transfer the condor zip file and the opengapps at the SD card root
2. Reboot in recovery mode as described above
3. Select "Recovery" in the fastboot menu
4. Select Install
5. Select Wipe and then Advanced Wipe
6. Select Cache, System and Data partitions to be wiped and then Swipe to Wipe
7. Go back to return to main menu, then select Install
8. Navigate to /sdcard, and select the LineageOS .zip package
9. Follow the on-screen prompts to install the package
10. Go back with the arrow
11. Select the open_gapps file
12. Follow the on-screen prompts to install the package
    1. Select the apps you want to install (Youtube, Google maps, Google play games)
    2. "Prevent automatic Stock removals":
        1. If you have select Google messaging before and you don't select "Messaging"
        2. It will remove the Stock app (means original app) "Messaging"
13. Reboot
14. Follow the setup instructions

## 4. Install apps

1. Change the battery icon (Settings > Status bar > Battery status style)
2. Change the sleep to 10 minutes (Settings > Display > Sleep)
3. Change the wallpaper
4. Remove every widgets
6. Add the French keyboard
5. Install F-Droid
6. Install F-Droid applications in this order:
    - APV PDF Viewer
    - DAVdroid (will propose to install OpenTasks, Groups are per contact categories)
    - OpenTasks
    - K-9 Mail
        - Accounts
        - Signatures
    - Barcode Scanner
    - OpenKeyChain
        - Import your key
        - Change the password
7. Install PlayStore applications in this order:
    - Messenger
    - Whatsapp
    - Snapchat
    - Telegram
    - Play games
    - Maps
    - Youtube
    - HSBC Mobile Banking
    - Linguee
    - English French Larousse
    - Firefox
        - Synchronize data
    - Vivace
    - Dropbox
    - Nextcloud
        - Setup photos sending
