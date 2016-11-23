output "sg_all_id" {
  value = "${aws_security_group.sg_all.id}"
}

output "sg_web_public_id" {
  value = "${aws_security_group.sg_web_public.id}"
}
