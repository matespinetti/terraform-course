
data "aws_availability_zones" "my_azs" {
    state = "available"  
}


data "aws_ec2_instance_type_offerings" "my_ins_type_1" {
  for_each = toset(data.aws_availability_zones.my_azs.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.value]
  }

  location_type = "availability-zone"
}


#Output All Azs mapped to Supported Instance Types
output "output_1" {
    description = "Output v1.1"
    value = tomap(  {for az, instance in data.aws_ec2_instance_type_offerings.my_ins_type_1 : az => instance.instance_types})  # This is a map.
}


#Filtered Output: Exclude Unsupported Instance Types
output "output_2" {
  description = "Output with filtered instance types"
  value = keys( {for az, details in data.aws_ec2_instance_type_offerings.my_ins_type_1 : az => details.instance_types if contains(details.instance_types, "t3.micro")})  
}