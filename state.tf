terraform{
    backend "s3" {
        bucket = "myterraformbucketinaws"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}




