# provider "helm" {
#   kubernetes {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#     token                  = data.aws_eks_cluster_auth.cluster.token
#   }
# }

# data "aws_eks_cluster" "cluster" {
#   name = module.eks.cluster_name
# }

# data "aws_eks_cluster_auth" "cluster" {
#   name = module.eks.cluster_name
# }

# resource "helm_release" "aws_load_balancer_controller" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "region"
#     value = var.region
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   depends_on = [module.eks]
# }

# resource "kubernetes_service_account" "aws_load_balancer_controller" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     labels = {
#       "app.kubernetes.io/name" = "aws-load-balancer-controller"
#     }
#     annotations = {
#     "eks.amazonaws.com/role-arn" = aws_iam_role.eks_lb_controller_role.arn
#     }
#   }

#   automount_service_account_token = true
# }

# resource "aws_iam_role" "eks_lb_controller_role" {
#   name = "${local.cluster_name}-lb-controller-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_lb_controller_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
#   role       = aws_iam_role.eks_lb_controller_role.name
# }
