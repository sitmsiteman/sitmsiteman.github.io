# OpenBSD on 9front vmx(1)

## How to Install

There are plenty of guides on how to install OpenBSD on 9front `vmx(1)`, so I'm not going to repeat them here.

You may check the link below:

- [FQA 8 - Using 9front](https://fqa.9front.org/fqa8.html#8.7.5.1.3)

- [Plan9/Virtualisation](https://9lab.org/plan9/virtualisation/) 

- [Using vmx; Running Linux Mint in a virtual machine on 9Front ](https://www.youtube.com/watch?v=0gGgO_hCkWA)

## Troubleshooting

This section is the main reason I wrote this post.

`vmx(1)` cannot read the kernel image directly from the disk image — you need to provide the kernel or ramdisk image from your host system.

For recent versions of OpenBSD, `vmx(1)` may return an error like `unknown format` when using a ramdisk kernel (such as `bsd.rd`) to boot the virtual machine:

```
cpu% vmx [...] bsd.rd
vmx: bsd.rd: unknown format
```

This happens because when loading an OpenBSD kernel, `vmx(1)` checks whether it contains relevant ELF symbols:

`/sys/src/cmd/vmx/ksetup.c:727,744`

```
static int
tryelf(void)
{
	char *s, *t;

	if(!elfheaders()) return 0;
	elfdata();
	if(!elfsymbols()) return 0;
	s = symaddr(elfsym("ostype"));
	if(s != nil && strcmp(s, "OpenBSD") == 0)
		return obsdload();
	/* from 6.9 up, bsd.rd has just these syms */
	s = symaddr(elfsym("rd_root_image"));
	t = symaddr(elfsym("rd_root_size"));
	if(s != nil && t != nil)
		return obsdload();
	return 0;
}
```


So, If you encounter an error message like *unknown format*, you should check the file type of the image:

```
cpu% file bsd.rd
bsd.rd: gzip compressed
```

What you need to do is simple: just use `gunzip(1)` to decompress the image. You'll then get a proper image that `vmx(1)` can boot.


```
cpu% file bsd.rd
bsd77.rd: AMD64 ELF executable
```

