resource "b2_bucket" "truenas_backup" {
  bucket_name = "flipenergy-homelab-truenas-backup"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "duplicati_backup_key" {
  key_name = "Duplicati Backup"
  capabilities = [
    "deleteFiles",
    "listFiles",
    "readBuckets",
    "readFiles",
    "writeFiles"
  ]
  bucket_id = b2_bucket.truenas_backup.bucket_id
}
