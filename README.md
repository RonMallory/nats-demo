# NatsDemo

## Terraform

**Workspace naming convention**

```bash
{env}-{stack}-{app}-{region}
```
```yaml
env: The environment. i.e. 'dev,qa,prod'
stack: the logical infrastructure separation layer. i.e. core,shared,staticsite
app: Application identifier
region: region for resources
```


terraform init \
  -backend-config="state_bucket=nats-demo-tf-state" \
  -backend-config="region=us-west-2"