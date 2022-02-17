```
helm install aws-cloudwatch-metrics eks/aws-cloudwatch-metrics \
--namespace cw \
--values agent.yml
```
```
helm upgrade aws-cloudwatch-metrics eks/aws-cloudwatch-metrics \
--namespace cw \
--values agent.yml
```