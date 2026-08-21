## Command Commands
- Check what process run in a specific port
```
sudo ss -lptn 'sport = :80'
sudo netstat -nlp | grep :80
```
## Nginx
- Create link:
sudo ln -s /etc/nginx/sites-available/movie /etc/nginx/sites-enabled/
- Check error:
sudo tail -n 20 /var/log/nginx/error.log