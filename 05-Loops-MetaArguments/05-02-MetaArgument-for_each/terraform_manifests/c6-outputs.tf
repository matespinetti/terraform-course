


#Output - For each
output "for_each_output" {
    description = "For each az output"
    value = {for az,instance in aws_instance.myec2vm : az => instance.public_ip}
}

#Output - Splat operator
output "splat_output" {
    description = "Splat operator"
    value = {
        ids = values(aws_instance.myec2vm)[*].id
        public_ips = values(aws_instance.myec2vm)[*].public_ip
    }
}