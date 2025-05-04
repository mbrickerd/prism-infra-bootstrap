module "resource_group" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/resource-group?ref=c529ef3524c75eb5fb550011e38ccd3435413901"

  name        = "prism-cluster"
  environment = "mgmt"
  location    = "westeurope"
  managed_by  = "Terraform"

  tags = {
    managed_by_terraform = true
    purpose              = "terraform-state"
    critical             = "true"
  }
}

module "storage_account" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/storage-account?ref=c529ef3524c75eb5fb550011e38ccd3435413901"

  resource_group_name = module.resource_group.name
  name                = "prism-cluster"
  environment         = "mgmt"
  location            = "westeurope"
  allowed_copy_scope  = "AAD"

  min_tls_version = "TLS1_2"

  public_network_access_enabled = true
  network_rules = {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  tags = {
    managed_by_terraform = true
    purpose              = "terraform-state"
    critical             = "true"
  }
}

module "storage_container_mgmt_state" {
  source = "git::https://github.com/mbrickerd/terraform-azure-modules.git//modules/storage-container?ref=c529ef3524c75eb5fb550011e38ccd3435413901"

  storage_account_id    = module.storage_account.id
  name                  = "mgmt-tfstate"
  container_access_type = "private"
  metadata = {
    purpose     = "terraform-state"
    environment = "mgmt"
  }
}
