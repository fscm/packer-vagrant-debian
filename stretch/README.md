**[LEGACY] This branch is no longer maintained**
> While this project is fully active, this branch is no longer maintained and therefore is no longer up to date. You are still welcome to explore, learn, and use the code provided here.

# Debian Stretch Box

Packer templates to build a Vagrant Debian Stretch box.

## Synopsis

This script will create a Vagrant box with a minimum installation of Debian
Stretch.

## Getting Started

There are a couple of things needed for the templates to work.

### Prerequisites

Packer tools need to be installed on your local computer.

#### Packer

Packer installation instructions can be found [here](https://www.packer.io/docs/installation.html).

#### Vagrant

Vagrant installation instructions can be found [here](https://www.vagrantup.com/docs/installation/).

#### Virtualbox

Virtualbox installation instructions can be found [here](https://www.virtualbox.org/wiki/Downloads).

#### Parallels

Parallels installation instructions can be found [here](https://www.parallels.com/eu/products/desktop/resources/).

From Parallels Desktop version 11 onwards Pro or Business edition is required.

[Parallels Virtualization SDK](http://www.parallels.com/download/pvsdk/) is
also required.

#### VMware

VMware installation instructions will depend on the VMware product that you
have. Go to your product page at [VMware](https://www.vmware.com) and check
for the appropriate documentation.

### Installation

Nothing special to be done. Just download the template that you wish to use.

### Usage

In order to create the box using this packer script you need to provide a
few options.

```
Usage:
  packer build [-var 'option=value'] stretch.json
```

#### Script Options
- `checksum_type` - The type of the ISO checksum specified in `checksum_value` (default value: "none"). If set to something other than "*none*" then the `checksum_value` must also be set. Possible values are "*none*", "*md5*", "*sha1*", "*sha256*", or "*sha512*".
- `checksum_value` - The checksum for the ISO file (default value: ""). Make sure that the type of the checksum is specified with the `checksum_type` variable.
- `headless` - Show the console of the machine being built (default value: "true").
- `os_codename` - Codename of the Operating System (default value: "stretch"). Will also be used as the Box name.
- `os_version` - Version of the Operating System (default value: "9.4.0").
- `system_disk_size` - Size of the disk in MB (default value: "8192").
- `system_domain` - Domain name (default value: "marsh").
- `system_hostname` - Host name (default value: "stretch").
- `system_locale` - Locale for the system (default value: "en_US").
- `system_pwd` - Password for the root and system users (default value: "stretch").
- `system_timezone` - Time zone for the system (default value: "UTC").
- `system_user` - Username of the system user (default value: "pollywog").

#### Builds available

By default the script will build virtual machines for all of the configured
available builders.

To choose only one or some builds use the `-only` option.

```
Usage:
  packer build -only=[build_name] [-var 'option=value'] stretch.json
```

More than one builder can be specified by separating the names with commas
(e.g.: `-only=virtualbox,parallels`).

Here is a list of the configured builds on this script:

| Build Name | Build Technology  |
|------------|-------------------|
| parallels  | Parallels Desktop |
| virtualbox | VirtualBox        |
| vmware     | VMware            |

## Services

This box will have the following services running.

| Service           | Port   | Protocol |
|-------------------|:------:|:--------:|
| SSH               | 22     |    TCP   |

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/packer-vagrant-debian/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/packer-vagrant-debian/contributors)
who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE)
file for details
