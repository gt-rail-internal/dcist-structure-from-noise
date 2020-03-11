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
