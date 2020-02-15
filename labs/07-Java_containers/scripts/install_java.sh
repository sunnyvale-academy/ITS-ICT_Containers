sudo apt-key -y adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9

sudo apt-add-repository -y 'deb http://repos.azulsystems.com/ubuntu stable main'
sleep 10
sudo apt install -y --allow-unauthenticated zulu-11

