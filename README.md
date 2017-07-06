# emergent7-vm

This project uses Vagrant to create an Ubuntu 16.04 virtual machine,
and uses it to build [Emergent
7.0.1](https://grey.colorado.edu/emergent/index.php/Main_Page) from source.

Why a VM? Emergent 7.0.1 is near impossible to build from source on
modern platforms.  This automates the process and makes it impervious
to OS and dependency updates. It also makes it easy to modify the
Emergent source code (just edit the code in `/usr/local/src/emergent-7.0.1`,
and run `make && make install` to rebuild.)

### Prerequisites
You need to install [VirtualBox](https://www.virtualbox.org). If you have a Mac
and use the [Homebrew](https://brew.sh) package manager, this is as easy as
executing

```
$ brew cask install virtualbox
```

### Getting Started

**Step 1:** Download the VM image here. (TODO: make link)

**Step 2:** Import the image into VirtualBox. From the VirtualBox home screen,

**Step 3:** Start the VM by double-clicking it on the VirtualBox home screen.

**Step 4:** Add a shared folder. To access files on your computer, you can share
a folder between the host and guest operating systems. With the VM running,
click *Devices* > *Shared Folders* > *Shared Folder Settings*. Click the small
plus sign to add a shared folder. Make sure to check the "Read only" and "Make
permanent" checkboxes.

Once you've added the shared folder, reboot the VM. After it restarts, you will
find your shared folder in the sidebar of the "Files" application, and at the
path /media/sf_your_shared_folder_name`.

**Next steps**

You can access Emergent by double-clicking the shortcut on the desktop.

If you want to modify and recompile the Emergent source code, you will find it
in `/usr/local/src`.

If you need root access for installing software or other tasks,
the credentials are

```
username: ubuntu
password: ubuntu
```

The underlying operating system is Ubuntu 16.04 Xenial Xerus, so you can follow
any Ubuntu documentation or tutorials on the internet. The VM image runs a
faster and lighter-weight window manager to speed things up, but the underlying
operating system is still Ubuntu.

### For Maintainers
This image should work into the near future. However, if the guest's VirtualBox
Guest Additions become too old, or if it is necessary to move to another Ubuntu
release, the image will need to be rebuilt. Here are the steps:

1. Install the latest Lubuntu LTS desktop edition into a VirtualBox
   VM. Be sure to make a dynamically-expanding hard drive (I set the
   cap to 64GB.) Set the username and password to be `ubuntu` and
   `ubuntu`, respectively. Enable automatic login.
2. Update the system packages: `sudo apt-get update && sudo apt-get upgrade`.
3. Install the VirtualBox Guest Additions from the provided ISO (see
   documentation
   [here](https://www.virtualbox.org/manual/ch04.html#idm1959).
5. Clone this repository, and run the setup script: `sudo
   ./setup_vm.sh`. Then run the install script (`sudo
   ./install_emergent.sh`).
6. From VirtualBox, export the VM as an OVA archive.

### Support
You can file an issue on the Github repository, or email Daniel Greenidge.
If you don't know his email, look on the
[Princeton Website](https://www.princeton.edu/search/people-advanced).
