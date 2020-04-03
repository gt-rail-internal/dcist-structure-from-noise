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
flex-column
netlogo-speed-slider
netlogo-tab-area

hide them by adding a style=\"visibility: hidden;\" attribute







To grab a CSV:
Run Mysql, then use this command:

SELECT * INTO OUTFILE '/var/lib/mysql-files/db.tablename.txt' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' FROM logger.response;

Read and download the file, db.tablename.txt which is a csv, you can copy it to root like this:

sudo cp /var/lib/mysql-files/db.tablename.txt  output.txt

Then exit shell and scp it to your local machine:

scp -i "key.pem" ubuntu@ec2-34-227-18-144.compute-1.amazonaws.com:output.txt out.txt





