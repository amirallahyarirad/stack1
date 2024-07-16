#Install certbot
apt install certbot python3-certbot-nginx

#Primary method:
certbot --nginx -d myphadmin.domain.com -d wordpress.domain.com

#Alternative method:
#Generating Wildcard Certificates
certbot certonly --manual --preferred-challenges=dns --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.domain.com

#Please deploy a DNS TXT record under the name:
_acme-challenge.domain.com.

with the following value:
hqKo0QsiFSvBU2S368l79p2fKql9yQGqjgvOTgAfplo

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.domain.com.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

#Verifying Certbot Auto-Renewal
Let’s Encrypt’s certificates are only valid for ninety days. This is to encourage users to automate their certificate renewal process. The certbot package we installed takes care of this for us by adding a systemd timer that will run twice a day and automatically renew any certificate that’s within thirty days of expiration.

#You can query the status of the timer with systemctl:

#sudo systemctl status snap.certbot.renew.service

#Output
snap.certbot.renew.service - Service for snap application certbot.renew
     Loaded: loaded (/etc/systemd/system/snap.certbot.renew.service; static)
     Active: inactive (dead)
TriggeredBy: ● snap.certbot.renew.timer
#To test the renewal process, you can do a dry run with certbot:

sudo certbot renew --dry-run




![image](https://github.com/user-attachments/assets/e07d414e-0753-4e60-9eca-07579f3e6d3e)
