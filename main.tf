resource "vault_audit" "stdout" {
  type = "file"

  options = {
    file_path = "stdout"
  }
}

resource "vault_github_auth_backend" "github" {
  organization = var.github_organization
}


locals {
    identy_group_policies = {
      for k, v in var.github_user_groups : k => v.policies
    }
}

resource "vault_identity_group" "internal" {
  for_each = var.github_user_groups

  name = coalesce(each.value.vault_group, each.key)
  type = "internal"

  member_group_ids = [for group in each.value.github_teams : vault_identity_group.github[group].id]

  external_policies = true
  metadata = {
    github_teams = join(",", each.value.github_teams)
  }
}

resource "vault_identity_group_policies" "internal" {
  for_each = { for k, v in local.identy_group_policies : k => v if length(v) > 0 }

  group_id = vault_identity_group.internal[each.key].id

  exclusive = false
  policies  = each.value
}

locals {
  github_groups = toset(flatten([for _k, v in var.github_user_groups : v.github_teams]))
}

# GitHub External Groups
resource "vault_identity_group" "github" {
  for_each = local.github_groups

  name = "github ${each.key}"
  type = "external"

  external_policies = true
  metadata = {
    github_team = each.key
  }
}

# GitHub External Groups Alias
resource "vault_identity_group_alias" "github" {
  for_each = local.github_groups

  name           = each.key
  mount_accessor = vault_github_auth_backend.github.accessor
  canonical_id   = vault_identity_group.github[each.key].id
}
