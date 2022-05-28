## Getting Started
1. Create AWS IAM User w/ necessary permissions and key pair.

2. Create environment variables in GitLab Project > Settings > CI/CD:
    - AWS_REGION
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY

3. Clone the repository

4. Update hostname parameters in bash script for resource "aws_lightsail_instance"
    - Example: "cc2.kennethcarnes.com"

5. Push to man in GitLab CI/CD

6. Create a A record using your public DNS hosting provider

7. Connect to Cloud C2 via web browser
	- Example: http://cc2.kennethcarnes.com:8080

8. If this the first time you are configuring Cloud C2, you will need to retrieve the setup token.
	- Connect to instance w/ LightSail Connect SSH
	- cd /var/log
	- sudo cat cloud-init-output.log

## Project Status
I hope to add additional features to make the process easier.
- Provide output of setup token with out logging into Lightsail
- Use GoDaddy API to update DNS Record
- SSL
- Potentially an easy way to start/stop the Lightsail instance after it is built