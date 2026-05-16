resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.3.1"
  namespace        = "argocd"
  create_namespace = true
  cleanup_on_fail  = true
  replace          = true

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-internal" = "false"
          }
        }
        ingress = {
          enabled = false
        }
        extraArgs = ["--insecure"]
      }
      crds = {
        keep = false
      }
    })
  ]

  depends_on = [helm_release.aws-load-balancer-controller]
}

data "kubernetes_service_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.aws-load-balancer-controller]
}