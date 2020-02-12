from flask import request
from app import app
from app import processing
from app import db

@app.route('/')
@app.route('/index')
def index():
    app.logger.debug("Index function accessed from app")    
    return "Hello, world!"

@app.route('/pretest-data', methods=['POST'])
def logData():
    app.logger.debug("logging function accessed from app")
    app.logger.debug(request.data.decode('ASCII'))
    reponseDict = processing.responseDictFromString(request.data.decode('ASCII'))
    print(reponseDict)
    response = processing.responseFromDict(reponseDict)
    db.session.add(response)
    db.session.commit()
    app.logger.debug("exiting function")
    return reponseDict
