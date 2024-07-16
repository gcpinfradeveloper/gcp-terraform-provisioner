###################### VPC ####################
resource "google_compute_network" "myvpc" {
  name                    =  "${var.stone_name}-myvpc"
  auto_create_subnetworks = "false"
  mtu                     = 1460
}

####################### Subnets #################
resource "google_compute_subnetwork" "mysubnet" {
  name          =  "${var.stone_name}-mysubnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "${var.region}"
  network       = google_compute_network.myvpc.id
}

# Proxy-only subnet
resource "google_compute_subnetwork" "myproxysubnet" {
  name          = "${var.stone_name}-myproxysubnet"
  ip_cidr_range = "10.0.2.0/24"
  region        = "${var.region}"
  purpose       = "REGIONAL_MANAGED_PROXY"
  role          = "ACTIVE"
  network       = google_compute_network.myvpc.id
}

# resource "google_compute_address" "static" {
#   count = 2
#   name = "staticip-${count.index + 1}"
#   region = "${var.region}"
#   depends_on = [ google_compute_firewall.myfw ]
# }

resource "google_compute_address" "bastionpip" {
  name = "${var.stone_name}-bastionpip"
  region = "${var.region}"
  depends_on = [ google_compute_firewall.myfw ]
}

########### Create Cloud Router ##############
resource "google_compute_router" "router" {
  # project = var.project_name
  name    = "${var.stone_name}-nat-router"
  network       = google_compute_network.myvpc.id
  region  = "${var.region}"
}

######### Create Nat Gateway ##################
resource "google_compute_router_nat" "nat" {
  name                               =  "${var.stone_name}-my-router-nat"
  router                             = google_compute_router.router.name
  region        = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}