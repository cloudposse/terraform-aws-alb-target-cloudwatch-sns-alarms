<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 2.0 |
| local | >= 1.2 |
| null | >= 2.0 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tag\_map | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when this alarm transitions into an ALARM state from any other state.  If set, this list takes precedence over notify\_arns | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| alb\_arn\_suffix | The ARN suffix of ALB | `string` | n/a | yes |
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| context | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| elb\_5xx\_count\_threshold | The maximum count of ELB 5XX requests over a period. A negative value will disable the alert | `number` | `25` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| environment | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| evaluation\_periods | Number of periods to evaluate for the alarm | `number` | `1` | no |
| httpcode\_alarm\_description | The string to format and use as the httpcode alarm description | `string` | `"HTTPCode %v count for %v over %v last %d minute(s) over %v period(s)"` | no |
| id\_length\_limit | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| insufficient\_data\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when this alarm transitions into an INSUFFICIENT\_DATA state from any other state. If set, this list takes precedence over notify\_arns | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| label\_order | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| notify\_arns | A list of ARNs (i.e. SNS Topic ARN) to execute when this alarm transitions into ANY state from any other state. May be overridden by the value of a more specific {alarm,ok,insufficient\_data}\_actions variable. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when this alarm transitions into an OK state from any other state. If set, this list takes precedence over notify\_arns | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| period | Duration in seconds to evaluate for the alarm | `number` | `300` | no |
| regex\_replace\_chars | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| target\_3xx\_count\_threshold | The maximum count of 3XX requests over a period. A negative value will disable the alert | `number` | `25` | no |
| target\_4xx\_count\_threshold | The maximum count of 4XX requests over a period. A negative value will disable the alert | `number` | `25` | no |
| target\_5xx\_count\_threshold | The maximum count of 5XX requests over a period. A negative value will disable the alert | `number` | `25` | no |
| target\_group\_arn\_suffix | The ARN suffix of ALB Target Group | `string` | n/a | yes |
| target\_response\_time\_alarm\_description | The string to format and use as the target response time alarm description | `string` | `"Target Response Time average for %v over %v last %d minute(s) over %v period(s)"` | no |
| target\_response\_time\_threshold | The maximum average target response time (in seconds) over a period. A negative value will disable the alert | `number` | `0.5` | no |
| treat\_missing\_data | Sets how alarms handle missing data points. Values supported: missing, ignore, breaching and notBreaching | `string` | `"missing"` | no |

## Outputs

| Name | Description |
|------|-------------|
| httpcode\_elb\_5xx\_count\_cloudwatch\_metric\_alarm\_arn | ELB 5xx count CloudWatch metric alarm ARN |
| httpcode\_elb\_5xx\_count\_cloudwatch\_metric\_alarm\_id | ELB 5xx count CloudWatch metric alarm ID |
| httpcode\_target\_3xx\_count\_cloudwatch\_metric\_alarm\_arn | Target Group 3xx count CloudWatch metric alarm ARN |
| httpcode\_target\_3xx\_count\_cloudwatch\_metric\_alarm\_id | Target Group 3xx count CloudWatch metric alarm ID |
| httpcode\_target\_4xx\_count\_cloudwatch\_metric\_alarm\_arn | Target Group 4xx count CloudWatch metric alarm ARN |
| httpcode\_target\_4xx\_count\_cloudwatch\_metric\_alarm\_id | Target Group 4xx count CloudWatch metric alarm ID |
| httpcode\_target\_5xx\_count\_cloudwatch\_metric\_alarm\_arn | Target Group 5xx count CloudWatch metric alarm ARN |
| httpcode\_target\_5xx\_count\_cloudwatch\_metric\_alarm\_id | Target Group 5xx count CloudWatch metric alarm ID |
| target\_response\_time\_average\_cloudwatch\_metric\_alarm\_arn | Target Group response time average CloudWatch metric alarm ARN |
| target\_response\_time\_average\_cloudwatch\_metric\_alarm\_id | Target Group response time average CloudWatch metric alarm ID |

<!-- markdownlint-restore -->
