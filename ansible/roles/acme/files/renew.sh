#!/bin/sh -ex

cd /home/acme

python3 acme_tiny.py --account-key account.key --csr honoluluorg.csr --acme-dir /home/acme/challenges > signed.crt
intermediateUrl=$(openssl x509 -in signed.crt -noout -text | grep -A 1 "Authority Information Access" | tail -1 | grep -o 'http://.*')
wget $intermediateUrl -O intermediate.der
openssl x509 -in intermediate.der -inform der -out intermediate.crt -outform pem
cat signed.crt intermediate.crt > /etc/nginx/certs/chained.pem
sudo service nginx restart
