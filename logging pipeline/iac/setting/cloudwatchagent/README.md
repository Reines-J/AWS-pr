```
helm install aws-cloudwatch-metrics eks/aws-cloudwatch-metrics \
--namespace metric \
--values agent.yml
```
```
helm upgrade aws-cloudwatch-metrics eks/aws-cloudwatch-metrics \
--namespace metric \
--values agent.yml
```