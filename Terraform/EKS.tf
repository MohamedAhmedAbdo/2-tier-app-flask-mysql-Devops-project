## create EKS
#Create an IAM role with the Amazon EKS Cluster Policy
resource "aws_iam_role" "demo" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
#Attach the required IAM policy to the EKS cluster demo IAM role
resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}
#Minimum configuration for the EKS itself
resource "aws_eks_cluster" "demo" {
  name = "demo"
  #IAM role that we created for the EKS
  role_arn = aws_iam_role.demo.arn
  #providing the subnets which EKS can use to create nodes and load balancers
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.private-us-east-1a.id,
      aws_subnet.private-us-east-1b.id,
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy]
}


