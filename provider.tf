provider "aws" {
    shared_config_files = ["/Users/peric/.aws/config"]
    shared_credentials_files = ["/Users/peric/.aws/credentials"]
    region  = "us-east-1"
    profile = "default"
}