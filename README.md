# Nimgi - Attempt at integrating Nim with uwsgi

## Example on how to use:
+ Get and build uwsgi as core
+ Build "corerouter" and "http" as plugins to core
+ Compile the code
+ Launch "uwsgi --plugin=http,nimgi --http 0.0.0.0:9090 --http-modifier1=250"
+ Try to "wget -t 1 localhost:9090" to test the server
+ Crash (for now)
