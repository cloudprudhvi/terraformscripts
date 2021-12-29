locals {
  create_this_sqs_queue = true
  common_tags = {
    Project         = "elililly"
    Environment     = "Dev"
    Service         = "Web"
    COST_CENTRE_ID  = "87545"
    Product_Owner   = "MR.xxxxx"
    Technical_Owner = "MR.XXXXX"
  }
}

resource "aws_vpc" "dev-myvpc" {
  cidr_block = var.vpccidr
  tags       = local.common_tags
}
resource "aws_subnet" "public" {
  cidr_block              = var.pub-subnet-cidr
  vpc_id                  = aws_vpc.dev-myvpc.id
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-public"
  }
}
resource "aws_subnet" "private" {
  cidr_block = var.pvt-subnet-cidr
  vpc_id     = aws_vpc.dev-myvpc.id
  tags = {
    Name = "tf-private"
  }
}
resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.dev-myvpc.id
  tags = {
    Name = "terraform-igw"
  }
}
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.dev-myvpc.id
  tags = {
    Name = "terraform-public-route"
  }
}
resource "aws_route" "igw-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public-route.id
  gateway_id             = aws_internet_gateway.terraform-igw.id
}
resource "aws_route_table_association" "public-igw-assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_instance" "sample-vm" {
  ami           = var.ami-id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  count         = var.instance_count
  user_data     = file("httpd.sh")
  tags          = local.common_tags
}
resource "aws_sqs_queue" "this" {
  count = local.create_this_sqs_queue == 0 ? 1 : 0
  name  = "test"
}
resource "aws_sqs_queue" "this-kms" {
  count = local.create_this_sqs_queue == 1 ? 1 : 0
  name  = "testkms"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami           = "ami-00f7e5c52c0f43726"
  instance_type = "t2.micro"
  monitoring    = true
  subnet_id     = "subnet-0bcd871e364026eda"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "dev-bucket" {
  bucket        = "dev-pj-88"
  force_destroy = true
}
resource "aws_s3_bucket" "newbucket" {
  # (resource arguments)
}
