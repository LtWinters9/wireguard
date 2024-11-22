# wireguard
Simple script to install and setup wg vpn. 
Update script also included, will require swaks for sending mail.  
-
Before you start, need to create a password hash by doing - 
docker run -it ghcr.io/wg-easy/wg-easy wgpw YOUR_PASSWORD
Then add the output of the hash into the "WGPW" within install.sh
-
Download files, run chmod +x *
-
Please also update, update.sh to change where this script will be located. 
-
./install.sh
Enjoy!
