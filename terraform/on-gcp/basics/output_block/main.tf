resource random_string rstring {
  length  = 20
}

output name {
  value       = random_string.rstring.result
  #sensitive   = true
  description = "Output of result"
  #depends_on  = []
}
