# tf-atom-autoscaling-group-aws

[![Terraform Format](https://img.shields.io/badge/terraform-fmt-blue?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws/actions)
[![Terraform Validate](https://img.shields.io/badge/terraform-validate-blue?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws/actions)
[![TFLint](https://img.shields.io/badge/tflint-passing-brightgreen?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws/actions)
[![Terraform Test](https://img.shields.io/badge/tests-2%20passed-brightgreen?logo=terraform)](https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws/actions)
[![Security Scan](https://img.shields.io/badge/trivy-passing-brightgreen?logo=aqua)](https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws/actions)
[![Conventional Commits](https://img.shields.io/badge/commits-conventional-blue?logo=conventionalcommits)](https://conventionalcommits.org)
[![Documentation](https://img.shields.io/badge/docs-terraform--docs-blue?logo=readthedocs)](https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws/actions)
[![License](https://img.shields.io/badge/license-MIT-blue?logo=opensourceinitiative)](LICENSE)

Terraform atom module that manages an AWS Auto Scaling Group (ASG) for a fleet of EC2 instances, driven by a launch template and integrated with the [tf-label](https://github.com/PlatformStackPulse/tf-label) naming/tagging context.

## Features

- **Launch-template driven** — attaches an existing launch template by `id` and `version` (defaults to `$Latest`).
- **Capacity control** — configurable `min_size`, `max_size`, and `desired_capacity`.
- **Multi-AZ placement** — spreads instances across the supplied `subnet_ids` (validated to be non-empty).
- **Load-balancer aware** — optionally registers with one or more `target_group_arns`.
- **Health checks** — `EC2` or `ELB` health-check type with a configurable grace period.
- **Instance refresh** — optional rolling instance refresh with a configurable `min_healthy_percentage`.
- **Consistent naming & tagging** — name and tags are derived from the tf-label context; every tag is propagated at launch.
- **Toggleable** — set `enabled = false` (via input or context) to create no resources.

## Usage

```hcl
module "asg" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-autoscaling-group-aws.git?ref=v1.0.0"

  # tf-label identity
  namespace = "eg"
  stage     = "prod"
  name      = "web"

  # required inputs
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  launch_template_id = aws_launch_template.web.id

  # optional capacity
  min_size         = 2
  max_size         = 6
  desired_capacity = 3
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/PlatformStackPulse/tf-label.git | v1.0.0 |

### Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_launch_template_id"></a> [launch\_template\_id](#input\_launch\_template\_id) | ID of the launch template | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the ASG | `list(string)` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes and tags, which are merged. | <pre>object({<br/>    enabled             = optional(bool, true)<br/>    namespace           = optional(string, null)<br/>    tenant              = optional(string, null)<br/>    environment         = optional(string, null)<br/>    stage               = optional(string, null)<br/>    name                = optional(string, null)<br/>    delimiter           = optional(string, null)<br/>    attributes          = optional(list(string), [])<br/>    tags                = optional(map(string), {})<br/>    label_order         = optional(list(string), null)<br/>    regex_replace_chars = optional(string, null)<br/>    id_length_limit     = optional(number, null)<br/>    label_key_case      = optional(string, null)<br/>    label_value_case    = optional(string, null)<br/>    labels_as_tags      = optional(set(string), null)<br/>    descriptor_formats = optional(map(object({<br/>      format = string<br/>      labels = list(string)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | <pre>map(object({<br/>    format = string<br/>    labels = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired number of instances | `number` | `2` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'. | `string` | `null` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Whether to force-delete the ASG | `bool` | `false` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | Grace period before health checks start (seconds) | `number` | `300` | no |
| <a name="input_health_check_type"></a> [health\_check\_type](#input\_health\_check\_type) | Health check type (EC2 or ELB) | `string` | `"EC2"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` to keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_instance_refresh_enabled"></a> [instance\_refresh\_enabled](#input\_instance\_refresh\_enabled) | Whether to enable instance refresh on updates | `bool` | `true` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>Note: The value of the `name` tag, if included, will be the `id`, not the `name`. | `set(string)` | `null` | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | Version of the launch template | `string` | `"$Latest"` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of instances | `number` | `3` | no |
| <a name="input_min_healthy_percentage"></a> [min\_healthy\_percentage](#input\_min\_healthy\_percentage) | Minimum healthy percentage during instance refresh | `number` | `90` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of instances | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_target_group_arns"></a> [target\_group\_arns](#input\_target\_group\_arns) | List of target group ARNs to attach | `list(string)` | `[]` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A customer identifier, indicating who this instance of a resource is for. | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the Auto Scaling group |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the module is enabled |
| <a name="output_id"></a> [id](#output\_id) | ID of the Auto Scaling group |
| <a name="output_name"></a> [name](#output\_name) | Name of the Auto Scaling group |
<!-- END_TF_DOCS -->

## Tests

Unit tests use a mocked AWS provider (no credentials, no real API calls) and assert on
plan-known values — the tf-label `id`, the planned resource count, and input pass-throughs.

```bash
terraform init -backend=false
terraform test -test-directory=tests/unit

# or via the Makefile
make test-unit
```

Integration tests (which provision real infrastructure and require AWS credentials) live in
`tests/integration/` and run with `terraform test -test-directory=tests/integration` (`make test-integration`).
