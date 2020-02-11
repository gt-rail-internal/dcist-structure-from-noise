from flask import request
from app import app
from app import processing
from app import db

@app.route('/')
@app.route('/index')
def index():
	return "Hello, world!"

@app.route('/pretest-data', methods=['POST'])
def logData():
	reponseDict = processing.responseDictFromString(request.data.decode('ASCII'))
	print(reponseDict)
	response = processing.responseFromDict(reponseDict)
	db.session.add(response)
	db.session.commit()
	return reponseDict