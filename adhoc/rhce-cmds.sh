#!/bin/bash

sudo ansible -i hosts all -m user -a "name=automation password={{ 'devops' | password_hash('sha512', 'salt')}}"
ansible -i hosts localhost -m file -a 'path=/home/automation/.ssh state=directory'



ansible -i hosts localhost -m openssh_keypair -a "path=/home/automation/.ssh/id_rsa owner=automation group=automation type=rsa"


sudo ansible -i hosts all -m authorized_key -a "key={{ lookup('file', '/home/automation/.ssh/id_rsa.pub') }} user=automation"


sudo ansible -i hosts all -m copy -a 'content="automation ALL=(ALL) NOPASSWD:ALL" dest=/etc/sudoers.d/automation'

HOSTS=$(ansible -i hosts all --list-hosts | sed '1d')

for HOST in $HOSTS
do
  KEY=$(ssh-keyscan -t rsa $HOST 2>/dev/null)
  ansible -i hosts localhost -m known_hosts -a "key='${KEY}' name=$HOST path=/home/automation/.ssh/known_hosts" -b
done

