from strutils import escape


type
  Worker {.importc: "struct uwsgi_worker", header: "uwsgi.h", pure.} = object
    apps: UncheckedArray[App]
  Server {.importc: "struct uwsgi_server", header: "uwsgi.h", pure.} = object
    default_app: cint
    no_default_app: cint
    mywid: cint
    workers: UncheckedArray[Worker]
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

var uwsgi {.used, importc: "uwsgi".}: Server
var nimgi_plugin {.used, exportc.}: Plugin

proc addApp(id: cint, modifier: cuchar, mountpoint: cstring,
            length: cint, intrp: pointer, callable: pointer): ptr App {.importc: "uwsgi_add_app", header: "uwsgi.h", noconv.}

proc parseVars(a: ptr Request): cint {.importc: "uwsgi_parse_vars", header: "uwsgi.h", noconv.}
proc getAppID(a: ptr Request, b: cstring, c: cushort, d: cint): cint {.importc: "uwsgi_get_app_id", header: "uwsgi.h", noconv.}

proc test(a: ptr Request): cint {.noconv.} =
  echo("Received request update")
  echo(escape($a[]))
  if parseVars(a) != 0: return -1
  echo("Parsed")
  echo(escape($a[]))
  a.id = getAppID(a, a.appid, a.appid_len, cint(nimgi_plugin.modifier1))
  echo("New ID")
  echo(escape($a[]))
  echo(escape($(uwsgi)))
  if a.id == -1 and uwsgi.no_default_app == 0 and uwsgi.default_app > -1:
    echo("Change ID")
    echo(escape($(uwsgi.workers[uwsgi.mywid])))#.apps[uwsgi.default_app].modifier1 == cuchar(0):
#      a.id = uwsgi.default_app
  echo(escape($a[]))

proc init() {.noconv.} =
  echo("Init apps")
  discard addApp(0, cuchar(250), "", 0, nil, nil)
  echo("Server: " & escape($uwsgi))
#  {.emit: """uwsgi_apps_cnt++;""".}

proc worker_spawn(): cint {.noconv, discardable.} =
  echo("Worker!")

nimgi_plugin = Plugin(
                      name: "Nimgi",
                      modifier1: cuchar(250),
                      request: test,
                      init_apps: init,
                      worker: worker_spawn
                     )
