# Changelog for DreamSDK

**DreamSDK** is a modern, ready-to-use environment for the **Sega Dreamcast** development designed for the **Microsoft Windows** platform.

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [R3] - 2020-01-DD
### Added
- Some useful links were added in the **Windows Start** menu.
- Support of **CDFS** images in **Code::Blocks**: You have now the possibility to simulate a virtual CD-ROM through an ISO file, when selecting the appropriate option when creating a project in **Code::Blocks**.
- Support for `libkosfat` addon library.
- This **CHANGELOG** file to hopefully serve as an evolving example of a
  standardized open source project **CHANGELOG**.

### Improved
- An offline version of **KallistiOS**, **KallistiOS Ports** and **Dreamcast Tool** are now integrated in the package. But it's strongly recommanded to use the online repositories!
- Better handling of prerequisites: **Git**, **Python** and **Subversion Client (SVN)** are not mandatory in all the cases, this depends now of your choice. **Git** is mandatory only if you use online repositories, **Python** and **Subversion Client** are always optional but preferred if you have the possibility to install these.
- When installing **Code::Blocks**, the process of updating user's configuration files is better. Now the **Setup** process detects all usable configuration files and patch them if possible.
- In the **DreamSDK Manager** tool, URL for the **Git** repositories may be changed.
- Better support for **ARP** (creation of the tool **FastARP**). It uses the classic `arp` command in **Windows XP** and `netsh` in modern **Windows**.
- **MakeDisc**: The `bootstrap` parameter is now optional. It will try to detect the `IP.BIN` from the current directory or directly in the directory where the `1ST_READ.BIN` file is located.
- The installation of **GNU Debugger (GDB) for SuperH** is better; and **Python** extensions may be enabled/disabled on user request (previously, **GDB for SuperH** was linked to **Python 2.7** only).

### Fixed
- **KallistiOS**, **KallistiOS Ports** and **Dreamcast Tool** repositories are now the **Nitro** versions from [Simulant Engine](https://gitlab.com/simulant/community/ "Simulant Engine") instead of official one as these contains various community improvements and fixes.
- In **Code::Blocks**, an issue when generating **Romdisk** from projects with spaces in their name has been fixed.
- **MakeDisc**: An little cosmetic problem has been fixed.

### Updated
- **GNU Compiler Collection (GCC) for SuperH** and **AICA** is now `4.7.4`, as this version includes several fixes for `sh-elf` target.
- **GNU Compiler Collection (GCC) for Win32** is now `8.2.0`.
- **GNU Debugger (GDB) for SuperH** is now `8.3.1`.
- **DreamSDK Manager** was updated to display more useful information like repositories versions or environment information.
- The help file was updated to reflect all the changes of this release.

## [R2] - 2019-03-05
### Added
- Full **Code::Blocks IDE** integration, including debugging on the real hardware, directly from the IDE!
- A lot of new tools are included now, like **MakeDisc**, allowing you to create CD releases of your programs.

### Updated
- **DreamSDK Manager** was redesigned and improved a lot.
- The Help content was improved a lot and it's now available online (and of course, it's still available in the package too).

## [R1] - 2018-11-25
### Added
- Fast & easy to install: just double-click on the setup file and let the program install & configure everything for you.
- Ready to use: All the required toolchains (for the **SuperH** & **Yamaha AICA**) are already prebuilt and ready-to-use.
- Lightweight: Thanks to the **MinGW/MSYS** environment, the space used on the disk is minimal.
- Configurable & upgradable: With the included **DreamSDK Manager** tool, manage **DreamSDK** components really easily.
- Respectful of the standards: **DreamSDK** is 100% compliant with the **KallistiOS** standards and documentation.
