```
helm repo add eks https://aws.github.io/eks-chart
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
--namespace eks \
--values controller_values.yml
```