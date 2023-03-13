variable env {
    type = string
}

variable origin_arn {
    type = string
}

variable origin_domain_name {
    type = string
}

variable origin_id {
    type = string
}

variable alias_cloudfront_list {
    type = list
}

variable "use_cache" {
    type = bool
    default = true
}

variable acm_certificate_arn_cloudfront {
    type = string
    default = ""
}

variable use_waf {
    type = bool
    default = false
}

variable web_acl_id {
    type = string
    default = null
}

variable force_ssl {
    type = bool
    default = false
}

variable cf_default_ttl {
    type = number
    default = 3600
}

variable cf_max_ttl {
    type = number
    default = 86400
}

variable default_root_object   {
    type = string
    default = ""
}
