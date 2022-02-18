```
helm install aws-for-fluent-bit eks/aws-for-fluent-bit \
--namespace cw \
--values log.yml
```
```
helm upgrade aws-for-fluent-bit eks/aws-for-fluent-bit \
--namespace cw \
--values log.yml
```