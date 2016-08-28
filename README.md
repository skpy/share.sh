# share.sh

`share.sh` allows you to send a file via rsync to a server you control. You get to choose where uploaded files will live, and use whatever vanity URL you have to share them.

```
./share.sh [-d DIR] [-e] [-h] [-o OPTIONS] [-t TARGET] [-u URL]

 -d directory on server
 -e echo output, rather than call open
 -h help
 -o options to pass to rsync
 -t rsync target
 -u base URL for files
```

You may set defaults in a configuration file at `$HOME/.config/share.sh`. Each option is a KEY=VALUE pair that matches an argument for the script.  For example:
```
DIR='share'
ECHO=1
OPTIONS='-e ssh'
TARGET='user@example.com:/var/www/html/'
URL='https://example.com/'
```

Command line values will override config file values.
