#secondary IP ?ôï?û•?ïò?ó¨ Pod ?óà?ö© Í∞??àò Ï¶ùÍ??
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
kubectl set env ds aws-node -n kube-system WARM_IP_TARGET=2
kubectl set env ds aws-node -n kube-system MINIMUM_IP_TARGET=10