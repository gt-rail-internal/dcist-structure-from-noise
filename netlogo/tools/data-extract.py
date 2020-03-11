import pymysql.cursors
import matplotlib.pyplot as plt

conn = pymysql.connect(host = 'localhost', user='root', password='R0b0tsAr3C00l!', db='logger',charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)
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

for row in data:
	if row['pretest_key_status'] and len(row['pretest_key_status']) > 0:
		time = timeStringToFloat(row['pretest_reactions'])
		keys = stringListToInt(row['pretest_keys'])
		key_status = stringListToInt(row['pretest_key_status'])
		print(time, keys, key_status)
		if len(key_status) >= 630:
			wrong = [(i, time[i]) for i, x in enumerate(key_status) if x == 0]
			correct = [(i, time[i]) for i, x in enumerate(key_status) if x == 1]
			a, b = zip(*wrong)
			plt.scatter(a, b, 'r')
			a, b = zip(*correct)
			plt.scatter(a, b, 'g')
			plt.show()