#!/bin/bash

cd /root
echo "$KEY_PEM" >> key.pem
chmod 600 key.pem
