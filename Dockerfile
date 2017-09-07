FROM ajbisoft/debian9_lapp
MAINTAINER Jakub Kwiatkowski <jakub@ajbisoft.pl>
COPY odbc_config /usr/local/bin/
COPY msodbcsql-13.0.0.0.tar.gz /usr/local/src/
RUN apt-get update && apt-get install -y unixodbc odbcinst php7.1-odbc libgss3 unixodbc-dev php7.1-dev php-pear libssl-dev \
  && cd /usr/local/src/ && tar -xf msodbcsql-13.0.0.0.tar.gz && cd msodbcsql-13.0.0.0 && ldd lib64/libmsodbcsql-13.0.so.0.0 \
  && printf '#!/bin/bash\n[ "$*" == "-p" ] && echo "x86_64" || /bin/uname "$@"' > /usr/local/bin/uname && chmod +x /usr/local/bin/uname \
  && sed -i.bak 's/req_dm_ver="2.3.1";/req_dm_ver="2.3.4";/' install.sh \
  && ./install.sh install --accept-license && odbcinst -q -d -n "ODBC Driver 13 for SQL Server" && rm -rf /usr/local/src/msodbcsql-13* \
  && pecl channel-update pecl.php.net && pecl install pdo_sqlsrv-4.1.6.1 && printf "; priority=20\nextension=/usr/lib/php/20160303/pdo_sqlsrv.so" > /etc/php/7.1/mods-available/pdo_sqlsrv.ini && phpenmod pdo_sqlsrv \
  && apt-get --purge remove unixodbc-dev php7.1-dev php-pear libssl-dev && apt-get -y --purge autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* \
