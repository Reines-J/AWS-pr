```
helm install external-dns external-dns/external-dns \
--namespace eks \
--values external-dns.yml
```

```
helm upgrade external-dns external-dns/external-dns \
--namespace eks \
--values external-dns.yml
```