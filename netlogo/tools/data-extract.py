# this code was used to extract data from the sql file that is stored on the server. 
# also can be used to generate some synthetic data for debugging. 
# In order to use this code, the name and password of the mysql database is to be provided. 
# If you would like to use this code locally, first export the data on the server to an SQL 
# file and then import this SQL file to a MySQL database that is local. The data can then be 
# read from this local MYSQL database. 
# the functions for using synthtic data have been commented. uncomment them if necessary.
import pymysql.cursors
#import matplotlib.pyplot as plt
import csv
import statistics
import random


conn = pymysql.connect(host = 'localhost', user='rail', password='R0b0tsAr3C00l!', db='logger',charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
crsr = conn.cursor()
# name of the table being used is response. change if necessary, 
crsr.execute("select * from response;")
data = crsr.fetchall()
random.seed(0)

# mean and standard deviation used for sampling synthetic data. 
# high_rt = 1200.0
# low_rt = 800.0
# rt_std = 20.0

## Converts the comma separated string of times in the format HH:MM:SS.MS 
## to a float number that is in seconds. Returns a list of float. 
def timeStringToFloat(time_string):
	result = []
	time_string_list = time_string.split(', ')
	first = True
	for element in time_string_list:
		time, xm, date = element.split(' ')
		hh, mm, ss = time.split(':')
		time_int = (int(hh)*3600 + int(mm)*60 + float(ss))
		if first:
			prev_time = time_int
		if xm == 'PM' and int(hh) != 12:
			time_int += 12*3600
		result.append(time_int)
	return result

# helper to convert string list to int
def stringListToInt(string_list):
	return [int(item) for item in string_list.split(', ')]

# takes as input the string format adjacency list that is logged 
# and uses it to compute the in-cluster transitions, out-cluster transitions
# and the adjacency list in integer format. 
# the inclusters and out clusters are obtained based on the order of the nodes in the 
# list representation through a convention used when this list is created in netlogo. 
def createGraph(input_str, graph_type):
	graph = {}
	input_str = input_str[2:-2]
	adj_list_char = input_str.split("] [")
	adj_list = [chars.split(" ") for chars in adj_list_char]
	adj_list = [[int(number) for number in adj_list[i]] for i in range(0, len(adj_list))]
	in_cluster = []
	out_cluster = []
	if graph_type == "modular":
		for i, adj in enumerate(adj_list):
			in_cluster.append((i, adj[1]))
			in_cluster.append((i, adj[2]))
			j = adj[0]
			in_cluster_flag = False
			for k in adj:
				if j in adj_list[k]:
					in_cluster_flag = True
					break
			if in_cluster_flag:
				in_cluster.append((i, j))
				l = adj[3]
				in_cluster_flag = False
				for k in adj:
					if l in adj_list[k]:
						in_cluster_flag = True
						break
				if in_cluster_flag:
					in_cluster.append((i, l))
				else:
					out_cluster.append((i, l))
			else:
				out_cluster.append((i, j))
				in_cluster.append((i, adj[3]))
	else:
		for i, adj in enumerate(adj_list):
			in_cluster.append((i, adj[0]))
			in_cluster.append((i, adj[1]))
			out_cluster.append((i, adj[2]))
			out_cluster.append((i, adj[3]))
	return adj_list, in_cluster, out_cluster


# returns a random walk in a graph. used to synthetic data generation. 
def randomWalk(adj_list, length):
	walk = [random.randint(0, 14)]
	for i in range(1, length):
		walk.append(adj_list[walk[i-1]][random.randint(0, 3)])
	return walk

# handlers to write data to different files. 
rt_writer = csv.writer(open('rt-small-graph-h-02.csv', 'w', newline='\n'))
trial_writer = csv.writer(open('trial-small-graph-h-02.csv', 'w', newline='\n'))
target_writer = csv.writer(open('target-small-graph-h-02.csv', 'w', newline='\n'))
graph_type_writer = csv.writer(open('graph-type-small-graph-h-02.csv', 'w', newline ='\n'))
cluster_writer = csv.writer(open('cluster-small-graph-h-02.csv', 'w', newline='\n'))
graph_writer = csv.writer(open('graph-small-graph-h-02.csv', 'w', newline='\n'))

# data writing handlers for synthtic data. 
# synthetic_great_writer = csv.writer(open('synthetic-great-small-graph-01.csv', 'w', newline='\n'))
# synthetic_bad_writer = csv.writer(open('synthetic-bad-small-graph-01.csv', 'w', newline='\n'))
# synthetic_regular_writer = csv.writer(open('synthetic-regular-small-graph-01.csv', 'w', newline='\n'))
# target_long_writer = csv.writer(open('synthetic-target-small-graph-01.csv', 'w', newline='\n'))
# synthetic_regular_long_writer = csv.writer(open('synthetic-regular-small-graph-01.csv', 'w', newline='\n'))
# synthetic_great_long_writer = csv.writer(open('synthetic-great-long-03.csv', 'w', newline='\n'))
# synthetic_bad_long_writer = csv.writer(open('synthetic-bad-long-03.csv', 'w', newline='\n'))

# these are AMT user IDs of users in specific groups that was used for the analysis. 
# H users are the ones that had H key, S user had the space key, when only 4 keys were used. 
H_users = ["A27ZE20JZ3VDUP", "A30GA8KZBSU7E4", "A3S3WYVCVWW8IZ","AA8PZKO9XGCKO"]
S_users = ["A3GUM1J7OYRYPR", "A82VN0BRUIMNO", "A1LA6CIGBNDOH9", "A3UDUHUVFKD833"]

for row in data:
	if row['pretest_key_status'] and len(row['pretest_key_status']) > 0:
		adj_list, in_cluster, out_cluster = createGraph(row['pretest_graph'], row['pretest_graph_type'])
		time = timeStringToFloat(row['pretest_reactions'])
		keys = stringListToInt(row['pretest_keys'])
		key_status = stringListToInt(row['pretest_key_status'])
<<<<<<< HEAD
		if row['user_id'] == 'test333':
			target_long = randomWalk(adj_list, 1500)
			print("---------------------------------------------------------------------")
			print("user ", row['user_id'])
			print("graph ", adj_list)
			print("in cluster ", in_cluster)
			print("out cluster ", out_cluster)
			print("response time " , time, len(time))
			print("keys ", keys, len(keys))
			print("key status ", key_status, len(key_status))
			print('---------------------------------------------------------------------')			
			wrong = [(i, time[i] - time[i-1]) for i, x in enumerate(key_status) if x == 0 or i == 0]
			correct = [(i, time[i]) for i, x in enumerate(key_status) if x == 1 or i == 0]
			rt = [(correct[i][0], int((correct[i][1] - correct[i-1][1])*1000)) for i in range(1, len(correct))]
			print("delta t", rt, len(rt)) # a, b = zip(*wrong)
=======
		if len(key_status) >= 700 and ('rail_' in row['user_id'] or row['user_id'] in H_users):
			# target_long = randomWalk(adj_list, 1500)
			# print("---------------------------------------------------------------------")
			# print("user ", row['user_id'])
			# print("graph ", adj_list)
			# print("in cluster ", in_cluster)
			# print("out cluster ", out_cluster)
			# print("response time " , time, len(time))
			# print("keys ", keys, len(keys))
			# print("key status ", key_status, len(key_status))
			# print('---------------------------------------------------------------------')			
			wrong = [(i, time[i] - time[i-1]) for i, x in enumerate(key_status) if x == 0 and i != 0]
			correct = [(i, time[i]) for i, x in enumerate(key_status) if x == 1 or i == 0]
			rt = [(correct[i][0], (correct[i][1] - correct[i-1][1])*1000) for i in range(1, len(correct))]
			a, b = zip(*wrong)
>>>>>>> f38d10df68ed6ffcefcf1894844c046c79f3dd6d
			# plt.ylim(-0.5, 5)
			# plt.scatter(list(a), list(b), c='r', s=2)

			a, b = zip(*rt)
			mean = statistics.mean(b)
			std_dev = statistics.stdev(b)
			# you can choose to preprocess the data here, or on MATLAB. In this case proprocessing is done on MATLAB
			# rt_filtered = [rt[i] for i in range(0, len(rt)) if rt[i][0] > 0 and rt[i][1] > 100 and rt[i][1] < 3000 and abs(rt[i][1] - mean) < 3*std_dev]
			rt_filtered = [rt[i] for i in range(0, len(rt)) if rt[i][0] > 0]

			
			ind, rtf = zip(*rt_filtered)
			target = [keys[i] for i in ind]
			cluster = [1]

			# synthetic data for the 3 categories of people. 
			# synthetic_great = [0]
			# synthetic_bad = [0]
			# synthetic_regular = [0]

			print(ind, len(ind), '\n', rtf, len(rtf), '\n', target, len(target))
                        # 1 - out of cluster 0 is in cluster
			for i in range(1, len(target)):
				synthetic_bad.append(random.gauss(high_rt, rt_std))
				synthetic_great.append(random.gauss(low_rt, rt_std))
				if (target[i-1], target[i]) in in_cluster:
					cluster.append(0)
					# synthetic_regular.append(random.gauss(low_rt, rt_std))
				else:
					cluster.append(1)
					# synthetic_regular.append(random.gauss(high_rt, rt_std))

			# synthetic_great_long = [0]
			# synthetic_regular_long = [0]
			# synthetic_bad_long = [0]

			# for i in range(1, len(target_long)):
			# 	synthetic_bad_long.append(random.gauss(high_rt, rt_std))
			# 	synthetic_great_long.append(random.gauss(low_rt, rt_std))
			# 	if (target_long[i-1], target_long[i]) in in_cluster:
			# 		synthetic_regular_long.append(random.gauss(low_rt, rt_std))
			# 	else:
			# 		synthetic_regular_long.append(random.gauss(high_rt, rt_std))

			# print("great, ", statistics.mean(synthetic_great[1:]), statistics.stdev(synthetic_great[1:]))
			# print("bad, ", statistics.mean(synthetic_bad[1:]), statistics.stdev(synthetic_bad[1:]))
			# print("regular ", statistics.mean(synthetic_regular[1:]), statistics.stdev(synthetic_regular[1:]))

			trial_writer.writerow(ind)
			target_writer.writerow(target)
			rt_writer.writerow(rtf)
			cluster_writer.writerow(cluster)
			# synthetic_bad_writer.writerow(synthetic_bad)
			# synthetic_regular_writer.writerow(synthetic_regular)
			# synthetic_great_writer.writerow(synthetic_great)
			# synthetic_great_long_writer.writerow(synthetic_great_long)
			# synthetic_regular_long_writer.writerow(synthetic_regular_long)
			# synthetic_bad_long_writer.writerow(synthetic_bad_long)
			# target_long_writer.writerow(target_long)

			if row['pretest_graph_type'] == 'modular':
				graph_type_writer.writerow([10])
			else:
				graph_type_writer.writerow([20])
			for adj in adj_list:
				graph_writer.writerow(adj)
<<<<<<< HEAD
			#plt.scatter(list(ind), list(rtf), c='g', s=2)
			#plt.title(row['user_id']+" "+row['pretest_graph_type'])
			#plt.show()
=======

			# plt.scatter(list(ind), list(rtf), c='g', s=2)
			# plt.title(row['user_id']+" "+row['pretest_graph_type'])
			# plt.show()
>>>>>>> f38d10df68ed6ffcefcf1894844c046c79f3dd6d
