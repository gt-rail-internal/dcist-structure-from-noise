import pymysql.cursors
import matplotlib.pyplot as plt
import csv
import statistics
import random

conn = pymysql.connect(host = 'localhost', user='', password='', db='logger',charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
crsr = conn.cursor()
crsr.execute("select * from response;")
data = crsr.fetchall()
random.seed(0)

high_rt = 1200.0
low_rt = 800.0
rt_std = 20.0


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
		if xm == 'PM':
			time_int += 12*3600
		result.append(time_int)
	return result


def stringListToInt(string_list):
	return [int(item) for item in string_list.split(', ')]


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


def randomWalk(adj_list, length):
	walk = [random.randint(0, 14)]
	for i in range(1, length):
		walk.append(adj_list[walk[i-1]][random.randint(0, 3)])
	return walk


rt_writer = csv.writer(open('rt-full-01.csv', 'w', newline='\n'))
trial_writer = csv.writer(open('trial-full-01.csv', 'w', newline='\n'))
target_writer = csv.writer(open('target-full-01.csv', 'w', newline='\n'))
graph_type_writer = csv.writer(open('graph-type-full-01.csv', 'w', newline ='\n'))
cluster_writer = csv.writer(open('cluster-full-01.csv', 'w', newline='\n'))
graph_writer = csv.writer(open('graph-full-01.csv', 'w', newline='\n'))
synthetic_great_writer = csv.writer(open('synthetic-great-full-03.csv', 'w', newline='\n'))
synthetic_bad_writer = csv.writer(open('synthetic-bad-full-03.csv', 'w', newline='\n'))
synthetic_regular_writer = csv.writer(open('synthetic-regular-full-03.csv', 'w', newline='\n'))
target_long_writer = csv.writer(open('synthetic-target-long-01.csv', 'w', newline='\n'))
synthetic_regular_long_writer = csv.writer(open('synthetic-regular-long-03.csv', 'w', newline='\n'))
synthetic_great_long_writer = csv.writer(open('synthetic-great-long-03.csv', 'w', newline='\n'))
synthetic_bad_long_writer = csv.writer(open('synthetic-bad-long-02.csv', 'w', newline='\n'))


for row in data:
	if row['pretest_key_status'] and len(row['pretest_key_status']) > 0:
		adj_list, in_cluster, out_cluster = createGraph(row['pretest_graph'], row['pretest_graph_type'])
		time = timeStringToFloat(row['pretest_reactions'])
		keys = stringListToInt(row['pretest_keys'])
		key_status = stringListToInt(row['pretest_key_status'])
		if len(key_status) >= 630:
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
			wrong = [(i, time[i] - time[i-1]) for i, x in enumerate(key_status) if x == 0 and i != 0]
			correct = [(i, time[i]) for i, x in enumerate(key_status) if x == 1 and i != 0]
			rt = [(correct[i][0], int((correct[i][1] - correct[i-1][1])*1000)) for i in range(1, len(correct))]
			a, b = zip(*wrong)
			# plt.ylim(-0.5, 5)
			# plt.scatter(list(a), list(b), c='r', s=2)

			a, b = zip(*rt)
			mean = statistics.mean(b)
			std_dev = statistics.stdev(b)
			rt_filtered = [rt[i] for i in range(0, len(rt)) if rt[i][0] > 0 and rt[i][1] > 100 and rt[i][1] < 3000 and abs(rt[i][1] - mean) < 3*std_dev]

			ind, rtf = zip(*rt_filtered)
			target = [keys[i] for i in ind]
			cluster = [1]

			synthetic_great = [0]
			synthetic_bad = [0]
			synthetic_regular = [0]

			# 1 - out of cluster 0 is in cluster
			for i in range(1, len(target)):
				synthetic_bad.append(random.gauss(high_rt, rt_std))
				synthetic_great.append(random.gauss(low_rt, rt_std))
				if (target[i-1], target[i]) in in_cluster:
					cluster.append(0)
					synthetic_regular.append(random.gauss(low_rt, rt_std))
				else:
					cluster.append(1)
					synthetic_regular.append(random.gauss(high_rt, rt_std))

			synthetic_great_long = [0]
			synthetic_regular_long = [0]
			synthetic_bad_long = [0]

			for i in range(1, len(target_long)):
				synthetic_bad_long.append(random.gauss(high_rt, rt_std))
				synthetic_great_long.append(random.gauss(low_rt, rt_std))
				if (target_long[i-1], target_long[i]) in in_cluster:
					synthetic_regular_long.append(random.gauss(low_rt, rt_std))
				else:
					synthetic_regular_long.append(random.gauss(high_rt, rt_std))

			print("great, ", statistics.mean(synthetic_great[1:]), statistics.stdev(synthetic_great[1:]))
			print("bad, ", statistics.mean(synthetic_bad[1:]), statistics.stdev(synthetic_bad[1:]))
			print("regular ", statistics.mean(synthetic_regular[1:]), statistics.stdev(synthetic_regular[1:]))

			trial_writer.writerow(ind)
			target_writer.writerow(target)
			rt_writer.writerow(rtf)
			cluster_writer.writerow(cluster)
			synthetic_bad_writer.writerow(synthetic_bad)
			synthetic_regular_writer.writerow(synthetic_regular)
			synthetic_great_writer.writerow(synthetic_great)
			synthetic_great_long_writer.writerow(synthetic_great_long)
			synthetic_regular_long_writer.writerow(synthetic_regular_long)
			synthetic_bad_long_writer.writerow(synthetic_bad_long)
			target_long_writer.writerow(target_long)
			if row['pretest_graph_type'] == 'modular':
				graph_type_writer.writerow([10])
			else:
				graph_type_writer.writerow([20])
			for adj in adj_list:
				graph_writer.writerow(adj)
			plt.scatter(list(ind), list(rtf), c='g', s=2)
			plt.title(row['user_id']+" "+row['pretest_graph_type'])
			plt.show()