# ============================================================
# Sprint 2 - Azure Basic Infrastructure
# Resource Group -> VNet -> Subnet -> NSG -> Linux VM
# ============================================================

# ------------------------------------------------------------
# Resource Group
# ------------------------------------------------------------

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.azure_location

  tags = {
    Project = var.project_name
    Sprint  = "2"
  }
}

# ------------------------------------------------------------
# Virtual Network
# ------------------------------------------------------------

resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_cidr]

  tags = {
    Project = var.project_name
    Sprint  = "2"
  }
}

# ------------------------------------------------------------
# Subnet
# ------------------------------------------------------------

resource "azurerm_subnet" "public" {
  name                 = "${var.project_name}-public-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_cidr]
}

# ------------------------------------------------------------
# Network Security Group
# ------------------------------------------------------------

resource "azurerm_network_security_group" "web" {
  name                = "${var.project_name}-web-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # SSH
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # HTTP
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Project = var.project_name
    Sprint  = "2"
  }
}

# ------------------------------------------------------------
# Associate NSG with Subnet
# ------------------------------------------------------------

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.web.id
}

# ------------------------------------------------------------
# Public IP
# ------------------------------------------------------------

resource "azurerm_public_ip" "vm" {
  name                = "${var.project_name}-vm-public-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Project = var.project_name
    Sprint  = "2"
  }
}

# ------------------------------------------------------------
# Network Interface
# ------------------------------------------------------------

resource "azurerm_network_interface" "vm" {
  name                = "${var.project_name}-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }

  tags = {
    Project = var.project_name
    Sprint  = "2"
  }
}

# ------------------------------------------------------------
# Linux Virtual Machine
# ------------------------------------------------------------

resource "azurerm_linux_virtual_machine" "web" {
  name                = "${var.project_name}-web-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash

    apt-get update -y
    apt-get install -y nginx

    systemctl enable nginx
    systemctl start nginx

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <title>Multi-Cloud Terraform</title>
    </head>

    <body>
      <h1>Azure Sprint 2</h1>
      <h2>Terraform VM Deployment Successful</h2>

      <p>Cloud: Microsoft Azure</p>
      <p>VNet: 10.10.0.0/16</p>
      <p>Subnet: 10.10.1.0/24</p>
      <p>Server: Ubuntu 22.04</p>
    </body>
    </html>
    HTML
  EOF
  )

  tags = {
    Project = var.project_name
    Sprint  = "2"
  }
}
