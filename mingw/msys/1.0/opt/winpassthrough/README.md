# winpassthrough

This small Shell script may be used in [MSYS](http://www.mingw.org/wiki/MSYS)
in addition with the [msys-core-extended](https://github.com/sizious/msys-core-extended)
project.

This Shell script was made to pass all the parameters directly to a Windows
application (i.e. outside the [MSYS](http://www.mingw.org/wiki/MSYS)
environment), without any path conversions, except if some parameters are
detected to be files/directories. In that case, files/directories paths are
converted to Windows paths.

This project was mainly created for allowing the usage of 
[GNU Awk 5.1.0 for Windows](https://github.com/mbuilov/gawk-windows) on
**MSYS**.

## Sample usage (with GNU Awk 5.1.0)

Here is an example of the usage of `winpassthrough` for replacing that outdated
**awk 3.1.7**, as asked [here](https://fr.osdn.net/projects/mingw/ticket/39246).

All directories are referring to your **MSYS** installation, i.e. when you read
`/opt`, you may read `%MINGW_ROOT%\msys\1.0\opt`, where `%MINGW_ROOT%` is your
**MinGW** installation (usually `C:\MinGW`).

1. Download `winpassthrough` and place it in the `/opt/winpassthrough` directory.
2. Download the [GNU Awk 5.1.0](https://github.com/mbuilov/gawk-windows/releases) 
   binary package.
3. Create the following directories under your **MSYS** installation: 
   `/opt/gawk` and `/opt/gawk/wingawk`.
4. Extract the **GNU Awk 5.1.0** package in the `/opt/gawk/wingawk`.
5. In the `/opt/gawk` directory, create a `gawk` file and paste the following
   content:

```
#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
REALGAWK=${BASEDIR}/wingawk/gawk

WINAPP="${REALGAWK}" /opt/winpassthrough/winpassthrough "$@"
```

Now, when you input `gawk` in your **MSYS Shell**, it will:

1. Execute your `gawk` Shell script, as created above;
2. This `gawk` script will call this `winpassthrough` script;
3. The `winpassthrough` will convert any files/directories paths if possible,
   but leave the rest unchanged;
4. The `winpassthrough` will call **GNU Awk 5.1.0** with the provided
   parameters, including files/directories paths converted if possible.
   

