# Code for the DCIST structure-from-noise project

## Summary of the Project status (for Structure from Noise authors):

This is a previous email we sent:
https://docs.google.com/document/d/1yoOJss9qrUjFHneC2NDYFxsKpEhMxOI_YTU9RPl9-Z8/edit

### Summary to Chris and Ari potetnailly:

As you know from our previous email, we successfully ran a similar test to yours (same setup but two clusters) along with two other studies to find correlation between all three studies.  This was run with 35 people on Mechanical Turk, with your study being first and two other robotics related ones following.

We have two ideas to run still:???

1.  Can using the beta value as a predictor of skill level, larger is better be reasonable?

2.  When reading the RMSE curves, sometimes there's no definitive minima and for instance a beta of 1 or 10 can have similar RMSE values.  Do you have any insight on how to score using that?

# There's three parts to the study:

1.  Structure from Noise:  This copies a U Penn study that shows a pattern of flashing keys and attempts to find one's memory of structure which is shown as a "beta" value in a mixed effect model.

2.  Our study on finding the fastest propagating agent in a static map.

3.  This is inspired from a University of Pittsburgh experiment where you have to collect flags with multiple robots that you control.

I recommend you look at our instructions for study subjects in the analysis folder for one of the studies it'll give you a good idea of what's going on.

In the studies we had impressions and results from Mechanical Turk that we presented in meetings.  Those are in the Slack "structure from noise" group and also I doubled the graphs straight in the Github mostly.

### Folders here:

analysis - Code used for analyzing experiment data. This directory contains the code and data used for different analyses that were performed on the pretest data. Read the documentation in the first few lines of each file for more information on what specific analysis it was used for. (MATLAB)

netlogo - Files for the task setup/environment. This contains the netlogo and html files for the pretest, post test and the robot domain task. It also has a tools directory that contains some python scripts for extracting data from the SQL files in CSV format and converting an adjacency matrix in netlogo's martix format to an adjacency matrix. This can be useful for visualizing or debugging the graph that was used for any subject.  (.nlogo and .html)

logger - Code for the server backend. This uses Flask on Python. Since Flask is not a production server, we use Gunicorn along with Supervisor on the AWS EC2 instance.  (Python)

#### Your best person of contact at the moment for code details is probably:

Kenneth Shaw
I should be still in the RAIL Slack, if not kshaw2@andrew.cmu.edu.
I can also give you login for the EC2 that hosts the project as well as the Mturk account login.
Akshay Krishnan also worked on the project w/ me during the middle of the project cycle.  Of course Harish and Sonia are good resources as well.

#### Todo:

We have paired data for many subjects but we only see correlation between 2 and 3 and not 1 and 3 in our total study with approximately 35 subjects.  The question becomes whether that's an issue of how the beta value is calculated for study 1 or if there's actually no correlation between the two.  The RMSE minima of the mixed effect models are still a tbd on if we're doing it 100% right.  We're thinking that the models should have a stronger predictive power, aka we should have a stronger negative correlation when we run the model across in Matlab.
