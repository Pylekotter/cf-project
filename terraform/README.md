**CF Project / Terraform**

This Terraform code is a Proof of Concept on how Your company can leverage IAC for their existing app environment.

Code can be found here: https://github.com/Pylekotter/cf-project/tree/main/terraform

I have deployed this Terraform environment and in sandbox account and have confirmed I am able to spin it up without error.

*This environment includes:*

 - The VPC and Subnets, Security Groups with least privileges, and an IGW and Nat Gateway.
 - Webservers behind an autoscaling group.
 - an Application Loadbalander with Target Groups that are associated with the Webservers.
 - A Route53 record for the Domain name www.clientapp.com.
 - A Postgresql RDS Database that has a Security Group that allows access from the Webservers.
 - A CloudWatch Alarm that detects when the nodes behind the ALB are unhealthy.

 To address the issue of the site being unavailable on Friday, I decided to put the instances behind an Autoscaling group. This way we can scale the webservers much more easily when the webservers are under heavy load.

 *Some Suggestions I would make to further improve this environment:*

 - Create a CloudWatch Alarm for the RDS database to alert when the database reaches an unhealthy threshold.
 - Create a read-replica of the Database in another AZ for higher performance.
 - ensure there is an SNS topic or some kind of notification system set up to properly send alert notifications to client and SRE team.

 *References:*
 
 https://developer.hashicorp.com/terraform/docs
 https://registry.terraform.io/browse/modules
 https://github.com/morethancertified/mtc-terraform - Very helpful reference for implementing modules to my Terraform code.


