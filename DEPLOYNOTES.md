# Deploynotes
The deployment is managed by Capistrano.

Global depoly settings are found in `Capfile`. Staging and Productions settings are found in `config/deploy`.

## Deploy to Staging
`cap deploy staging`

## Deploy to Productions
`cap deploy production`
In `config/initializers/assets.rb` there is a the line to compile the rails_admin assets for production:

`Rails.application.config.assets.precompile += %w( rails_admin/rails_admin.css
rails_admin/rails_admin.js )`

## Server Setup
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
http://www.gis-blog.com/how-to-install-postgis-2-3-on-ubuntu-16-04-lts/
https://www.phusionpassenger.com/library/install/nginx/install/oss/xenial/

### Basic Server Stuff
sudo su -
lsblk
mkfs.ext4 /dev/xvdb
mkdir /data
mount /dev/xvdb /data
vim /etc/fstab
/dev/xvdb       /data   ext4    defaults        1 1
mkdir /data/atlmaps-server
mkdir /data/atlmaps-client
chown deploy:deploy /data/*
mkdir /data/nginx

the following is from
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
apt install git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
su - deploy

~/.profile:
```
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\, Branch\: \1/'
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

MYPS1=`uname -a | cut -d' ' -f 2`" / \u"

if [ $USER == "root" ]; then
        PROMPT="#"
else
   PROMPT="$"
fi

export PS1="\033[0;32m$MYPS1 \033[0;36m\t \033[0;32m[ \033[0;31m\w\033[0;32m\$(parse_git_branch)]\033[0m\033[1;30m\033[0m\n$PROMPT "
```

### RBENV
~~~bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
source ~/.profile
type rbenv

rbenv is a function
rbenv ()
{
    local command;
    command="$1";
    if [ "$#" -gt 0 ]; then
        shift;
    fi;
    case "$command" in
        rehash | shell)
            eval "$(rbenv "sh-$command" "$@")"
        ;;
        *)
            command rbenv "$command" "$@"
        ;;
    esac
}

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 2.2.7
Take a bathroom break or grab some coffee or beer.
rbenv global 2
~~~

#### Verify

~~~bash
ruby -v
ruby 2.2.7p470 (2017-03-28 revision 58194) [x86_64-linux]
~~~

#### Ruby Setup
~~~bash
gem install bundle
~~~

### Install GIS Stuff
~~~bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt update
sudo apt install gdal-bin libgdal-dev libgeos-dev
~~~

### PostgreSQL and PostGIS
*Note, if the `depoly` user does not have sudo rights - not recommend - you will need to run sudo commands with an user that has sudo rights.*

~~~bash
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
~~~

For dev, and maybe even for staging, we'll run PostgreSQL locally. In production, we'll use AWS RDS.

#### For Dev/Staging

~~~bash
sudo apt install postgresql-9.6 postgresql-contrib-9.6 postgis
~~~

Create a database and user. You'll need to make note of this later for the `database.yaml`

~~~bash
sudo -h localhost -u <username> createuser -P <database name>
~~~

Skip this step if you are  importing a dump from an ATLMaps database.

~~~bash
sudo -u postgres psql -c "CREATE EXTENSION postgis; CREATE EXTENSION postgis_topology;" <database name>
~~~

*Trouble importing dump?*
[Try this...](https://dba.stackexchange.com/a/60911)

*Trouble with Spatial Search?*

~~~bash
rails c
~~~

~~~ruby
RGeo::Geos.supported?
~~~

~~~bash
gem uninstall rgeo
apt install libgeos-dev
gem install rgeo
~~~

Make sure the `config/database.yml` has
`adapter: postgis`

#### For Production
~~~bash
sudo apt install postgresql-client
~~~

##### Setup PostGIS: http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS

Allow the instance to access the database via the RDS security group.

### Deploy the ATLMaps-Server
Make sure the the config are up-to-date.

If new server, add RSA key to the GitHub repo's deploy keys.

### Deploy with Nginx and Passenger
https://www.phusionpassenger.com/library/install/nginx/install/oss/xenial/
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt update
sudo apt install nginx nginx-extras passenger

Edit /etc/nginx/nginx.conf and uncomment include /etc/nginx/passenger.conf;

Example nginx.conf
~~~
server {
    listen 80;
    # listen [::]:80;
    server_name api.atlmaps.com;
    return 301 https://api.atlmaps.com$request_uri;
}

server {
    listen 443;
    ssl on;
    ssl_certificate /data/certs/api.atlmaps.com/api.atlmaps.com.chained.crt;
    ssl_certificate_key /data/certs/api.atlmaps.com/api.atlmaps.com.key;

    server_name api.atlmaps.com;
    rails_env production;
    # Tell Nginx and Passenger where your app's 'public' directory is
    root /data/atlmaps-server/current/public;

    # Turn on Passenger
    passenger_enabled on;
    # passenger_ruby /home/deploy/.rbenv/versions/2.2.7/bin/ruby;
    passenger_ruby /home/deploy/.rbenv/shims/ruby;
}
~~~
*NOTE* the chained cert is created by combining the domain's cert and the the provider's (GoDaddy in this case) bundled certs. Order totally matters!
`cat cb47a46b3c7438b0.crt gd_bundle-g2-g1.crt > atlmaps.com.chained.crt`

To run rails and rake commands, make sure you are using the rbenv for the app.
rbenv version
2.2.7 (set by /data/atlmaps-server/current/.ruby-version)

If it is not the correct version, run:
rbenv local 2.2.7

And to run rails and rake commands:
bundle exec rails c
