# Debian Bullseye Vagrant box - Builder
#
# copyright: 2020-2022, Frederico Martins
# author: Frederico Martins <http://github.com/fscm>
# license: SPDX-License-Identifier: MIT

build {
    #name    = "bullseye"
    sources = [
        "source.virtualbox-iso.virtualbox",
        "source.vmware-iso.vmware"
    ]

    provisioner "file" {
        content     = templatefile("${local._vagrantfile_tpl}", {username = "${var.username}"})
        direction   = "upload"
        destination = "/home/${var.username}/Vagrantfile"
    }

    provisioner "file" {
        source      = "/home/${var.username}/Vagrantfile"
        direction   = "download"
        destination = "${local._vagrantfile}"
    }

    provisioner "shell" {
        #execute_command = "chmod +x '{{.Path}}'; echo '${var.password}' | sudo -S env {{.Vars}} '{{.Path}}'"
        execute_command = "chmod +x '{{.Path}}'; sudo -S env {{.Vars}} '{{.Path}}'"
        script          = "${local._provisioner_file}"
    }

    post-processor "vagrant" {
        keep_input_artifact            = false
        compression_level              = 9
        output                         = "${local._output}"
        vagrantfile_template           =  "${local._vagrantfile}"
        vagrantfile_template_generated = true
    }
}
