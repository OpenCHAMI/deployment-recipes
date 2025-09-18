ssh -t admin 'pushd quickstart-pcs && source bash_functions.sh && gen_access_token >access_token'
scp admin:quickstart-pcs/access_token .
