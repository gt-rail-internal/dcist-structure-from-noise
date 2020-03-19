import pymysql.cursors
import matplotlib.pyplot as plt
import csv
import statistics

conn = pymysql.connect(host = 'localhost', user='akshay', password='', db='logger',charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
crsr = conn.cursor()
crsr.execute("select * from response;")
data = crsr.fetchall()

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


rt_writer = csv.writer(open('rt-01.csv', 'w', newline='\n'))
trial_writer = csv.writer(open('trial-01.csv', 'w', newline='\n'))
target_writer = csv.writer(open('target-01.csv', 'w', newline='\n'))
graph_type_writer = csv.writer(open('graph-type-01.csv', 'w', newline ='\n'))


for row in data:
	if row['pretest_key_status'] and len(row['pretest_key_status']) > 0:
		time = timeStringToFloat(row['pretest_reactions'])
		keys = stringListToInt(row['pretest_keys'])
		key_status = stringListToInt(row['pretest_key_status'])
		print(time)
		print(keys)
		print(key_status)
		if len(key_status) >= 630:
			wrong = [(i, time[i] - time[i-1]) for i, x in enumerate(key_status) if x == 0 and i != 0]
			correct = [(i, time[i]) for i, x in enumerate(key_status) if x == 1 and i != 0]
			rt = [(correct[i][0], int((correct[i][1] - correct[i-1][1])*1000)) for i in range(1, len(correct))]
			a, b = zip(*wrong)
			plt.ylim(-0.5, 3)
			plt.scatter(list(a), list(b), c='r', s=2)

			a, b = zip(*rt)
			mean = statistics.mean(b)
			std_dev = statistics.stdev(b)
			rt_filtered = [rt[i] for i in range(0, len(rt)) if rt[i][0] > 200 and rt[i][1] > 0.1 and rt[i][1] < 3000 and abs(rt[i][1] - mean) < 3*std_dev]

			ind, rtf = zip(*rt_filtered)
			target = [keys[i] for i in ind]
			trial_writer.writerow(ind)
			target_writer.writerow(target)
			rt_writer.writerow(rtf)

			if row['pretest_graph_type'] == 'modular':
				graph_type_writer.writerow([10])
			else:
				graph_type_writer.writerow([20])

			plt.scatter(list(ind), list(rtf), c='g', s=2)
			plt.title(row['user_id']+" "+row['pretest_graph_type'])
			plt.show()



# rt_writer.close()
# trial_writer.close()
# target_writer.close()