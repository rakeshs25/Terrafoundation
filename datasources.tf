data "aws_ami" "windows_ami" {
    most_recent = true
    owners = ["801119661308"]

    filter {
      name = "name"
      values = ["Windows_Server-2022-English-Full-Base-*"]
    }

}