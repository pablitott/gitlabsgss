# Change following variables may affect ../scripts/awsCommands.sh script
# ========== gitlab-1 =============================
output "aws-gitlab-public-ip" {
    value = aws_instance.publichost.*.public_ip
}
output "aws-gitlab-private-ip" {
    value = aws_instance.publichost.*.private_ip
}
# ======================================================
output "aws-private-key-file"{
    value = local.ssh_key_file_name
}

output "aws-ec2-instance_server"{
    value = data.template_file.aws_ec2_servers.*.rendered
}