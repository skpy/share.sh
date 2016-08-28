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

## Tips and Tricks
You don't have to use a static value for the target directory.  The config file and the command line both support normal shell tricks, like `$(date +%Y%m%d)` for date-based directory names, or `$(base64 /dev/urandom | tr -d '/+oO0' | dd bs=10 count=1 2>/dev/null)` for a random 10 character directory name.

OSX users might like to create an Automator service to allow invoking `share.sh` from the Finder, to make it super easy easy to share files.
* Create a Service that receives "files or folders".
* From the "Utilities" library, select "Run Shell Script".
* Ensure the input is passed as arguments.
* Call your instance of this script: `/usr/local/bin/share.sh "$1"`.
  * be sure to quote the parameter! I explicitly accept only the first parameter in this example, to ensure I don't accidentally share a selection of many files.
  * optionally add `-e` to the script invocation, and than add a "Copy to Clipboard" step to the Service, if you'd rather not have the link open in your browser.
