# User-friendly guide to setup a fresh `gefs` filesystem on RPi4 (on 9front)


## Prerequisite

- A storage device to install the 9front OS (e.g., an SD card)
- An additional arm64 system running 9front (e.g., QEMU)

## Write 9front image on 9front

This step is **not required** but is provided for user convenience. You may skip it and manually install `FAT32` boot section for your RPi, but personally, I don't find any advantages in doing so.

Download the appropriate image on [9front release page](http://9front.org/releases) and use `cat(1)` or `dd(1)` to write to the storage device you intend to use.

The image file you downloaded is built using the script `/sys/lib/dist/mkfile`. As for now, the RPi3 image uses `hjfs` file system and allocates only 1885MB of storage, which isn't very large.

If desired, you can modify the following section of `/sys/lib/dist/mkfile` to increase the size and build a custom `hjfs` image.


```
082    %.pi3.img:
...
103        fatfiles=(/env/config.txt /env/cmdline.txt $bootcode $kernel)
104        mb=1885 # storage vendors idea of 2GB
105        mk $target.$pid.disk
106        mv $target.$pid.disk $target
...
```

However, if you're planning to use more than 10GB of storage, this is not a clean solution.
You’ll also need to manually modify the file system setup section in `/sys/lib/dist/mkfile` to switch to `gefs`.

```
082    %.pi3.img:
...
103        fatfiles=(/env/config.txt /env/cmdline.txt $bootcode $kernel)
104        mb=1885 # storage vendors idea of 2GB
105        mk $target.$pid.disk
106        mv $target.$pid.disk $target
...
```

## Boot another 9front system and mount the storage

You can boot a 9front system on arm64 using either a USB flash drive or QEMU. It's up to you.

Once booted, mount the prepared storage and run `inst/start` script.

Type `configfs` and select `gefs` file system.

After that, use `partdisk` to remove the existing `PLAN9` partition and recreate it with the size you want. 

**Do not** remove `FAT32` partition. That's the only reason we used the image from the 9front web page.

If you successfully make a new `PLAN9` partition, type `!rc` in the `inst/start` script and subdivide the `PLAN9` partition into `NVRAM`, and `fs`.

**Do not** blindly copy the command below. Replace `sdXX` to the storage device you want to install the `gefs` file system on.

```
% disk/prep -bw -a^(nvram fs) /dev/sdXX/plan9
% exit
```

After this, you can follow the normal install steps like `mountfs`, `confignet`, `mountdist`, `copydist`, `ndbsetup`, and `tzsetup` - except the `bootsetup` script. **Do not** run the `bootsetup` script.

## Notes

Please inform me if there is any error on the guide.


## References

- [FQA](http://fqa.9front.org)

- `/sys/lib/dist/mkfile`
