vpc = {
  vpc_cidr              = "18.0.0.0/16"
  vpc_name              = "tp-vpc"
  private_subnet_names  = ["backend1", "backend2"]
  database_subnet_names = ["database1", "database2"]
}


s3_buckets = {
  "soul-pupils-spa" : {
    website    = true
    versioning = false
  },
  "uploaded-images" : {
    website    = false
    versioning = true
  }
}

rds = {
  db_name     = "bdsql"
  db_username = "postgres"
  db_password = "12345678"
  db_port     = 5432
}

dockerized_lambda_names = ["get_publications", "get_comments", "create_publication", "create_comment", "init_db", "create_user"]

zipped_lambdas = [
  "upload_image"
]

api_endpoints = [
  {
    name                  = "get_publications"
    method                = "GET"
    path                  = "/get_publications"
    require_authorization = false
    authorization_scopes  = []
  },

  {
    name                  = "get_comments"
    method                = "GET"
    path                  = "/get_comments"
    require_authorization = false
    authorization_scopes  = []
  },
  {
    name                  = "create_publication"
    method                = "POST"
    path                  = "/create_publication"
    require_authorization = true
    authorization_scopes  = []
  },

  {
    name                  = "create_comment"
    method                = "POST"
    path                  = "/create_comment"
    require_authorization = true
    authorization_scopes  = []
  },


  {
    name                  = "upload_image"
    method                = "POST"
    path                  = "/upload_image"
    require_authorization = true
    authorization_scopes  = []
  },

  {
    name                  = "create_user"
    method                = "POST"
    path                  = "/create_user"
    require_authorization = false
    authorization_scopes  = []
  }
]
