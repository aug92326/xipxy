# Use Vagrant for run application #
Please get Vagrant settings from https://bitbucket.org/andreylodossteam/xipsy_vagrant_settings

# another tips # 
psql - U postgres
create database ;
cd /srv/xipsy
rails s -b 0.0.0.0


heroku apps
heroku —app xipsy


git push xipsy-staging staging:master


heroku config:set BUILDPACK_URL='git://github.com/qnyp/heroku-buildpack-ruby-bower.git#run-bower'

##
Record.__elasticsearch__.create_index! force: true
Record.import
###


## origin-tmp ##
https://andreylodossteam@bitbucket.org/andreylodossteam/xipsy.git (fetch)
# origin-tmp #
https://andreylodossteam@bitbucket.org/andreylodossteam/xipsy.git (push)
# xipsy #
git@heroku.com:xipsy.git (fetch)
# xipsy#
git@heroku.com:xipsy.git (push)
# xipsy-staging #
https://git.heroku.com/xipsy-staging.git (fetch)
# xipsy-staging #
https://git.heroku.com/xipsy-staging.git (push)

sudo wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-i686.tar.bz2
sudo tar xjf phantomjs-1.9.7-linux-i686.tar.bz2
sudo ln -s /usr/local/share/phantomjs-1.9.7-linux-i686/bin/phantomjs /usr/local/share/phantomjs
sudo ln -s /usr/local/share/phantomjs-1.9.7-linux-i686/bin/phantomjs /usr/local/bin/phantomjs
sudo ln -s /usr/local/share/phantomjs-1.9.7-linux-i686/bin/phantomjs /usr/bin/phantomjs