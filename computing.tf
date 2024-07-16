####################### Bastion Host ###############
resource "google_compute_instance" "bastionhost" {
  name         = "${var.stone_name}-bastionhost"
  machine_type = "e2-medium"
  zone         = "${var.zone}"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id
    access_config {
      // Ephemeral public IP
      nat_ip = google_compute_address.bastionpip.address
    }
}
metadata = {
  ssh-keys ="${var.sshuser}:${var.key}"
}
}
######################### App servers ##############
resource "google_compute_instance" "appservers" {
  count = 2
  name         =  "${var.stone_name}-appserver-${count.index + 1}"
  machine_type = "e2-medium"
  zone         = "${var.zone}"
  boot_disk {
    /* initialize_params {
      size  = "25"               
      type  = "pd-ssd"
      image = "debian-11-bullseye-v20220519"
    } */
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id
    # access_config {
    #   // Ephemeral public IP
    #   nat_ip = google_compute_address.static[count.index].address
    # }
}
metadata = {
  ssh-keys ="${var.sshuser}:${var.key}"
}
}