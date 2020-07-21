import csv
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np

USERNAME = ["A2W3SU4RZN9AZD", "AUFUUD4WG9CVO", "A270HX8LH9LJ8W", "A20FYCXV508HM9", "AG9LMLEPXP2YC"]# ["A3H7GCFS21E253", "AN15QS1604XRS","A141CB4BKDYKDF","A32W2O02CUQ2TO"]
np.set_printoptions(suppress=True)
readTemp = []
data = [780.44, 466.01, 709.72, 900.62, 570.79]
datay = [2500, 2500, 2500, 1103, 2500]
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
            if (len(data[0])) == 6 and data[0][1] == "1": #this is a state one
                stateTutArr = np.append(stateTutArr, data, axis = 0)
            elif (len(data[0])) == 6 and data[0][1] == "2":
                stateArr = np.append(stateArr, data, axis = 0)
            elif (len(data[0])) == 5 and data[0][1] == "1":
                actionTutArr = np.append(actionTutArr, data, axis = 0)
            elif (len(data[0])) == 5 and data[0][1] == "2":
                actionArr = np.append(actionArr, data, axis = 0)
    return stateTutArr, actionTutArr, stateArr, actionArr

def autolabel(rects, ax):
    """Attach a text label above each bar in *rects*, displaying its height."""
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(int(height)),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')

def graphone(data):
    fig, ax = plt.subplots()
    ax.set_xlabel('Participant Number')
    ax.set_ylabel('Seconds to Achieve 2500 points (Max 900 sec)')
    ax.set_title('Final Scores of Participants (Lower is better)')
    rects1 = ax.bar([1,2,3,4,5],data, 0.5)
    autolabel(rects1, ax)
    plt.show()

def graphtwo(scoresYList, pointscoresList, data, actionList, pointactionList):
    fig, ax = plt.subplots()
    #print(scoresList)
    for i in range(0,len(USERNAME)):
        #if scoresYList[i][-1] < 2500:
            #timesXList[i] = np.append(timesXList[i], data[i])
            #scoresYList[i] = np.append(scoresYList[i], datay[i])
        x = np.array(list(range(1,len(timesXList[i]) +1)), dtype=int) * 100
        #print(pointscoresList[i])
        #print(scoresList[i])
        #print()
        plt.plot(np.sort(np.concatenate((timesXList[i], actionList[i]))), np.sort(np.concatenate((scoresYList[i], pointactionList[i]))), label='Participant ' + str(i + 1))
        #plt.plot(np.sort(np.concatenate((timesXList[i], actionList[i]))), np.sort(np.concatenate((x, pointactionList[i]))), label='Participant ' + str(i + 1))
        ax.scatter(np.sort(actionList[i]), np.sort(pointactionList[i]), 7, label="Action Click " + str(i + 1))
    ax.set_xlim([0, 660])
    ax.set_ylim([0, 750])
    plt.legend(loc=2)

    ax.set_title('Score over Time (Higher is better)')
    ax.set_xlabel('Time (seconds) to reach y axis score checkpoint')
    ax.set_ylabel('Points ')
    plt.show()

def graphthree(actionList, pointactionList):
    fig, ax = plt.subplots()
    for i in range(0, len(USERNAME)):
        #print(actionList[i])
        ax.scatter(np.sort(actionList[i]), [i] * actionList[i].shape[0], 8, label="Participant " + str(i + 1))
    #plt.legend()
    ax.set_title("Action distribution: Each point is an action button click")
    ax.set_ylabel('Participant Number (Each row is a participant)')
    ax.set_xlabel('Time since beginning of game (sec)')
    ax.set_xlim([0, 900])
    plt.show()

if __name__ == "__main__":
    scoresYList = []
    timesXList = []
    actionList = []
    pointactionList = []
    for i in range(0, len(USERNAME)):
        with open('out.txt', 'r') as csvfile:
            reader = csv.reader(csvfile, delimiter=',', quotechar='|')
            stateOneArr, actionOneArr, stateArr, actionArr = parsePerson(reader, USERNAME[i])
            print(stateArr)
            scores = stateArr[:,2]
            times = stateArr[:,3]
            scores = np.array(scores, dtype=np.single)
            times = np.array(times, dtype=np.single)
            scores = scores[np.argsort(scores)]
            times = times[np.argsort(times)]
            timesXList.append(times)
            scoresYList.append(scores)
            actionList.append(actionArr[:,3].astype(float))
            pointactionList.append(actionArr[:,2].astype(float))
            #print(actionArr)
            print()
            print()
    graphone(data)
    graphtwo(scoresYList, timesXList, data, actionList, pointactionList)
    graphthree(actionList, pointactionList)
