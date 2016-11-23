output "sg_all_id" {
  value = "${aws_security_group.sg_all.id}"
}

output "sg_web_id" {
  value = "${aws_security_group.sg_web.id}"
}
