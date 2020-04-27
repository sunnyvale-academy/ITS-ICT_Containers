. /vagrant/scripts/.env
echo "export GIT_REPO_NAME=$GIT_REPO_NAME" > /home/vagrant/.bash_profile
echo "export GOROOT=$GOROOT" >> /home/vagrant/.bash_profile
echo "export GOPATH=$HOME/go" >> /home/vagrant/.bash_profile
echo "export PATH=$GOPATH/bin:$GOROOT/bin:$HOME/rbenv/bin:$PATH" >> /home/vagrant/.bash_profile
echo "export LC_ALL=en_US.UTF-8" >> /home/vagrant/.bash_profile
echo "export LC_CTYPE=en_US.UTF-8" >> /home/vagrant/.bash_profile