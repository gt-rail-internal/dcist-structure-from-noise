import csv
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np

USERNAME = ["1"]# ["A3H7GCFS21E253", "AN15QS1604XRS","A141CB4BKDYKDF","A32W2O02CUQ2TO"]
np.set_printoptions(suppress=True)
readTemp = []

stateTutArrAll = np.empty(shape=[len(USERNAME),0,6]) #each user, each data point, length of datapoint
actionTutArrAll = np.empty(shape=[len(USERNAME),0,5])
stateArrAll = np.empty(shape=[len(USERNAME),0,6])
actionArrAll = np.empty(shape=[len(USERNAME),0,5])



def parsePerson(reader,USERNAME):
    stateTutArr = np.empty(shape=[0,6]) #each user, each data point, length of datapoint
    actionTutArr = np.empty(shape=[0,5])

    stateArr = np.empty(shape=[0,6])
    actionArr = np.empty(shape=[0,5])
    for row in reader:
        if USERNAME in row[0]:
            data = [row[9].replace("\"","").split(";")]
            #print(data)
            if (len(data[0])) == 6 and data[0][1] == "true": #this is a state one
                stateTutArr = np.append(stateTutArr, data, axis = 0)
            elif (len(data[0])) == 6 and data[0][1] == "false":  #this is an action
                stateArr = np.append(stateArr, data, axis = 0)
            elif (len(data[0])) == 5 and data[0][1] == "true":
                actionTutArr = np.append(actionTutArr, data, axis = 0)
            elif (len(data[0])) == 5 and data[0][1] == "false":
                actionArr = np.append(actionArr, data, axis = 0)
    return stateTutArr, actionTutArr, stateArr, actionArr
for i in range(0, len(USERNAME)):
    with open('out.txt', 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',', quotechar='|')
        stateTutArr, actionTutArr, stateArr, actionArr = parsePerson(reader, USERNAME[i])
        scores = stateTutArr[:,2]
        times = stateTutArr[:,3]
        scores = np.array(scores, dtype=np.single)
        times = np.array(times, dtype=np.single)
        scores = scores[np.argsort(times)]
        times = times[np.argsort(times)]
        print(scores)
        print(times)
