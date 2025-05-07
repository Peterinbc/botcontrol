### Goal
To develop IaC automation to test and manage the intelligent threat mitigation features on AWS

### Status Update
Ticket tracked in Jira item: SEC-7037

#### Manually Managed:
* DNS Zone on Route 53

#### Terraform Managed
* S3 bucket
* S3 Website hosting
* Cloudfront distribution
* Website certificate
* WAF ruleset
* Addition of DNS records to DNS Zone


### Issues & Recommendations

**Issue: DNS Zone does not resolve publicly**: 

 Due to multiple edits on the NS record in the DNS zone, the domain name does not resolve publicly.

**Recommendation**:

  1. Clear all public DNS caches of the old record and await DNS record propagation of new records ( This was attempted on May 6th,2025 on all public caches hosted on Google, Cloudflare and OpenDNS. Ref: https://gridpane.com/kb/speeding-up-dns-propagation-manually-clearing-out-cached-records/ )
  2. Purchase a new domain if DNS propagation fails to update
 

### Next Steps
Infra
- [ ] Fix DNS Issue
- [ ] Ensure certificate gets validated
- [ ] Update Cloudfront to use validated certificate
- [ ] Test HTTPS access to the domain

Dev
- [ ] Create nodejs endpoint for website to test Captcha integration

Testing
- [ ] Test configured integration rules
