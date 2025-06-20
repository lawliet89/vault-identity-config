# NEVER HARD CODE YOUR TOKEN
variable "vault_token" {
  description = "Vault token for authentication"
  type        = string
  sensitive   = true
}

variable "github_organization" {
  description = "value of the GitHub organization to use for the Vault GitHub auth backend"
  type        = string
}

variable "github_user_groups" {
  description = "Mapping of GitHub teams to Vault Groups"
  type = map(object({               # Key is Vault group name if it's unspecified
    vault_group  = optional(string) # Vault Group Name, defaults to key
    github_teams = set(string)      # GitHub Teams Slug
    policies     = set(string)      # List of Vault Policies
  }))
}
