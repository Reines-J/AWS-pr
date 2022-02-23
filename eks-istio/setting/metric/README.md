```
helm install metrics-server bitnami/metrics-server \
--version 0.5.0 \
--namespace eks \
--name metrics-server
```

```
helm upgrade metrics-server bitnami/metrics-server \
--version 0.5.0 \
--namespace eks \
--name metrics-server
```