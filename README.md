This is a small project to allow creating a 24-7 radio broadcast to Twitch, assuming you already have things set up.
The video to stream must be pre-rendered, and must be uploaded somewhere. For this project the simplest solution was an S3 bucket.

# EC2
When choosing an EC2 instance, choose one with an Amazon Machine Image (AMI) of the following requirements:
Amazon Linux 2
64-bit (x86)

Tested on t2-micro, however would be more optimal to use another with higher networking capabilities.
The VT family of instances are more recommended according to research. Still to be tested.

## EC2 Pricing:

### Acceptable: 

t2-micro (Can barely keep a single stream up, with lag. It is possible, however only good in a "proof of concept" sense)

**cost:** "Free tier". after free tier: $0.0116/Hour On Demand

### Premium: 

VT1.3xlarge (More than enough for a single stream, can reportedly stream 2 from the same instance, however that has not been tested) With the cost listed, this option is best when it is within the price range for the project, but the account also needs to be approved by AWS to have it added.

**cost:** $0.65/Hour

# Secrets Manager
The scripts used strongly encourage the usage of uploading your desired Twitch Stream key to the AWS secrets manager.
AWS Secrets Manager pricing:
Any secret is $0.40 per month after a 30 day trial period

# S3 Bucket

As mentioned above, the video needs to be uploaded to an s3 bucket and the script(s) need to be modified accordingly.

# Final Notes:

After much testing, the limiting factor is not the network speed, but the vcpu's available. FFmpeg requires multiple vcpu cores, the minimum number for this project could not be found during testing. For the purposes of this project, from a cost standpoint, cloud hosting is not a viable option from a cost standpoint. Utilising a locally run computer is the better option, however this was still a good learning experience/experiment.