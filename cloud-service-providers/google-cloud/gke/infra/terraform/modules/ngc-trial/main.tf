data "external" "ngc_api_key" {
  count = var.ngc_trial.enable ? 1 : 0

  program = ["bash", "-c", <<EOT
    headers=$(curl -s -D - -o /dev/null -H "x-api-key: ${var.ngc_trial.trial_key}" "${var.ngc_trial.trial_url}")
    nvapi_key=$(echo "$headers" | grep -i "X-NVAPI-KEY" | awk '{print $2}' | tr -d '\r\n')

    if [ -z "$nvapi_key" ]; then
      echo "Error: Failed to retrieve the API key" >&2
      exit 1
    fi

    echo "{\"ngc_api_key\": \"$nvapi_key\"}"
  EOT
  ]
}
