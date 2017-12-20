version="2.0.15"
rm -rf "uwsgi-${version}/"
wget "https://projects.unbit.it/downloads/uwsgi-${version}.tar.gz"
tar xf "uwsgi-${version}.tar.gz"
rm "uwsgi-${version}.tar.gz"
cd "uwsgi-${version}/"
python "uwsgiconfig.py" --build core
python "uwsgiconfig.py" --plugin plugins/http core
python "uwsgiconfig.py" --plugin plugins/corerouter core
cp {uwsgi,uwsgi.h,http_plugin.so,corerouter_plugin.so} ../
cd ..
