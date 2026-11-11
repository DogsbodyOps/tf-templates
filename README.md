# tf-templates

Reusable Terraform/OpenTofu modules for internal infrastructure projects. Modules are consumed directly from this repo via git source references.

## Structure

```
tf-templates/
├── azure/          # Azure modules (VMs, networking, etc.)
├── cloudflare/     # Cloudflare modules (Zero Trust, DNS, etc.)
└── shared/
    └── templates/  # Shared config templates (e.g. backend configs)
```

Each provider directory has its own README covering available modules, inputs, outputs, and usage examples.

- [azure/README.md](azure/README.md)
- [cloudflare/README.md](cloudflare/README.md)

## Consuming modules

Reference a module using the git source syntax with a version tag:

```hcl
module "tunnel" {
  source = "git::https://github.com/DogsbodyOps/tf-templates.git//cloudflare/modules/zero-trust-tunnel?ref=v1.0.0"
  # ...
}
```

**Always pin to a tag** (`?ref=vX.Y.Z`), not `main`. Tags are immutable; `main` moves.

After changing a pinned ref, run `terraform init -upgrade` to pull the new version.

## Versioning

This repo uses a single shared version tag across all modules. Tags follow [semver](https://semver.org/):

| Change | Version bump |
|--------|-------------|
| Breaking input/output changes | Major (`v2.0.0`) |
| New optional inputs, new modules | Minor (`v1.1.0`) |
| Bug fixes, doc updates, internal refactors | Patch (`v1.0.1`) |

### Creating a release tag

```bash
# 1. Merge your changes to main
git checkout main && git pull

# 2. Tag it
git tag v1.1.0 -m "Add cloudflare/modules/zero-trust-tunnel"

# 3. Push the tag
git push origin v1.1.0
```

To delete and re-push a tag (only if it hasn't been consumed by others):

```bash
git tag -d v1.1.0
git push origin :refs/tags/v1.1.0
git tag v1.1.0 -m "..."
git push origin v1.1.0
```

## Adding a new module

1. Create `<provider>/modules/<name>/` with `main.tf`, `variables.tf`, `outputs.tf`.
2. Add an example under `<provider>/examples/<name>/`.
3. Document inputs/outputs in `<provider>/README.md`.
4. Tag a new release (see above).

## Shared templates

[`shared/templates/`](shared/templates/) contains reusable config file stubs (not Terraform modules):

| File | Purpose |
|------|---------|
| `b2-backend.tf.example` | Backblaze B2 remote state backend config — copy and fill in bucket/key |

## Requirements

Modules target **OpenTofu >= 1.0** and are compatible with Terraform >= 1.0 unless a module's README states otherwise.
