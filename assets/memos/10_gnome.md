# GNOME memos

## Slideshow as background

**Source:** https://opensource.com/article/17/12/create-your-own-wallpaper-slideshow-gnome

- Create the folder `$HOME/.local/share/gnome-background-properties/`
- Create a file in it containing the following:

```xml
CTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
    <wallpaper deleted="false">
        <name>Opensource.com Wallpapers</name>
        <filename>/home/paul/Pictures/Wallpapers/wallpapers.xml</filename>
        <options>zoom</options>
    </wallpaper>
</wallpapers>
```

- An example of file wallpapers.xml:

```xml
<?xml version="1.0" ?>
<background>
    <static>
        <!-- Duration in seconds to display the background -->
        <duration>30.0</duration>
        <file>/home/paul/Pictures/Wallpapers/w1.jpg</file>
    </static>
    <transition>
    <!-- Duration of the transition in seconds, default is 2 seconds -->
    <duration>1</duration>
        <from>/home/paul/Pictures/Wallpapers/w1.jpg</from>
        <to>/home/paul/Pictures/Wallpapers/w2.jpg</to>
        </transition>
    <static>
        <duration>30.0</duration>
        <file>/home/paul/Pictures/Wallpapers/w2.jpg</file>
    </static>
    <transition>
        <duration>1</duration>
        <from>/home/paul/Pictures/Wallpapers/w2.jpg</from>
        <to>/home/paul/Pictures/Wallpapers/w3.jpg</to>
    </transition>
    <static>
        <duration>30.0</duration>
        <file>/home/paul/Pictures/Wallpapers/w3.jpg</file>
    </static>
    <transition>
        <duration>1</duration>
        <from>/home/paul/Pictures/Wallpapers/w3.jpg</from>
        <to>/home/paul/Pictures/Wallpapers/w1.jpg</to>
    </transition>
</background>
```
