resource "aws_key_pair" "terra-key" {
    key_name = "terra-key"
    public_key = file("/mnt/c/Users/reines/Desktop/terraform/terra-key.pub")
}