# vault-identity-config

When configuring human operator access to a Vault server, we would usually use an Identity Provider (IdP)
such as Okta, AD, or OIDC for single sign-on (SSO) to Vault. A common use case is to use the IdP
to manage users and groups and then map the groups that users belong to in the IdP to specific sets
of Vault policies.

The [Identity Secrets Engine](https://developer.hashicorp.com/vault/docs/secrets/identity) in Vault
allows you to manage identities and groups within Vault itself. It is always mounted in every
single namespace. The [identity documentation](https://developer.hashicorp.com/vault/docs/concepts/identity)
provides a good overview of the terms used in the Identity Secrets Engine and it is necessary to understand
the terms before diving deeper into this post. You might also find this
[tutorial](https://developer.hashicorp.com/vault/tutorials/auth-methods/identity) useful.

In a nutshell, we will be dealing with the following components:

- [Auth Methods](https://developer.hashicorp.com/vault/docs/auth) are authentication methods that can be
  configured to allow users to authenticate to Vault, including OIDC, GitHub etc.
- Each Auth Method when mounted have a unique `accessor`. An accessor is a unique identifier for the auth method
  and is used to reference the auth method in other parts of Vault. This is because an auth method can be mounted
  multiple times at different paths in a single namespace.
- Groups in Vault can be external or internal. External groups are those that are mapped to an external IdP such as Okta or AD.
  Internal groups are those that are created and managed within Vault itself. Groups can be nested, meaning that a group can
  inherit policies from its parents.
- Group aliases are references to external groups in an IdP. They are associated with Auth methods via their accessors.
- Entities are the unique identities that are created in Vault. An entity can have multiple aliases, which are references
  to external identities such as those in an IdP. An entity can also have multiple groups associated with it, which can be used
  to assign policies to the entity.


## TODO

- Add a second auth method to the example
- Mention about how entities work in namespaces
