
data "http" "alb_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${var.app_version}/docs/install/iam_policy.json"
}
resource "aws_iam_policy" "controller_policy" {
  name        = "${var.environment}-${var.app_name}-eks-cluster-aws-alb-policy"
  path        = "/"
  description = "AWS ALB Controller IAM Policy "

  policy = data.http.alb_policy.response_body
}
module "irsa" {
  source        = "git::https://github.com/Pranadeep2624/terraform-aws-modules.git//IRSA"
  oidc_provider = replace(var.oidc_url, "https://", "")


  service_account = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
  role_name       = "${var.environment}-${var.app_name}-alb-controller-irsa"
  policy_arns     = [aws_iam_policy.controller_policy.arn]

}
