# gcp-secret-key
A Terraform module to create a Google Secret Manager on Google Cloud Services (GCP)

This module supports Terraform version 1 and is compatible with the Terraform Google Provider version 4.

This module is part of our Infrastructure as Code (IaC) framework that enables our users and customers to easily deploy and manage reusable, secure, and production-grade cloud infrastructure.



### Example 1
```
module "my_secret_key" {
  source  = "../modules/gcp-secret-key"

  project      = "my-test-project"

  // (Optional)
  //region     = "europe-west1"
  //name       = "my-secret-key"
  //key        = "youpasshere"
  //labels     = "github"
  //depends_on = [google_project_service.apis]
}

output "secret_key" {
  value = nonsensitive(module.my_secret_key.secret_key)
}
```

## Main Resource Configuration

- project: (Required string)

The ID of the project in which the resource belongs. If it is not provided, the provider project is used.

Default is null.

Example:
```
project = "my-test-project"
```

- region: (Optional string)

The region in which the secret key will be generated. If empty The Secret will automatically be replicated.

Default is null.

Example:
```
region = "europe-west1"
```

- name: (Optional string)

Key secret name. If empty The name will automatically be generated.

Default is null.

Example:
```
name = "my-secret-key"
```

- key: (Optional string)

Default secret key value. If empty, the secret will be automatically generated randomly.

Default is null.

Example:
```
key = "password"
```

- labels: (Optional string)

The labels assigned to this Secret. Label keys must be between 1 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: [\p{Ll}\p{Lo}][\p{Ll}\p{Lo}\p{N}-]{0,62} Label values must be between 0 and 63 characters long, have a UTF-8 encoding of maximum 128 bytes, and must conform to the following PCRE regular expression: [\p{Ll}\p{Lo}\p{N}-]{0,63} No more than 64 labels can be assigned to a given resource. An object containing a list of key: value pairs.We use only one pair, and the key is the app.

Default is null.

Example:
```
labels = "myapp"
```

## Module Configuration

- module_depends_on: (Optional list(dependency))

A list of dependencies. Any object can be assigned to this list to define a hidden external dependency.

Example:
```
module_depends_on = [
  google_network.network
]
```

