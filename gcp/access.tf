resource "google_folder" "my_folder" {
  display_name = var.google-folder.display-name
  parent       = "organizations/123456789"
}
resource "google_folder_access_approval_settings" "folder_access_approval" {
  folder_id           = google_folder.my_folder.folder_id
  notification_emails = ["testuser@example.com", "example.user@example.com"]

  enrolled_services {
      cloud_product = "all"
  }
  depends_on = [google_kms_crypto_key_iam_member.iam]
}
resource "google_organization_access_approval_settings" "organization_access_approval" {
  organization_id     = "123456789"
  notification_emails = ["testuser@example.com", "example.user@example.com"]

  enrolled_services {
      cloud_product = "appengine.googleapis.com"
  }

  enrolled_services {
      cloud_product = "dataflow.googleapis.com"
      enrollment_level = "BLOCK_ALL"
  }
}
resource "google_project_access_approval_settings" "project_access_approval" {
  project_id          = "my-project-name"
  notification_emails = ["testuser@example.com", "example.user@example.com"]

  enrolled_services {
      cloud_product = "all"
      enrollment_level = "BLOCK_ALL"
  }
}
resource "google_service_account" "created-later" {
  account_id = "tf-test-%{random_suffix}"
}
resource "google_access_context_manager_access_level" "access-level" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}/accessLevels/chromeos_no_lock"
  title  = "chromeos_no_lock"
  basic {
    conditions {
      device_policy {
        require_screen_lock = true
        os_constraints {
          os_type = "DESKTOP_CHROME_OS"
        }
      }
      regions = [
    "CH",
    "IT",
    "US",
      ]
    }
  }
    lifecycle {
    ignore_changes = [basic.0.conditions]
  }
}
resource "google_access_context_manager_access_level_condition" "access-level-conditions" {
  access_level = google_access_context_manager_access_level.access-level-service-account.name
  ip_subnetworks = ["192.0.4.0/24"]
  members = ["user:test@google.com", "user:test2@google.com", "serviceAccount:${google_service_account.created-later.email}"]
  negate = false
  device_policy {
    require_screen_lock = false
    require_admin_approval = false
    require_corp_owned = true
    os_constraints {
      os_type = "DESKTOP_CHROME_OS"
    }
  }
  regions = [
    "IT",
    "US",
  ]
}
resource "google_access_context_manager_access_policy" "access-policy" {
  parent = "organizations/123456789"
  title  = "my policy"
}
resource "google_access_context_manager_access_levels" "access-levels" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}"
  access_levels {
    name   = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}/accessLevels/chromeos_no_lock"
    title  = "chromeos_no_lock"
    basic {
      conditions {
        device_policy {
          require_screen_lock = true
          os_constraints {
            os_type = "DESKTOP_CHROME_OS"
          }
        }
        regions = [
    "CH",
    "IT",
    "US",
        ]
      }
    }
  }

  access_levels {
    name   = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}/accessLevels/mac_no_lock"
    title  = "mac_no_lock"
    basic {
      conditions {
        device_policy {
          require_screen_lock = true
          os_constraints {
            os_type = "DESKTOP_MAC"
          }
        }
        regions = [
    "CH",
    "IT",
    "US",
        ]
      }
    }
  }
}
resource "google_access_context_manager_access_policy_iam_policy" "policy" {
  name = google_access_context_manager_access_policy.access-policy.name
  policy_data = data.google_iam_policy.admin.policy_data
}
resource "google_access_context_manager_access_policy_iam_binding" "binding" {
  name = google_access_context_manager_access_policy.access-policy.name
  role = "roles/accesscontextmanager.policyAdmin"
  members = [
    "user:jane@example.com",
  ]
}
resource "google_access_context_manager_access_policy_iam_member" "member" {
  name = google_access_context_manager_access_policy.access-policy.name
  role = "roles/accesscontextmanager.policyAdmin"
  member = "user:jane@example.com"
}
resource "google_cloud_identity_group" "group" {
  display_name = "my-identity-group"

  parent = "customers/A01b123xz"

  group_key {
    id = "my-identity-group@example.com"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}
resource "google_access_context_manager_gcp_user_access_binding" "gcp_user_access_binding" {
  organization_id = "123456789"
  group_key       = trimprefix(google_cloud_identity_group.group.id, "groups/")
  access_levels   = [
    google_access_context_manager_access_level.access_level_id_for_user_access_binding.name,
  ]
}
resource "google_access_context_manager_access_policy_iam_binding" "binding" {
  name = google_access_context_manager_access_policy.access-policy.name
  role = "roles/accesscontextmanager.policyAdmin"
  members = [
    "user:jane@example.com",
  ]
}
resource "google_access_context_manager_service_perimeter_resource" "service-perimeter-resource" {
  perimeter_name = google_access_context_manager_service_perimeter.service-perimeter-resource.name
  resource = "projects/987654321"
}
resource "google_access_context_manager_service_perimeter" "service-perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.access-policy.name}/servicePerimeters/restrict_storage"
  title  = "restrict_storage"
  status {
    restricted_services = ["storage.googleapis.com"]
  }
}
resource "google_access_context_manager_access_policy_iam_member" "member" {
  name = google_access_context_manager_access_policy.access-policy.name
  role = "roles/accesscontextmanager.policyAdmin"
  member = "user:jane@example.com"
}
resource "google_access_context_manager_gcp_user_access_binding" "gcp_user_access_binding" {
  organization_id = "123456789"
  group_key       = trimprefix(google_cloud_identity_group.group.id, "groups/")
  access_levels   = [
    google_access_context_manager_access_level.access_level_id_for_user_access_binding.name,
  ]
}
resource "google_access_context_manager_access_policy" "access-policy" {
  parent = "organizations/123456789"
  title  = "my policy"
}