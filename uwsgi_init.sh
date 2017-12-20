version="2.0.15"
rm -f "uwsgi_init.log"
printf "%0*d%s%0*d\n" 20 0 "   ---Removing old version---   " 20 0
printf "%0*d%s%0*d\n" 20 0 "   ---Removing old version---   " 20 0 1>>"uwsgi_init.log"
rm -rf "uwsgi-${version}/" 1>>"uwsgi_init.log"
printf "%0*d%s%0*d\n" 18 0 "   ---Downloading uwsgi source---   " 18 0 && \
printf "%0*d%s%0*d\n" 18 0 "   ---Downloading uwsgi source---   " 18 0 1>>"uwsgi_init.log" && \
wget -nv -a "uwsgi_init.log" "https://projects.unbit.it/downloads/uwsgi-${version}.tar.gz" && \
printf "%0*d%s%0*d\n" 22 0 "   ---Unpacking source---   " 22 0 && \
printf "%0*d%s%0*d\n" 22 0 "   ---Unpacking source---   " 22 0 1>>"uwsgi_init.log" && \
tar xf "uwsgi-${version}.tar.gz" 1>>"uwsgi_init.log" && \
printf "%0*d%s%0*d\n" 22 0 "   ---Removing archive---   " 22 0 && \
printf "%0*d%s%0*d\n" 22 0 "   ---Removing archive---   " 22 0 1>>"uwsgi_init.log" && \
rm -vf "uwsgi-${version}.tar.gz" 1>>"uwsgi_init.log" && \
cd "uwsgi-${version}/" && \
printf "%0*d%s%0*d\n" 21 0 "   ---Building uwsgi core---   " 20 0 && \
printf "%0*d%s%0*d\n" 21 0 "   ---Building uwsgi core---   " 20 0 1>>"uwsgi_init.log" && \
python "uwsgiconfig.py" --build core 1>>"../uwsgi_init.log"
printf "%0*d%s%0*d\n" 17 0 "   ---Building corerouter plugin---   " 17 0 && \
printf "%0*d%s%0*d\n" 17 0 "   ---Building corerouter plugin---   " 17 0 1>>"uwsgi_init.log" && \
python "uwsgiconfig.py" --plugin plugins/corerouter core 1>>"../uwsgi_init.log" && \
printf "%0*d%s%0*d\n" 20 0 "   ---Building http plugin---   " 20 0 && \
printf "%0*d%s%0*d\n" 20 0 "   ---Building http plugin---   " 20 0 1>>"uwsgi_init.log" && \
python "uwsgiconfig.py" --plugin plugins/http core 1>>"../uwsgi_init.log" && \
printf "%0*d%s%0*d\n" 25 0 "  ---Moving files---   " 24 0 && \
printf "%0*d%s%0*d\n" 25 0 "  ---Moving files---   " 24 0 1>>"uwsgi_init.log" && \
cp {uwsgi,uwsgi.h,http_plugin.so,corerouter_plugin.so} ../ 1>>"../uwsgi_init.log"
if [ $? -eq 0 ]; then
  printf "%0*d%s%0*d\n" 26 0 "   ---SUCCESS!---   " 26 0
  printf "%0*d%s%0*d\n" 26 0 "   ---SUCCESS!---   " 26 0 1>>"uwsgi_init.log"
else
  printf "%0*d%s%0*d\n" 26 0 "   ---FAILURE!---   " 26 0
  printf "%0*d%s%0*d\n" 26 0 "   ---FAILURE!---   " 26 0 1>>"uwsgi_init.log"
fi
