Maintaining your own OpenWrt flavor
=======
For BoardFarm we needed a way to maintain configurations of OpenWrt for multiple versions
with a particular set of settings (set a particular board type) and packages needed
for running tests. At the same time, we wanted this flavor to be easy to maintain and
update. We didn't find anything else that quite was what we were looking for so I
created a quick script to maintain this.

How it works
===
The main script is `build.sh`.

The main arguments are the following:
* `cc [clean]`: builds a copy of Chaos Calmer, with the optional `clean` argument
to clean the CC build directory (run `make clean`)
* `dd [clean]`: builds a copy of Designated Driver, with the optional `clean` argument
to clean the CC build directory (run `make clean`)

These commands run builds as follows:
* copy the matching config file (`cc.config` or `dd.config`) into the build directory
* copy the matching feeds file (`cc.feeds.conf` or `dd.feeds.conf`) to `feeds.conf`
in the build directory
* adds the matching local package feed (`cc-feed` or `dd-feed`) to the new
`feeds.conf` in the build directory
* updates the feeds
* installs all the packages from the feeds
* runs `make defconfig` and then `make V=s`


Convenience features
===
You can also update your `cc.config` or `dd.config` from the build directory using
`update-cc` or `update-dd`. This is useful when you change the selected packages in your
build directory but what the save the config for later usage with the `cc` or `dd`
commands.
