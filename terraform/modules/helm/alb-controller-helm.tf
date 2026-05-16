resource "helm_release" "aws-load-balancer-controller" {
  name            = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  chart           = "aws-load-balancer-controller"
  version         = "1.17.0"
  namespace       = "kube-system"
  cleanup_on_fail = true
  replace         = true

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = var.region
      vpcId       = var.vpc_id

      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = var.alb_controller_role_arn
        }
      }

      enableGatewayAPI = true
      extraArgs = {
        "enable-gateway-api" = "true"
      }
    })
  ]
}
  # depends_on = [kubernetes_service_account.alb_controller_sa]
