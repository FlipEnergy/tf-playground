resource "b2_bucket" "truenas_backup" {
  bucket_name = "flipenergy-homelab-truenas-backup"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "backup_key" {
  key_name = "backup-key"
  capabilities = [
    "listBuckets",
    "listFiles",
    "readBuckets",
    "deleteFiles",
    "readFiles",
    "writeFiles"
  ]
  bucket_id = b2_bucket.truenas_backup.bucket_id
}
