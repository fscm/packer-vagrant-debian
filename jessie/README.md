# Debian Jessie Box

Packer templates to build a Vagrant Debian Jessie box.

## Synopsis

This script will create a Vagrant box with a minimum installation of Debian
Jessie.

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

### Installation

Nothing special to be done. Just download the template that you wish to use.

### Usage

In order to create the box using this packer script you need to provide a
few options.

```
Usage:
  packer build [-var 'option=value'] jessie.json
```

#### Script Options
- `headless` - Show the console of the machine being built (default value: "true").
- `os_codename` - Codename of Operating System (default value: "jessie"). Will also be used as the Box name.
- `os_version` - Version of the Operating System (default value: "8.6.0").
- `system_disk_size` - Size of the disk in MB (default value: "8192").
- `system_domain` - Domain name (default value: "marsh").
- `system_hostname` - Host name (default value: "jessie").
- `system_locale` - Locale for the system (default value: "en_US").
- `system_pwd` - Password for the root and system users (default value: "jessie").
- `system_timezone` - Time zone for the system (default value: "Europe/Lisbon").
- `system_user` - Username of the system user (default value: "pollywog").

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

This project is licensed under the MIT License - see the [LICENSE](https://github.com/fscm/packer-vagrant-debian/LICENSE)
file for details
