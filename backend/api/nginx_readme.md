# Nginx setup

### Install nginx for the first time
```commandline
sudo apt install nginx
```

### Edit the nginx config file
```commandline
sudo nano /etc/nginx/sites-available/default
```

### Replace file content with 
```
server {
  listen 80 default_server;
  server_name _;

  return 301 https://$host$request_uri;
}


server {
  server_name api.heymonk.app;
  client_max_body_size 100M;

  location / {
    root /home/developer/Monk/backend/api/;
    proxy_pass "http://127.0.0.1:8001";
  }

  proxy_read_timeout 300;
  proxy_connect_timeout 300;
  proxy_send_timeout 300;
}
```

### Restart nginx
```commandline
sudo systemctl restart nginx
```

## Certbot setup

### install certbot for the first time
```commandline
sudo apt install certbot python3-certbot-nginx
```

### Install new certificate for the domain
```commandline
sudo certbot --nginx -d api.heymonk.app
```

