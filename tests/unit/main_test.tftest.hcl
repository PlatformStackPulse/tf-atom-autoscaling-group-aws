# Unit Tests — tf-atom-autoscaling-group-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:      terraform test -test-directory=tests/unit
# Run verbose:   terraform test -test-directory=tests/unit -verbose
# Run specific:  terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: Under a mock provider, computed attributes (arn, id, name of the ASG)
# are UNKNOWN at plan time, so we assert only on plan-KNOWN values:
#   - the tf-label id string (namespace-stage-name)
#   - the module enabled flag
#   - input pass-throughs
# and, for the disabled path, that count == 0 zeroes the outputs to null.

mock_provider "aws" {}

variables {
  # tf-label identity
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-required inputs (no default)
  subnet_ids         = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
  launch_template_id = "lt-0123456789abcdef0"

  # a couple of representative optional inputs
  min_size         = 1
  max_size         = 3
  desired_capacity = 2
}

# ---------------------------------------------------------------------------
# Test: module creates the ASG when enabled (default)
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should be enabled by default"
  }

  assert {
    condition     = length(aws_autoscaling_group.this) == 1
    error_message = "Exactly one Auto Scaling group should be planned when enabled"
  }

  assert {
    condition     = aws_autoscaling_group.this[0].name == "eg-test-thing"
    error_message = "ASG name should equal the tf-label id 'eg-test-thing'"
  }

  assert {
    condition     = aws_autoscaling_group.this[0].vpc_zone_identifier == toset(var.subnet_ids)
    error_message = "ASG should be placed in the provided subnet_ids"
  }
}

# ---------------------------------------------------------------------------
# Test: module creates nothing when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_autoscaling_group.this) == 0
    error_message = "No Auto Scaling group should be planned when enabled = false"
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when the module is disabled"
  }

  assert {
    condition     = output.enabled == false
    error_message = "enabled output should be false when the module is disabled"
  }
}
