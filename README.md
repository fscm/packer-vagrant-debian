# Debian Linux for Vagrant

Packer templates to build a small Debian Linux box designed for use in Vagrant.

## What is Debian?

> Debian is a free operating system (OS) for your computer. An operating system is the set of basic programs and utilities that make your computer run.

*from* [debian.org](https://www.debian.org)

## Synopsis

This is a set of templates designed for use with Packer to create Vagrant
boxes with Debian installed.

All non-required packages were removed to create this small box. When using
this box you may have to install some of the packages that usually are
installed on a regular Debian Linux Vagrant box.

## Getting Started

There are a couple of things needed for the templates to work.

### Prerequisites

Packer, Vagrant, Virtualbox, and VMWare need to be installed on your local
computer.

#### Packer

Packer installation instructions can be found
[here](https://www.packer.io/docs/install).

#### Vagrant

Vagrant installation instructions can be found
[here](https://www.vagrantup.com/docs/installation).

#### Virtualbox

Virtualbox installation instructions can be found
[here](https://www.virtualbox.org/wiki/Downloads).

#### VMware

VMware installation instructions will depend on the VMware product that you
want. Go to the desired product page at [VMware](https://www.vmware.com) and
check for the appropriate documentation.

Vagrant support for the VMWare hypervisor is provided by the `Vagrant VMWare
Utility` that can be downloaded from [here](https://www.vagrantup.com/vmware/downloads).
and by the `Vagrant VMware provider` that can be installed by running the
following command on a terminal:

```shell
vagrant plugin install vagrant-vmware-desktop
```

## Usage

To create a virtual machine using this box create a folder and run the
following command inside that folder:

```shell
vagrant init fscm/debian
```

To start that virtual machine run:

```shell
vagrant up
```

This box is available for multiple providers. See the table bellow to find out
how to run a specific provider.

|  provider  |  command                               |
|------------|----------------------------------------|
| virtualbox | `vagrant up --provider=virtualbox`     |
| vmware     | `vagrant up --provider=vmware_desktop` |

## Build

In order to create a Debian Linux Vagrant box using this Packer recipe you need
to run the following `packer` command on the root of this project:

```shell
packer build [-var 'option=value'] <VARIANT>
```

- `<VARIANT>` - *[required]* The variant that is being build (`bullseye`).

Options:

- `disk_size_mb` - The disk size in megabytes (default value:8192).
- `debug` - Enable debug (default value:false).
- `domain` - The network domain (default value:"vagrant.local").
- `hostname` - The system hostname (default value:"debian").
- `os_version` - The OS version (default value:"11.0.0").
- `password` - The password for the user (default value:"bullseye").
- `username` - The username for the user (default value:"bullseye").

The recipe will, by default, build a box for every supported provider. To build
only for the desired one(s) use the `-only` packer option.

List of supported providers:

|  provider  |  option                           |
|------------|-----------------------------------|
| virtualbox | `-only=virtualbox-iso.virtualbox` |
| vmware     | `-only=vmware-iso.vmware`         |

More than one provider can be specified by separating the names with commas
(e.g.: `-only=virtualbox-iso.virtualbox,vmware-iso.vmware`).

A build example:

```shell
packer build -only=vmware-iso.vmware -var 'debug=true' bullseye
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for more details on how
to contribute to this project.

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/packer-vagrant-debian/tags).

## Authors

- **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/packer-vagrant-debian/contributors)
who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
file for details
