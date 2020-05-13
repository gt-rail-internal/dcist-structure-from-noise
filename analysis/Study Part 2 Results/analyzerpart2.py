import csv
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator

readTemp = []
with open('Trial2results.csv', 'r') as csvfile:
    reader = csv.reader(csvfile, delimiter=',', quotechar='|')
    for row in reader:
        trow = []
        trow.append(row[0])
        for i in range(8,21):
            trow.append(row[i].replace('"', ''))
        readTemp.append(trow)
        #print(trow)
##ReadTemp now contains a list with each person as a list object with first the ID and then each result

correctResultsone = [10, 10, 10, 8, 8, 8, 2, 0, 0, 0, 6, 6, 6]         #these are the right ones to choose
correctResultstwo = [10, 10, 10, 9, 9, 9, 2,20,20,20, 7, 7, 7]         #sometimes there are alternates that work just as well
distTemp = []
for j in range(0, len(readTemp)):
    distTemp.append([])
    for i in range(1, len(correctResultsone ) + 1):
        distTemp[j].append(min(abs(int(readTemp[j][i]) - correctResultsone[i-1]),abs(int(readTemp[j][i]) - correctResultstwo[i-1])))
#print(distTemp)
fig, axs = plt.subplots(2,2)
i = 1
for ax in axs.flat:
    ax.set(title = "Error over time for Question " + str(i), xlabel='Query Number', ylabel='Error Value')
    ax.xaxis.set_major_locator(MaxNLocator(integer=True))
    i = i + 1
for i in range(0,len(readTemp)):
    axs[0, 0].plot(distTemp[i][0:3])
for i in range(0,len(readTemp)):
    axs[0, 1].plot(distTemp[i][3:6])
for i in range(0,len(readTemp)):
    axs[1, 0].plot(distTemp[i][7:10])
for i in range(0,len(readTemp)):
    #print(distTemp)
    axs[1, 1].plot(distTemp[i][10:13])
plt.show()

minDists = []
for j in range(0, len(readTemp)):
    minDists.append([])
    minDists[j].append(min(distTemp[j][0],distTemp[j][1],distTemp[j][2]))
    minDists[j].append(min(distTemp[j][3],distTemp[j][4],distTemp[j][5]))
    minDists[j].append(min(distTemp[j][7],distTemp[j][8],distTemp[j][9]))
    minDists[j].append(min(distTemp[j][10],distTemp[j][11],distTemp[j][12]))
print(minDists)




fig, ax = plt.subplots()
plt.title('Minimum Performance Error of Each Turker (Lower is better)')
minDistsPerQuestion = []
for i in range(len(minDists[0])):
    minDistsPerQuestion.append([])
    for j in range(len(minDists)):
        minDistsPerQuestion[i].append(minDists[j][i])
print(minDistsPerQuestion)
for i in range(len(minDistsPerQuestion)):
    bot  = [0,0,0,0,0]
    for j in range(0,i):
        bot = [sum(x) for x in zip(bot, minDistsPerQuestion[j])]
    print(bot)
    ax.bar(["Turk 1","Turk 2","Turk 3","Turk 4","Turk 5"],minDistsPerQuestion[i], label= "Question: " + str(i + 1), bottom=bot)
ax.legend()
plt.show()
