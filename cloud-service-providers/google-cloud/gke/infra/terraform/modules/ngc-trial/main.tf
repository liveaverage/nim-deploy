data "external" "ngc_api_key" {
  count = var.ngc_trial.enable ? 1 : 0

  program = ["bash", "-c", <<EOT
    MONTH=$(date -u +"%m")
    DAY=$(date -u +"%d")
    YEAR=$(date -u +"%Y")
    
    P_MONTH=$(printf "00%s" "$MONTH" | tail -c 4)
    P_DAY=$(printf "00%s" "$DAY" | tail -c 4)

    TRIAL_KEY="${var.ngc_trial.trial_key}"
    KV="$YEAR$P_MONTH$TRIAL_KEY$P_DAY"
    KVE=$(echo -n "$KV" | base64)
    AKVE="gke-$KVE"

    headers=$(curl -s -D - -o /dev/null -H "x-api-key: $AKVE" "${var.ngc_trial.trial_url}")
    nvapi_key=$(echo "$headers" | grep -i "X-NVAPI-KEY" | awk '{print $2}' | tr -d '\r\n')

    if [ -z "$nvapi_key" ]; then
      echo "Error: Failed to retrieve the API key" >&2
      exit 1
    fi

    echo "{\"ngc_api_key\": \"$nvapi_key\"}"
  EOT
  ]
}
