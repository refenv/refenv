# Notes

## Automating the Ubuntu Installer

The Ubuntu installer changed to something modern in the bionic release, however,
it still supports the oldschool automation process inherited from the Debian
Installer, namely preseeding.

Seems like sound tradition in the OS manual for Debian and Ubuntu is to include
documentation, along with an example preseed file. How about that?

You just have to RTFM, like all the way in the back of Debian/Ubuntu
installation guides[1][2][3][4], also, one can perform a manual installation, then
after rebooting, execute:

```bash
sudo apt-get install debconf-utils
sudo debconf-get-selections --installer > this.preseed
sudo debconf-get-selections >> this.preseed
```

## Automating the CentOS installation

Kickstart?

# References

[1] https://www.debian.org/releases/stable/installmanual
[2] https://help.ubuntu.com/lts/installation-guide/
[3] https://help.ubuntu.com/lts/installation-guide/amd64/ch04s06.html
[4] https://help.ubuntu.com/lts/installation-guide/amd64/apb.html
[3] https://wiki.ubuntu.com/UbiquityAutomation

