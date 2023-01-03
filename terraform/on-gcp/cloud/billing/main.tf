locals {
 projects = {
   "p1" = { id = "formation-dart-flutter", budget = "10" },
   "p2" = { id = "learning-box-369917", budget = "15" },
   "p3" = { id = "bwnyasse-net", budget = "12" },
   "p4" = { id = "trainer-dart-flutter", budget = "20" },
   "p5" = { id = "training-codelabs", budget = "30" },
 }
}

data "google_billing_account" "account" {
  billing_account = "019D22-3EB2A8-D5B304"
}

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  for_each = local.projects

  display_name = "tf-budget-for-${each.value.id}"

  budget_filter {
    projects = ["projects/${each.value.id}"]
  }

  # AMOUNT -------------------
  amount {
    specified_amount {
      currency_code = "CAD"
      units = "${each.value.budget}"
    }
  }

  # THRESHOLD -------------------
  threshold_rules {
    threshold_percent = 0.5
  }
  threshold_rules {
    threshold_percent = 0.9
  }
  threshold_rules {
    threshold_percent = 1
  }
}