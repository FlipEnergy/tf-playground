output "bucket_name" {
  value = b2_bucket.truenas_backup.bucket_name
}

output "app_key_id" {
  value = b2_application_key.duplicati_backup_key.application_key_id
}

output "app_key" {
  value = b2_application_key.duplicati_backup_key.application_key
  sensitive = true
}
