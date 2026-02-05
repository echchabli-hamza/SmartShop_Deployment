hamza@hamza:/tmp$ cd ../
hamza@hamza:/$ docker exec smartshop-control-plane mkdir -p /tmp/k8s-postgres
hamza@hamza:/$ docker exec smartshop-control-plane chown -R 999:999 /tmp/k8s-postgres
hamza@hamza:/$ 
docker exec smartshop-control-plane chmod 755 /tmp/k8s-postgres
hamza@hamza:/$ 
docker exec smartshop-control-plane chmod 755 /tmp/k8s-postgres
hamza@hamza:/$ docker exec smartshop-control-plane ls -la /tmp/ | grep k8s-postgres
drwxr-xr-x 2  999 systemd-journal   40 Feb  5 14:49 k8s-postgres
hamza@hamza:/$ 


