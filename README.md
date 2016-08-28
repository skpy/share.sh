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

Note that it is perfectly acceptable for `DIR` to be empty.  You may define the destination directory right in the rsync target, if you like.

## Tips and Tricks
### Variable Directory Names
You don't have to use a static value for the target directory.  The config file and the command line both support normal shell tricks, like `$(date +%Y%m%d)` for date-based directory names, or `$(base64 /dev/urandom | tr -d '/+oO0' | dd bs=10 count=1 2>/dev/null)` for a random 10 character directory name.

### Automatic Cleanup
Often times you're sharing something for quick review, and not making a permanent addition to the world wide web.  On your server, you might want to run a cron job to automatically delete files older than a day or two.  This will ensure that you don't have unnecessary files hanging around in perpetuity.
```
5 8 * * * /usr/bin/find /PATH/TO/YOUR/SHARE -maxdepth 1 -mtime +1 -type f -delete
```
This would need to be adjusted if you're using variable destination directories.

Using the `-d` or `-t` flags would allow you to upload files to a different directory if you wanted them to live longer than your scheduled cleanup job.

### OSX Automator
OSX users might like to create an Automator service to allow invoking `share.sh` from the Finder, to make it super easy easy to share files.
* Create a Service that receives "files or folders".
* From the "Utilities" library, select "Run Shell Script".
* Ensure the input is passed as arguments.
* Call your instance of this script: `/usr/local/bin/share.sh "$1"`.
  * be sure to quote the parameter! I explicitly accept only the first parameter in this example, to ensure I don't accidentally share a selection of many files.
  * optionally add `-e` to the script invocation, and than add a "Copy to Clipboard" step to the Service, if you'd rather not have the link open in your browser.
