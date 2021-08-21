resource "oci_budget_budget" "homelab_budget" {
  display_name                          = "homelab-budget"
  amount                                = 1
  compartment_id                        = var.tenancy_ocid
  reset_period                          = "MONTHLY"
  budget_processing_period_start_offset = 19
  targets                               = [var.tenancy_ocid]
}

resource "oci_budget_alert_rule" "homelab_budget_alert" {
  display_name   = "homelab-budget-alert"
  budget_id      = oci_budget_budget.homelab_budget.id
  threshold      = 0.01
  threshold_type = "PERCENTAGE"
  type           = "ACTUAL"
  recipients     = var.my_email
}

resource "oci_budget_alert_rule" "homelab_forecast_alert" {
  display_name   = "homelab-forecast-alert"
  budget_id      = oci_budget_budget.homelab_budget.id
  threshold      = 0.10
  threshold_type = "PERCENTAGE"
  type           = "FORECAST"
  recipients     = var.my_email
}
