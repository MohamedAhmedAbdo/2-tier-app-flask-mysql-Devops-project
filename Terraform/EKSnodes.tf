#Create IAM role
resource "aws_iam_role" "nodes" {
  name               = "eks-node-group-nodes"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }, 
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


#AmazonEKSWorkerNodePolicy to grants access to EC2 and EKS
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}
#AmazonEKS_CNI_Policy
resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}
#AmazonEC2ContainerRegistryReadOnly to allow download and run docker images from the ECR repository
resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}
#Create node group resource
resource "aws_eks_node_group" "nodes" {
  #Associate this instance group with the EKS cluster
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "nodes"
  #Attach the IAM role
  node_role_arn = aws_iam_role.nodes.arn
  #specify subnets where i want to run my nodes
  subnet_ids = [
    aws_subnet.private-us-east-1a.id
  ]

  ami_type             = "AL2_x86_64"
  capacity_type        = "ON_DEMAND"
  instance_types       = ["t3.small"]
  disk_size            = 20
  force_update_version = false
  #for scaling
  scaling_config {
    #define minimun and maximum number of nodes
    desired_size = 1
    max_size     = 3
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }
  #create labels for nodes 
  labels = {
    role = "general"
  }

  version = "1.24"

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
  ]
}


resource "aws_iam_policy" "eks_worknode_ebs_policy" {
  name = "Amazon_EBS_CSI_Driver"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
# And attach the new policy
resource "aws_iam_role_policy_attachment" "worknode-AmazonEBSCSIDriver" {
  policy_arn = aws_iam_policy.eks_worknode_ebs_policy.arn
  role       = aws_iam_role.nodes.name
}