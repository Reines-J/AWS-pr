resource "aws_key_pair" "terra-key" {
    key_name = "key"
    public_key = "${file("/mnt/c/Users/Reines/Desktop/terraform/key.pub")}"
}
