# binman

<!-- badges: start -->
[![CRAN version](http://www.r-pkg.org/badges/version/binman)](https://cran.r-project.org/package=binman)
[![R-CMD-check](https://github.com/ropensci/binman/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ropensci/binman/actions/workflows/R-CMD-check.yaml)
[![codecov](https://codecov.io/gh/ropensci/binman/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ropensci/binman)
<!-- badges: end -->


Tools and functions for managing the download of binary files. Binary repositories are defined in YAML format. Defining new pre-download, download and post-download templates allow additional repositories to be added.

## Installation

You can install `binman` from GitHub with:

```R
# install.packages("remotes")
remotes::install_github("ropensci/binman")
```

## Usage Examples

### GitHub Assets

The following is an example of using `binman` to get the GitHub assets from a project. The project is https://github.com/lightbody/browsermob-proxy/releases . When a new version is released a zipped binary is added as an "asset". A JSON representation of the project releases is available at https://api.github.com/repos/lightbody/browsermob-proxy/releases. `binman` needs a YAML file to specify how to parse this projects assets:

```yaml
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

```R
ymlfile <- system.file("examples", "yaml", "bmproxy.yml", package = "binman")

```

Downloading the three most recent releases can the be done using:

```R
process_yaml(ymlfile)
```

with resulting directory structure (We omit files for brevity):

#### LINUX

```sh
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

```cmd
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

```sh
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
