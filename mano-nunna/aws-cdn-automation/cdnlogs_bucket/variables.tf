#bucket
variable "bucket_name"{
  type=string
  default="cdn-logs-bucket"
}

variable "bucket_tags"{
  type=map(string)
  default=null
}
variable "account_id"{
  type=number
  default=133521243113
}