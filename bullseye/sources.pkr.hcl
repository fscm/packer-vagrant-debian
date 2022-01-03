# Debian Bullseye Vagrant box - Sources
#
# copyright: 2020-2022, Frederico Martins
# author: Frederico Martins <http://github.com/fscm>
# license: SPDX-License-Identifier: MIT

# Virtualbox

source "virtualbox-iso" "virtualbox" {
    boot_command         = "${local._boot_command}"
    boot_wait            = "${var._boot_wait_sec}s"
    cpus                 = 1
    disk_size            = "${var.disk_size_mb}"
    guest_additions_mode = "upload"
    guest_additions_path = "VBoxGuestAdditions.iso"
    guest_os_type        = "${var._os_type_vbox}"
    hard_drive_interface = "sata"
    headless             = "${local._headless}"
    http_content         = { "/preseed.cfg" = file(local._preseed_file)}
    iso_checksum         = "${local._iso_checksum}"
    iso_target_path      = "${local._iso_target_path}"
    iso_urls             = "${local._iso_urls}"
    memory               = "${var._system_memory_mb}"
    nic_type             = "82540EM"
    output_directory     = "${local._output_directory}/virtualbox"
    shutdown_command     = "echo '${var.password}' | sudo -S /sbin/shutdown -hP now"
    sound                = "none"
    ssh_password         = "${var.password}"
    ssh_port             = "${var._ssh_port}"
    ssh_username         = "${var.username}"
    ssh_wait_timeout     = "${var._ssh_wait_timeout_sec}s"
    usb                  = false
    vboxmanage           = [
        ["modifyvm", "{{ .Name }}", "--boot1", "dvd"],
        ["modifyvm", "{{ .Name }}", "--boot2", "disk"],
        ["modifyvm", "{{ .Name }}", "--boot3", "none"],
        ["modifyvm", "{{ .Name }}", "--boot4", "none"]
    ]
    vm_name              = "${local._vm_name}"
}

# VMWare

source "vmware-iso" "vmware" {
    boot_command         = "${local._boot_command}"
    boot_wait            = "${var._boot_wait_sec}s"
    cores                = 1
    cpus                 = 1
    disk_size            = "${var.disk_size_mb}"
    disk_type_id         = "0"
    guest_os_type        = "${var._os_type_vmware}"
    headless             = "${local._headless}"
    http_content         = { "/preseed.cfg" = file(local._preseed_file)}
    iso_checksum         = "${local._iso_checksum}"
    iso_target_path      = "${local._iso_target_path}"
    iso_urls             = "${local._iso_urls}"
    memory               = "${var._system_memory_mb}"
    network              = "nat"
    network_adapter_type = "e1000"
    output_directory     = "${local._output_directory}/vmware"
    shutdown_command     = "echo '${var.password}' | sudo -S /sbin/shutdown -hP now"
    sound                = false
    ssh_password         = "${var.password}"
    ssh_port             = "${var._ssh_port}"
    ssh_username         = "${var.username}"
    ssh_wait_timeout     = "${var._ssh_wait_timeout_sec}s"
    usb                  = false
    vm_name              = "${local._vm_name}"
    vmdk_name            = "${local._vm_name}"
    vmx_data = {
        "ehci.present"      = "FALSE"
        "ethernet0.pciSlotNumber" = "32"
        "floppy0.present"   = "FALSE"
        "serial0.present"   = "FALSE"
        "virtualHW.version" = "14"
    }
    vmx_remove_ethernet_interfaces = "true"
}
