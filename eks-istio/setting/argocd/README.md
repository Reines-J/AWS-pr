```
helm dependency update
helm install argocd argo/argo-cd \
--namespace cicd \
--dependency-update \
--values argocd_values.yml
```

```
helm dependency update
helm upgrade argocd argo/argo-cd \
--namespace cicd \
--dependency-update \
--values argocd_values.yml
```