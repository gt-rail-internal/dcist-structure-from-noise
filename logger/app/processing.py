from app.models import Response
from app import app

def responseDictFromString(response):
    dataDict = {}
    for entry in response.split('::'):
        if len(entry) > 1:
            values = entry.split(', ')
            if values[0] == 'time':
                dataDict['pretest_reactions'] = ", ".join(values[1:])
            elif values[0] == 'user':
                            dataDict['user_id'] = values[1]
            elif values[0] == 'keys':
                dataDict['pretest_keys'] = ", ".join(values[1:])
            elif values[0] == 'graph':
                dataDict['pretest_graph'] = values[1]
            elif values[0] == 'gtype':
                dataDict['pretest_graph_type'] = values[1]
            elif values[0] == 'token':
                dataDict['pretest_token'] = values[1]
            elif values[0] == 'status':
                dataDict['pretest_key_status'] = ", ".join(values[1:])
    return dataDict

def responseFromDict(data_dict):
	r = Response(user_id=data_dict['user_id'], pretest_graph_type=data_dict['pretest_graph_type'], pretest_graph=data_dict['pretest_graph'], pretest_keys=data_dict['pretest_keys'], pretest_reactions=data_dict['pretest_reactions'], pretest_status = 2, pretest_key_status=data_dict['pretest_key_status'], pretest_token=data_dict['pretest_token'])
	app.logger.debug(r)
	app.logger.debug("response is above")
	return r

def newResponse(new_user_id):
	r = Response(user_id = new_user_id)
	app.logger.debug(r)
	app.logger.debug("new entry in table above")
	return r
