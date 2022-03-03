```
helm install operator istio/istiod  \
--namespace istio-system \
--values operator.yml
```

```
helm upgrade operator istio/istiod  \
--namespace istio-system \
--values operator.yml
```

```
helm install operator 
--namespace istio-system \
--values operator.yml
```