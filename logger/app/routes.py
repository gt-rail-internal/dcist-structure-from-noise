from flask import request
from app import app
from app import processing
from app import db
from app.models import Response

@app.route('/')
@app.route('/index')
def index():
    app.logger.debug("Index function accessed from app")
    return "Hello, world!"

@app.route('/pretest-data', methods=['POST'])
def logData():
    app.logger.debug("logging function accessed from app")
    app.logger.debug(request.data.decode('ASCII'))
    responseDict = processing.responseDictFromString(request.data.decode('ASCII'))
    print(responseDict)
    response = processing.responseFromDict(responseDict)
    db_entry = Response.query.filter_by(user_id=response.user_id)
    if db_entry is None:
        return {}, 205
    db_entry.update(responseDict)
    db.session.commit()
    app.logger.debug("exiting function")
    return responseDict, 200

@app.route('/pretest-initialize', methods=['POST'])
def initializePretest():
    app.logger.debug("initialize funtion")
    new_user_id = request.data.decode('ASCII')
    exists = db.session.query(Response.user_id).filter_by(user_id=new_user_id).scalar() is not None
    if not exists:
        response = processing.newResponse(new_user_id)
        db.session.add(response)
        db.session.commit()
        app.logger.debug("new response has been added")
        return {"name": new_user_id}, 200
    else:
        app.logger.debug("task init attempted twice")
        return {}, 210

@app.route('/posttest-data', methods=['POST'])
def logPostTestData():
    app.logger.debug("post test data received")
    data = request.data.decode('ASCII')
    list_data = data.split(",")
    user_id = list_data[0]
    list_data.remove(user_id)
    post_test_agents = ",".join(list_data)
    db_entry = Response.query.get(user_id)
    if db_entry is None:
        response = processing.newResponse(user_id)
        response.post_test_agents = post_test_agents
        db.session.add(response)
        app.logger.debug("new response added with posttest data")
    else:
        db_entry.post_test_agents = post_test_agents
        app.logger.debug("added posttest data to existing response")
    db.session.commit()
    app.logger.debug("exiting posttest route")
    return {}, 200

@app.route('/robotdomain-data', methods=['POST'])
def logRobotDomainData():
    app.logger.debug("post test data received")
    data = request.data.decode('ASCII')
    list_data = data.split(",")
    user_id = list_data[0]
    list_data.remove(user_id)
    robot_domain_data = ",".join(list_data)
    response = processing.newResponse(user_id)
    response.robot_domain_data = robot_domain_data
    db.session.add(response)
    app.logger.debug("new response added with robotdomain data")
    db.session.commit()
    app.logger.debug("exiting robotdomain route")
    return {}, 200
