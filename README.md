binman
==========================
| CRAN version       | Travis build status   | Appveyor build status   | Coverage |
| :-------------: |:-------------:|:-------------:|:-------------:|
| [![CRAN version](http://www.r-pkg.org/badges/version/binman)](https://cran.r-project.org/package=binman)  | [![Build Status](https://travis-ci.org/johndharrison/binman.svg?branch=master)](https://travis-ci.org/johndharrison/binman) | [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/johndharrison/binman?branch=master&svg=true)](https://ci.appveyor.com/project/johndharrison/binman) | [![codecov](https://codecov.io/gh/johndharrison/binman/branch/master/graph/badge.svg)](https://codecov.io/gh/johndharrison/binman)|

Tools and functions for managing the download of binary files.
Binary repositories are defined in YAML format. Defining new 
pre-download, download and post-download templates allow additonal 
repositories to be added.

## Installation

You can install binman from github with:


``` r
# install.packages("devtools")
devtools::install_github("johndharrison/binman")
```

## Usage Examples

### Github Assets

The following is an example of using binman to get the github assets from 
a project. The project is
https://github.com/lightbody/browsermob-proxy/releases . When a new version
is released a zipped binary is added as an "asset". 
A JSON representation of the project releases is available at 
https://api.github.com/repos/lightbody/browsermob-proxy/releases. `binman`
needs a YAML file to specify how to parse this projects assets:

```
name: binman-bmproxy
predlfunction:
  "binman::predl_github_assets":
    url: https://api.github.com/repos/lightbody/browsermob-proxy/releases
    platform:
    - generic
    history: 3
    appname: "binman_bmproxy"
    platformregex: browsermob-proxy
dlfunction:
  "binman::download_files": []
postdlfunction:
  "binman::unziptar_dlfiles": []
```
The file can be accessed at:

```
ymlfile <- system.file("examples", "yaml", "bmproxy.yml", package="binman")

```

Downloading the three most recent releases can the be done using:

```
process_yaml(ymlfile)
```

with resulting directory structure (We omit files for brevity):

#### LINUX
```
john@ubuntu:~$ tree -d /home/john/.local/share/binman_bmproxy
/home/john/.local/share/binman_bmproxy
└── generic
    ├── browsermob-proxy-2.1.0
    │   └── browsermob-proxy-2.1.0
    │       ├── bin
    │       │   └── conf
    │       ├── lib
    │       └── ssl-support
    ├── browsermob-proxy-2.1.1
    │   └── browsermob-proxy-2.1.1
    │       ├── bin
    │       │   └── conf
    │       ├── lib
    │       └── ssl-support
    └── browsermob-proxy-2.1.2
        └── browsermob-proxy-2.1.2
            ├── bin
            │   └── conf
            ├── lib
            └── ssl-support

19 directories
```

#### WINDOWS

```
C:\Users\john>tree C:\Users\john\AppData\Local\binman\binman_bmproxy
Folder PATH listing
Volume serial number is 7CC8-BD03
C:\USERS\JOHN\APPDATA\LOCAL\BINMAN\BINMAN_BMPROXY
└───generic
    ├───browsermob-proxy-2.1.0
    │   └───browsermob-proxy-2.1.0
    │       ├───bin
    │       │   └───conf
    │       ├───lib
    │       └───ssl-support
    ├───browsermob-proxy-2.1.1
    │   └───browsermob-proxy-2.1.1
    │       ├───bin
    │       │   └───conf
    │       ├───lib
    │       └───ssl-support
    └───browsermob-proxy-2.1.2
        └───browsermob-proxy-2.1.2
            ├───bin
            │   └───conf
            ├───lib
            └───ssl-support
```

#### MACOSX

```
DE529:~ admin$ tree -d /Users/admin/Library/Application\ Support/binman_bmproxy
/Users/admin/Library/Application\ Support/binman_bmproxy
└── generic
    ├── browsermob-proxy-2.1.0
    │   └── browsermob-proxy-2.1.0
    │       ├── bin
    │       │   └── conf
    │       ├── lib
    │       └── ssl-support
    ├── browsermob-proxy-2.1.1
    │   └── browsermob-proxy-2.1.1
    │       ├── bin
    │       │   └── conf
    │       ├── lib
    │       └── ssl-support
    └── browsermob-proxy-2.1.2
        └── browsermob-proxy-2.1.2
            ├── bin
            │   └── conf
            ├── lib
            └── ssl-support
19 directories
```
