ssh -t admin 'pushd quickstart-pcs && make re'
scp admin:quickstart-pcs/{cacert.pem,access_token} .
