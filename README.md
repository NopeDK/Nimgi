# Nimgi - Attempt at integrating Nim with uwsgi

## Example on how to use:
+ Get and build uwsgi as core
+ Build "corerouter" and "http" as plugins to core
+ Copy "uwsgi", "uwsgi.h", "http_plugin.so" and "corerouter_plugin.so" to your project folder
+ Compile the Nim code
+ Launch "uwsgi --ini nimgi.ini"
+ Try to "wget -t 1 localhost:9090" to test the server
+ Crash (for now)

## Alternatively, if you have the build essentials installed
+ Execute the "uwsgi_init.sh" script, this handles the first three steps above
