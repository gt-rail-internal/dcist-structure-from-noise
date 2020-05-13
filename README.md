# Code for the DCIST structure-from-noise project

Folders here: 

analysis - Code used for analysing experiment data. This directory contains the code and data used for different analyses that were performed on the pretest data. Read the documentation in the first few lines of each file for more information on what specific analysis it was used for. (MATLAB)

netlogo - Files for the task setup/environment. This contains the netlogo and html files for the pretest, post test and the robot domain task. It also has a tools directory that contains some python scripts for extracting data from the SQL files in CSV format and converting an adjacency matrix in netlogo's martix format to an adjacency matrix. This can be useful for visualizing or debugging the graph that was used for any subject.  (.nlogo and .html)

logger - Code for the server backend. This uses Flask on Python. Since Flask is not a production server, we use Gunicorn along with Supervisor on the AWS EC2 instance.  (Python)
