# Using snapshots on gefs filesystem (on 9front)

## Caveats

This article is a personal note. I'm not sure whether this is the preferred way to use `gefs`.
If you choose to follow this article, do so at your own risk. Please consult more experienced users or the system developers.

## Creating snapshots

By default, `gefs` creates daily, hourly, and by-the-minute snapshots for the *main* snapshot, which is used by default when booting.
If you want to create a manual snapshot (preferably immutable), you can just use the `gefs` console.

```
% con -C /srv/gefs.cmd
gefs% snap main new
```

Without any parameters, the snapshot is created as immutable. If you want a mutable snapshot, you should provide the `-m` parameter.

## Backup from snapshots

If you want to retrieve your data from a snapshot, you can simply use `mount(1)`.

```
% mount /srv/gefs /n/snapshot snapshot
% cp /n/snapshot/home/user/mypreciousfile $home/
...
```

If your filesystem is corrupted, you may check which snapshot is uncorrupted and can be used as a backup point.

```
% con -C /srv/gefs.cmd
gefs% check
...
checking snap main@day.2025.06.03_19:48:30: (e87434000,3e7d4d975dfefce2,365)
checking snap main@day.2025.06.03_21:24:31: (e8714c000,4ca8a07450efddc2,39d)
checking snap main@day.2025.06.03_21:58:04: (e804cc000,bb2452de6dd27b7d,410)
checking snap main@day.2025.06.03_22:59:42: (e820c0000,9295b4f490c59590,59c)
warning: ...
...
gefs% snap main@day.2025.06.03_21:58:04 backuppoint
```

After this, you may use your USB thumb drive to boot up the live system and use `gefs(4)` to mount the filesystem and make a new *main* snapshot.
Make sure to use the **mutable** option. `gefs` doesn't allow changing the mutability of an existing snapshot (at this point).

```
% gefs -f /dev/sdE0/fs
% con -C /srv/gefs.cmd
gefs% snap -d main
gefs% snap -m backuppoint main
gefs% halt
```

## References

- [gefs(4)](http://man.9front.org/4/gefs)
- [gefs(8)](http://man.9front.org/8/gefs)

