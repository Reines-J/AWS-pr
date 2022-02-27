```
helm install cluster-autoscaler autoscaler/cluster-autoscaler \
--namespace eks \
--values autoscaler_values.yml
```

```
helm upgrade cluster-autoscaler autoscaler/cluster-autoscaler \
--namespace eks \
--values autoscaler_values.yml
```