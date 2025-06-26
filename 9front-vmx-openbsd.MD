# OpenBSD on 9front vmx(1)

## How to Install

You may check the link below:

- [FQA 8 - Using 9front](https://fqa.9front.org/fqa8.html#8.7.5.1.3)

- [Plan9/Virtualisation](https://9lab.org/plan9/virtualisation/) 

## Troubleshooting

`vmx(1)` cannot read kernel image from the disk image, you should prepare kernel or ramdisk image from the OpenBSD.

For recent version of OpenBSD, `vmx(1)` may return the error message like 'unknown format' if you use the ramdisk kernel (such as `bsd77.rd`) to boot the virtual machine.

This is happened because when loading OpenBSD kernel, `vmx(1)` checks whether it has relevant ELF symbols. So, If you encountered error messages like *unknown format*, you may check the file type of the image.

