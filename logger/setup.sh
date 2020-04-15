sudo apt-get -y update
sudo apt-get -y install mysql-server supervisor nginx git
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1
sudo update-alternatives --config python
sudo apt-get -y install python-pip
pip install flask
pip install python-dotenv
pip install flask-sqlalchemy
pip install flask-migrate
pip install flask-cors
pip install gunicorn pymysql

