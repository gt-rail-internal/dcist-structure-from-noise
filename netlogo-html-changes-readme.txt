Things to change in Netlogo HTML

find "BUTTON" to locate the coordinates of the buttons. they look like 
30
110
85
144
H
make the numbers all 0 - repeat for all keys

div classes to be hidden:
netlogo-subheader
netlogo-display-horizontal: this doesn't like display none
flex-column  (its where the Export: and buttons are)
netlogo-speed-slider
netlogo-tab-area

hide them by adding a style="visibility: hidden;" attribute
style= "display: none;" attribute removes the area for it?


body {
    -moz-transform: scale(0.8, 0.8); /* Moz-browsers */
    zoom: 0.8; /* Other non-webkit browsers */
    zoom: 80%; /* Webkit browsers */
}
add to the top css part to make it smaller







To grab a CSV:

login to server 

delete old one
sudo rm /var/lib/mysql-files/db.tablename.txt  

Run Mysql, using "sudo mysql" then use this command:

SELECT * INTO OUTFILE '/var/lib/mysql-files/db.tablename.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' FROM logger.response;

Read and download the file, db.tablename.txt which is a csv, you can copy it to root like this:

sudo cp /var/lib/mysql-files/db.tablename.txt  output.txt

Then exit shell and scp it to your local machine:

scp -i "key.pem" ubuntu@ec2-54-89-180-124.compute-1.amazonaws.com:output.txt out.txt




to dump database into file for part 1
in shell of server:
sudo mysqldump logger > test.mysql

https://www.digitalocean.com/community/tutorials/how-to-import-and-export-databases-in-mysql-or-mariadb#:~:text=To%20import%20an%20existing%20dump%20file%20into%20MySQL,will%20bring%20you%20into%20the%20MySQL%20shell%20prompt

Download the mysql file using scp then
\
To start login locally do this:
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -p -u root

R0b0tsAr3C00l!

DROP DATABASE logger; or where new_database has a number appended
CREATE DATABASE logger; 

in cmd

"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p new_database < test.mysql

