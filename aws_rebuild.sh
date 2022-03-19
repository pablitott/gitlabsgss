if [[ "$1" == 'rebuild' ]]; then
    # TODO: decide the best method
    # terraform -chdir=./tf destroy
    terraform -chdir=./tf apply -auto-aprove
else
    terraform -chdir=./tf apply
fi
if [[ -f "./tf/inventory.ini" ]]; then
    cp ./tf/inventory.ini ./ansible/inventory.ini
fi

#  Use "-auto-aprove" option to avoid prompt
ansible-playbook ansible/playbooks/host.yml -i ansible/inventory.ini

