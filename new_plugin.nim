from strutils import escape


type
  Worker {.importc: "struct uwsgi_worker", header: "uwsgi.h", incompleteStruct, pure.} = object # Tried both with and without incompleteStruct
    apps: UncheckedArray[App] # Tried both ptr[t] and UncheckedArray. Pointer crashes instantly,
                              # UncheckedArray crashes on access
  Server {.importc: "struct uwsgi_server", header: "uwsgi.h", incompleteStruct, pure.} = object
    default_app: cint
    no_default_app: cint
    mywid: cint
    workers: UncheckedArray[Worker] # Same as the "apps" above
  App {.importc: "struct uwsgi_app", header: "uwsgi.h", incompleteStruct, pure.} = object
    modifier1: cuchar
  Request {.importc: "struct wsgi_request", header: "uwsgi.h", incompleteStruct, pure.} = object
    id {.importc: "app_id".}: cint
    appid: cstring
    appid_len: cushort
    methd {.importc: "method".}: cstring
    protocol: cstring
    protocol_len: cushort
  Plugin {.importc: "struct uwsgi_plugin", header: "uwsgi.h", incompleteStruct, pure.} = object
    name: cstring
    modifier1: cuchar
    request: proc(a: ptr Request): cint {.noconv.}
    init_apps: proc() {.noconv.}
    worker: proc(): cint {.noconv.}

var uwsgi {.used, importc: "uwsgi".}: Server # "extern struct uwsgi_server uwsgi", access to global server struct
var nimgi_plugin {.used, exportc.}: Plugin # plugin struct that gets loaded by uwsgi

proc addApp(id: cint, modifier: cuchar, mountpoint: cstring,
            length: cint, intrp: pointer, callable: pointer): ptr App {.importc: "uwsgi_add_app", header: "uwsgi.h", noconv.}
proc parseVars(a: ptr Request): cint {.importc: "uwsgi_parse_vars", header: "uwsgi.h", noconv.}
proc getAppID(a: ptr Request, b: cstring, c: cushort, d: cint): cint {.importc: "uwsgi_get_app_id", header: "uwsgi.h", noconv.}

proc test(a: ptr Request): cint {.noconv.} = # Request handler, will call other Nim functions in the future
  echo("Received request")
  echo(escape($a[]))
  if parseVars(a) != 0: return -1
  echo("Parsed")
  echo(escape($a[]))
  a.id = getAppID(a, a.appid, a.appid_len, cint(nimgi_plugin.modifier1))
  echo("New ID")
  echo(escape($a[]))
  if a.id == -1 and uwsgi.no_default_app == 0 and uwsgi.default_app > -1:
    echo("Change ID")
    echo(escape($(uwsgi.workers[uwsgi.mywid]))) # TODO: Fix crash by SIGSEGV due to invalid access
  echo("Completed parsing")
  echo(escape($a[]))

proc init() {.noconv.} = # Init handler
  echo("Init apps")
  discard addApp(0, cuchar(250), "", 0, nil, nil)
  echo("Server: " & escape($uwsgi))

proc worker_spawn(): cint {.noconv, discardable.} = # On worker spawn handler
  echo("Worker!")

nimgi_plugin = Plugin(
                      name: "Nimgi", # Plugin name
                      modifier1: cuchar(250), # Plugin modifier (same as "uwsgi example" for now)
                      request: test, # Function to call on request
                      init_apps: init, # Function to call on init
                      worker: worker_spawn # Function to call on worker spawn
                     )
