# sync-mirror-gitlab
syncing mirror repository on gitlab:

this functionality work on imported repository to gitlab , or you need set an remote on each repository you need to sync with mirror, 

functionality: 
  check mirror group on gitlab and iterate on that for finding repositories need to sync
  on each repository check all remote and try to fetch update from that remote.

you can set a cron for syncing automatically: 

```
# m h dom mon dow user  command   
* * * * *       root    bash /root/syncing-git-script/syncronize-git-mirror.sh
```

  overlap between cron job is handled 

  log of syncing is stored on logpath based on config file

  ```LOGPATH="/var/log/"```

  sometimes you need set a logrotation because of logfile size  
  you can set a logrotate by creating a file on '/etc/logrotate.d/'
  and adding this content: 
  ```
  /var/log/syncronize-git-mirror.log {
    rotate 5
    daily
    compress
    missingok
    notifempty
  }
```
