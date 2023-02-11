source "arm-image" "ubuntu_2004_arm64" {
  image_type      = "raspberrypi"
  iso_url         = "https://cdimage.ubuntu.com/releases/22.04.1/release/ubuntu-22.04.1-preinstalled-server-arm64+raspi.img.xz"
  iso_checksum    = "sha256:5d0661eef1a0b89358159f3849c8f291be2305e5fe85b7a16811719e6e8ad5d1"
  qemu_binary     = "qemu-aarch64-static"
  image_mounts    = ["/boot/firmware", "/"]
  chroot_mounts = [
    ["proc", "proc", "/proc"],
    ["sysfs", "sysfs", "/sys"],
    ["bind", "/dev", "/dev"],
    ["devpts", "devpts", "/dev/pts"],
    ["binfmt_misc", "binfmt_misc", "/proc/sys/fs/binfmt_misc"],
    ["bind", "/run/systemd", "/run/systemd"]
  ]
}

build {
  dynamic "source" {
    for_each = var.images
    labels   = ["arm-image.ubuntu_2004_arm64"]

    content {
      name = source.key
      output_filename = "output-arm-image/${source.key}_${formatdate("YYYY-MM-DD_hh-mm-ss", timestamp())}.img"
    }
  }

  provisioner "file" {
    content = templatefile("${path.root}/templates/network-config.tmpl", {
      ipv4_address    = var.images[source.name].ipv4_address
      ipv4_gateway    = var.ipv4_gateway
      ipv4_dns_server = var.ipv4_dns_server
    })
    destination = "/boot/firmware/network-config"
  }

  provisioner "file" {
    content = templatefile("${path.root}/templates/user-data.tmpl", {
      username = var.username
      hostname = source.name
    })
    destination = "/boot/firmware/user-data"
  }

  provisioner "file" {
    source      = "${path.root}/files/raspberrypi_exporter"
    destination = "/usr/local/sbin/raspberrypi_exporter"
  }

  provisioner "file" {
    source      = "${path.root}/files/raspberrypi_exporter.service"
    destination = "/etc/systemd/system/raspberrypi_exporter.service"
  }

  provisioner "file" {
    source      = "${path.root}/files/raspberrypi_exporter.timer"
    destination = "/etc/systemd/system/raspberrypi_exporter.timer"
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /var/lib/node_exporter/textfile_collector",
      "chmod +x /usr/local/sbin/raspberrypi_exporter"
    ]
  }

}
