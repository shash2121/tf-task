module "s3" {
    source = "../modules/s3"
    bucket_name = var.s3.bucket_name
}