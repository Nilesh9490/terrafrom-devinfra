# Roles to access the AWS CF
resource "aws_iam_role" "ram_metrix_role" {
  name               = "ram_metrix_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

#Policy to attach the CF Role
resource "aws_iam_role_policy" "ram_metrix_role-policy" {
  name = "ram_metrix_role-policy"
  role = aws_iam_role.ram_metrix_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
		"cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
              "Resource": "*"
        },
	{
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        }
    ]
}
EOF

}

#Instance identifier
resource "aws_iam_instance_profile" "instanceprofile" {
  name = "ram_metrix_role"
  role = aws_iam_role.ram_metrix_role.name
}

