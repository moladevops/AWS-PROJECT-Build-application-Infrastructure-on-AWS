
#create private key
resource "tls_private_key" "utc_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#create key pair
resource "aws_key_pair" "utc_key" {
  key_name   = "utc-key"
  public_key = tls_private_key.utc_key.public_key_openssh
}

#save private key to file in .pem
resource "local_file" "utc_key" {
  content  = tls_private_key.utc_key.private_key_pem
  filename = "./utc-key.pem"
  file_permission = "0600"
}

