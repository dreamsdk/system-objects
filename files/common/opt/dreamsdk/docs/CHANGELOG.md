# Changelog for DreamSDK

**DreamSDK** is a modern, ready-to-use environment for the **Sega Dreamcast**
development designed for the **Microsoft Windows** platform.

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [R4] - 2025-08-30

This release is the result of a 2-year wait, sorry about that. However, this is
an important release because it brings very important structural changes,
including the ability to choose between the MinGW/MSYS environment (the legacy
one) and the modern MinGW-w64/MSYS2 environment. The built-in toolchains have
been recompiled recently and many profiles are provided.

Please note, Windows XP is still supported using the MinGW/MSYS foundation.

### Added
- **New foundation based on MinGW-w64/MSYS2**. This is only available from
  Windows 10 x64 and significantly increases the size of the environment,
   however, it significantly increases compatibility with KallistiOS and modern
  development in general.
- **Code::Blocks 25.03** is now supported.
- In **DreamSDK Manager**, there is an automatic **Check for update** feature
  which triggers every 7 days. It could be disabled as well in the tool.
- In **DreamSDK Manager**, it's now possible to check which external tool the
  environment is using (i.e., `git`, `python`, `meson`, `ruby` and `cmake`).
- The KallistiOS wrappers were converted into real Windows binaries, making them
  available to Batch files or IDEs (e.g., `kos-cc.exe`, `dc-arm-cc.exe`). Those
  are based on **DreamSDK Runner**.
- Support for **CMake** and **Meson**.
- The `kosports` helper supports the `refresh` operation now; this one updates
  the referential files used in the **Code::Blocks** integration while creating
  a project using the **DreamSDK Wizard** in Code::Blocks.

### Improved
- All RTF documentation has been migrated to HTML as Wordpad isn't provided
  anymore on Windows 11 (e.g., this applies to the **Getting Started** guide).
- In **DreamSDK Manager**, when the offline versions of repositories are used,
  the exact version number, including source host, is displayed.
- In **DreamSDK Manager**, the **CMake** builds are now properly tracked by the
  progress bar.

### Fixed
- In **DreamSDK Manager**, the KallistiOS library was not properly detected;
  same for the KallistiOS changelog.
- The ABI message displayed in DreamSDK R3 has been fixed (by recompiling the
  SuperH toolchains).
- Various issues in thread management in **DreamSDK Manager** that could happens
  while cancelling a pending operation.
- Various issues in installation of the **Code::Blocks** integration.
- **Code::Blocks** Wizard integration has been fixed (some libraries were not
  properly added while creating a project using the DreamSDK Wizard).

### Updated
- All **SuperH** toolchains were updated. The profile names are now aligned with
  KallistiOS (i.e., **Stable** profile has the same meaning in DreamSDK and in
  KallistiOS). Depending of the chosen foundation (i.e., MinGW/MSYS or
  MinGW-w64/MSYS2), the choice will be:

  - For MinGW-w64/MSYS2 (x64):
      
	  - **Stable**, i.e., GCC `13.2.0` with Newlib `4.3.0.20230120`.
	  - **13.4.0**, with Newlib `4.5.0.20241231`.
	  - **14.3.0**, with Newlib `4.5.0.20241231`.
	  - **15.1.0**, with Newlib `4.5.0.20241231`.

  - For MinGW/MSYS (x86):
  
     - **10.5.0**, with Newlib `4.3.0.20230120`.
	 - **9.5.0-winxp**, with Newlib `4.3.0.20230120`.
	 
- **GNU Debugger (GDB)** has been updated to `16.3` for MinGW-w64/MSYS2 (x64).
  It's possible to choose between no Python (disabled) or Python `3.13`.
- In the `profile.d` directory (which transform a standard MinGW/MSYS or
  MinGW-w64/MSYS2 into DreamSDK), the script has been updated to manage both
  foundation environment with a single code base. This applies in different
  part of DreamSDK as well.
- Various refactorings that improve stability (e.g., `enumcom`, the component
  listing COM ports, is now a real library instead of an executable embedded
  in DreamSDK).

### Removed
- The parts of DreamSDK supporting **mruby** have been removed since mruby is
  now an official port in kos-ports.
- `elf2bin` was removed as its now officially in KallistiOS.
- **Subversion** (SVN) is not supported anymore.

### Known bugs
- In **Code::Blocks**, when creating a project with the DreamSDK Wizard, during
  the first generation it is necessary to select a build configuration (Debug
  or Release) manually in order to enable the correct mechanisms in
  Code::Blocks. This only happens when creating the project.
- The provided help (**DreamSDK Help**) has not yet been updated, this will be
  done later in a future release.

## [R3] - 2023-11-04

Almost everything changed with that version, this is a complete, long waited
revamp of the previous package!

### Added
- **Experimental Ruby support!** This feature uses [mruby](https://mruby.org/)
  (lightweight, embeddable Ruby). This feature is handled in DreamSDK Manager
  through the Ruby tab. 
- Some useful links were added in the **Windows Start** menu.
- Support of **CDFS** images in **Code::Blocks**: You have now the possibility 
  to simulate a virtual **CD-ROM** through an **ISO** file, when selecting the
  appropriate option when creating a project in **Code::Blocks**.
- Support for `libkosfat/navi` addon libraries.
- You have now the possibility to manage **Code::Blocks** in **DreamSDK Manager**.
- Support for **Windows Terminal** (if available). 
- The USB baud rates for **Dreamcast Tool Serial** are now supported.
- Additional tools (e.g., `curl`) and libraries (e.g., `libelf`) are now available. 
- This **CHANGELOG** file to hopefully serve as an evolving example of a
  standardized open source project **CHANGELOG**.

### Improved
- An offline version of **KallistiOS**, **KallistiOS Ports** and
  **Dreamcast Tool** are now integrated in the package. But it's strongly
  recommanded to use the online repositories!
- Better handling of prerequisites: **Git**, **Python** and 
  **Subversion Client (SVN)** are not mandatory in all the cases, this depends
  now of your choice. **Git** is mandatory only if you use online repositories, 
  **Python** and **Subversion Client** are always optional but preferred if you
  have the possibility to install these dependencies.
- When installing **Code::Blocks**, the process of updating user's configuration
  files is better. Now the **Setup** process detects all usable configuration
  files and patch them if possible.
- In the **DreamSDK Manager** tool, URL for the **Git** repositories may be
  changed now, even if the installation was already done.
- Better support for **ARP** (creation of the tool **FastARP**). It uses the
  classic `arp` command in **Windows XP** and `netsh` in modern **Windows**.
- **MakeDisc**: The `bootstrap` parameter is now optional. It will try to detect
  the `IP.BIN` from the current directory or directly in the directory where the
  `1ST_READ.BIN` file is located.
- It's now possible to select the toolchains you want to use directly from the
  **DreamSDK Manager** instead of making your choice in the Setup. You have the
  possibility to choose between **Legacy**, **Old Stable** and **Stable**
  toolchains.     
- The installation of **GNU Debugger (GDB) for SuperH** is better; and **Python**
  extensions may be enabled/disabled on user request (previously,
  **GDB for SuperH** was linked to **Python 2.7** only, so **Python** was
  mandatory).
- Removing some outdated packages provided by MSYS and replacing them with
  standalone packages.

    - **GNU Awk**: From `3.1.7` to `4.0.1` (provided [here](https://github.com/sizious/msys-gawk))
    - **MinTTY**: From `1.0.3` to `3.5.0` (using official [MinTTY](https://mintty.github.io/) source)
    - **Wget**: From `1.12` to `1.19.4` (provided by [Jernej Simončič](https://eternallybored.org/misc/wget/))
- The COM ports list used for **Dreamcast Tool Serial** is now dynamic and not
  hardcoded anymore. 
	
### Fixed
- Some fixes in **Code::Blocks**:
  * An issue when generating **Romdisk** from projects with spaces in their name
    has been fixed.
  * Static library project type is now fully supported.
- **MakeDisc**: An little cosmetic problem has been fixed.
- Tons of various fixes, including specific things for **Windows 10+**; mainly
  related to User Account Control (UAC).  

### Updated
- **MinTTY** is now the default shell (you can still use Windows Prompt).
- **GNU Compiler Collection (GCC) for SuperH** and **AICA** is now `4.7.4`
  (**Legacy**), `9.5.0` for SuperH and `8.5.0` for ARM (**Old Stable**)
  and `13.2.0` for SuperH (**Stable**). Stable is the toolchain selected by
  default, but this one requires a modern OS (if you are on Windows XP, you can
  select **Old Stable** at maximum). 
- **GNU Compiler Collection (GCC) for Win32** is now `9.2.0`.
- **GNU Debugger (GDB) for SuperH** is now `10.2`.
- **DreamSDK Manager** was updated to display more useful information like
  repositories versions or environment information.
- The help file was updated to reflect all the changes of this release.
- The JPEG library (`libjpeg`) is now `9d`.
- The PNG library (`libpng`) is now `1.6.37`.
- Some optional tools before are now mandatory and installed by default (e.g., 
  `img4dc`). 

### Removed
- The **IPCreate** tool was removed, as the standard KallistiOS repository
  contains now the modernized **IP creator** (`makeip`) tool. 

### Know bugs
- Sometimes the `CTRL+C` command is not working properly (no effect instead of
  killing the current process). This isn't really known why this happens, it
  looks like this issue is in the original MSYS tool as well.

## [R2] - 2019-03-05
### Added
- Full **Code::Blocks IDE** integration, including debugging on the real
  hardware, directly from the IDE!
- A lot of new tools are included now, like **MakeDisc**, allowing you to create
  CD releases of your programs.

### Updated
- **DreamSDK Manager** was redesigned and improved a lot.
- The Help content was improved a lot and it's now available online (and of
  course, it's still available in the package too).

## [R1] - 2018-11-25
### Added
- Fast & easy to install: just double-click on the setup file and let the
  program install & configure everything for you.
- Ready to use: All the required toolchains (for the **SuperH** &
  **Yamaha AICA**) are already prebuilt and ready-to-use.
- Lightweight: Thanks to the **MinGW/MSYS** environment, the space used on the
  disk is minimal.
- Configurable & upgradable: With the included **DreamSDK Manager** tool, manage
  **DreamSDK** components really easily.
- Respectful of the standards: **DreamSDK** is 100% compliant with the
  **KallistiOS** standards and documentation.

