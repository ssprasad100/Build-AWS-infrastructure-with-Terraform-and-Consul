provider "consul" {
  address    = "192.168.3.127:8500"
  datacenter = "dc1"
}

# Setup a key in Consul to provide inputs
data "consul_keys" "app" {
  key {
    name    = "size"
    path    = "AWS/size"
    default = "t2.micro"
  }
  key {
    name    = "accesskey"
    path    = "AWS/accesskey"
  }
  key {
    name    = "Secret"
    path    = "AWS/Secret"
  }
}
# Setup an AWS provider
provider "aws" {
  access_key = "${data.consul_keys.app.var.accesskey}"
  secret_key = "${data.consul_keys.app.var.Secret}"
  region     = "${var.aws_region}"

}

# Setup a new AWS instance using a dynamic ami and
# instance type
resource "aws_instance" "Demo101" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${data.consul_keys.app.var.size}"
  tags = {
    Name = "webapache101"
  }
}

# Setup a key in Consul to store the instance id and
# the DNS name of the instance
resource "consul_keys" "app" {
  key {
    path   = "AIRLINE-DEV/id"
    value  = "${aws_instance.Demo101.id}"
    delete = true
  }

  key {
    path   = "AIRLINE-DEV/public_dns"
    value  = "${aws_instance.Demo101.public_dns}"
    delete = true
  }

   key {
    path   = "AIRLINE-DEV/name"
    value  = "${aws_instance.Demo101.tags.Name}"
    delete = true
  }
}
