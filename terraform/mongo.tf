resource "ibm_database" "mongodb" {
  resource_group_id = ibm_resource_group.resource_group.id
  name              = "mongodbee-tutorial"
  service           = "databases-for-mongodb"
  plan              = "enterprise"
  location          = var.region
  adminpassword = var.admin_password
  service_endpoints = "public"

  group {
    group_id = "member"
      host_flavor {
      id = "b3c.4x16.encrypted"
    }

    disk {
      allocation_mb = 20480
    }
  }

  group {
    group_id = "analytics"

    members {
      allocation_count = 1
    }
  }

  group {
    group_id = "bi_connector"

    members {
      allocation_count = 1
    }
  }
  timeouts {
    create = "120m"
    update = "120m"
    delete = "15m"
  }
}


data "ibm_database_connection" "icd_conn" {
  deployment_id = ibm_database.mongodb.id
  user_type     = "database"
  user_id       = "admin"
  endpoint_type = "public"
}

output "analytics" {
  description = "Analytics Node connection string"
  value       = data.ibm_database_connection.icd_conn.analytics
  sensitive = true
}

output "bi_connector" {
  description = "BI Connector connection string"
  value       = data.ibm_database_connection.icd_conn.bi_connector
  sensitive = true
}
