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
netlogo-display-horizontal
flex-column  (its where the Export: and buttons are)
netlogo-speed-slider
netlogo-tab-area

hide them by adding a style=\"visibility: hidden;\" attribute
display: none; attribute removes the area for it?


body {
    -moz-transform: scale(0.8, 0.8); /* Moz-browsers */
    zoom: 0.8; /* Other non-webkit browsers */
    zoom: 80%; /* Webkit browsers */
}
add to the top css part to make it smaller







To grab a CSV:
delete old one
sudo rm /var/lib/mysql-files/db.tablename.txt  

Run Mysql, using "sudo mysql" then use this command:

SELECT * INTO OUTFILE '/var/lib/mysql-files/db.tablename.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' FROM logger.response;

Read and download the file, db.tablename.txt which is a csv, you can copy it to root like this:

sudo cp /var/lib/mysql-files/db.tablename.txt  output.txt

Then exit shell and scp it to your local machine:

scp -i "key.pem" ubuntu@ec2-34-227-18-144.compute-1.amazonaws.com:output.txt out.txt





