#!/bin/bash
 ansible anslab -m yum_repository -a 'name=test  description= "testrepo"  baseurl=https://thethwaite.com gpgcheck=no'



