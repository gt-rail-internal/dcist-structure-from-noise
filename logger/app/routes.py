from flask import request
from app import app

@app.route('/')
@app.route('/index')
def index():
	return "Hello, world!"

@app.route('/pretest-data', methods=['POST'])
def logData():
	print("received, ", request.data)
	return request.data