#module to create VCN & Geteway
module "VCN" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "3.1.0"

  compartment_id = var.compartment_id
  region         = var.region

  vcn_cidrs = ["172.16.0.0/16"]
  vcn_name  = "DemoVCN"

  create_internet_gateway       = true
  internet_gateway_display_name = "DemoInternetGateway"

  create_nat_gateway       = true
  nat_gateway_display_name = "DemoServiceGateway"

  create_service_gateway       = true
  service_gateway_display_name = "DemoServiceGateway"

}

#Crate subnet
resource "oci_core_subnet" "public_subnet" {
  #Required
  cidr_block                  = "172.16.1.0/24"
  compartment_id              = var.compartment_id
  vcn_id                      = module.vcn.vcn_id 
  prohibit_public_ip_on_vnic = false

  display_name = "demopublicsubnet"
}

resource "oci_core_subnet" "private_subnet" {
    #Required
    cidr_block                 = "172.16.2.0/24"
    compartment_id             = var.compartment_id
    vcn_id                     = module.vcn.vcn_id 
    prohibit_public_ip_on_vnic = true

    display_name = "demoprivatesubnet"
}

module "logging" {
    ssource = "oracle-terraform-modules/logging/oci"
    version = "0.2.0"

    compartment_id = var.compartment_id

    service_logdef = local.service_logdef
    tenancy_id     = var.tenancy_id

    depends_on = [oci_core_subnet.private_subnet]
} 
  
