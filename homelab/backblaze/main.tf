resource "b2_bucket" "duplicati_bucket" {
  bucket_name = "flipenergy-homelab-duplicati"
  bucket_type = "allPrivate"
}

resource "b2_application_key" "duplicati_key" {
  key_name = "Duplicati"
  capabilities = [
    "deleteFiles",
    "listBuckets",
    "listFiles",
    "readBucketEncryption",
    "readBuckets",
    "readFiles",
    "shareFiles",
    "writeBucketEncryption",
    "writeFiles"
  ]
  bucket_id = b2_bucket.duplicati_bucket.bucket_id
}
