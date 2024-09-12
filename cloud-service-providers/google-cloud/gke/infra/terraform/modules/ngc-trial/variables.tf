variable "ngc_trial" {
  type = object({
    enable    = bool
    trial_url = string
    trial_key = string
  })
  description = "Configuration for NGC trial"
}