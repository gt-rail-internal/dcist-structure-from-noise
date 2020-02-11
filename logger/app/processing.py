from app.models import Response

def responseDictFromString(response):
	dataDict = {}
	print("$", "a", "$", "b", "$")
	for entry in response.split('::'):
		if len(entry) > 1:
			values = entry.split(', ')
			if values[0] == 'time':
				dataDict['reactions'] = ", ".join(values[1:])
			elif values[0] == 'user':
				dataDict['user_id'] = values[1]
			elif values[0] == 'keys':
				dataDict['keys'] = ", ".join(values[1:])
			elif values[0] == 'graph':
				dataDict['graph'] = values[1]
			elif values[0] == 'gtype':
				dataDict['graph_type'] = values[1]
	return dataDict

def responseFromDict(data_dict):
	r = Response(user_id=data_dict['user_id'], pretest_graph_type=data_dict['graph_type'], 
		pretest_graph=data_dict['graph'], pretest_keys=data_dict['keys'], pretest_reactions=data_dict['reactions'])
	print(r)
	print("that was r")
	return r