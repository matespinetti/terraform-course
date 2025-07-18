# Output - For Loop with list
output "for_output_list" {
    description = "For Loop Output List"
    value = [for instance in aws_instance.myec2vm : instance.public_ip]  
}


#Output- For loop with map
output "for_output_map1" {
    description = "For loop with Map"
    value = {for instance in aws_instance.myec2vm : instance.id => instance.public_ip}
}

#Output - For loop With Map advanced
output "for_output_map2" {
    description = "For loop with Map advanced"
    value = {for c,instance in aws_instance.myec2vm : c => instance.public_ip}
  
}

#Output - Splat operator
output "splat_output" {
    description = "Splat operator"
    value = {
        ids = aws_instance.myec2vm[*].id
        public_ips = aws_instance.myec2vm[*].public_ip
    }
}