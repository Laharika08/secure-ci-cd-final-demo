variable "source_code_bucket_name"{
    type= string
    default="coderview-src-cdn-bucket"
}

variable "src_bucket_tags"{
    type= map(string)
    default={
    "Env":"Dev"
    "Project":"Coderview"
  }
}

variable "src_bucket_acl"{
    type=string
    default="private"
}

variable "index_document_suffix"{
    type=string
    default="index.html"
}

variable "error_document_key" {
    type=string
    default="error.html"
}

variable "content_type"{
    type=string
    default="text/html"
}