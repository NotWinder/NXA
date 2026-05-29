{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      kubectl
      kind
      minikube

      kubernetes-helm
      kompose
    ];
  };
}
