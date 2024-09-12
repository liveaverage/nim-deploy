
output "ngc_api_key" {
  value = data.external.ngc_api_key[0].result.ngc_api_key
}