output "ec2_machines" {
  value = aws_instance.mongodb_stg.*.arn  # Here * indicates that there are more than one arn as we used count as 7   
}
 