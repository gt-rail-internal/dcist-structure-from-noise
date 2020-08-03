import csv
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator


USERNAME = ["AE1DWQLNREKRF", "A31TQK11E2EBJZ", "A3GK90X2QOFR53", "A1KGCOR8OXYR72", "A248LF7KKHXZ14",  "A1F1BIPJR11LSR"] #"A3GXC3VG37CQ3G",, "A8C3WNWRBWUXO"]
readTemp = []
for UN in USERNAME:
    with open('out.csv', 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter='"', quotechar='|')
        for row in reader:
            trow = []
            if row[1].replace('"', "") == UN:
                readTemp.append(row[11].split(","))
print(readTemp)
                #print(len(trow))
##ReadTemp now contains a list with each person as a list object with first the ID and then each result

correctResultsone = [10, 10, 10, 8, 8, 8, 2, 0, 0, 0, 6, 6, 6, 6, 6, 6, 26, 26, 26, 24, 24, 24, 6, 6, 6, 6, 6, 6]         #these are the right ones to choose
correctResultstwo = [10, 10, 10, 9, 9, 9, 2,20,20,20, 7, 7, 7, 6, 6, 6, 26, 26, 26, 24, 24, 24, 6, 6, 6, 7, 7, 7]         #sometimes there are alternates that work just as well
distTemp = []

for j in range(0, len(readTemp)):
    distTemp.append([])
    #print(readTemp[0])
    for i in range(0, len(correctResultsone)):
        #print(readTemp[j][i])
        if int(readTemp[j][i]) == -1:
            distTemp[j].append(0)
        else:
            distTemp[j].append(min(abs(int(readTemp[j][i]) - correctResultsone[i-1]),abs(int(readTemp[j][i]) - correctResultstwo[i-1])))
fig, axs = plt.subplots(3,3)
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
    axs[0, 2].plot(distTemp[i][7:10])
for i in range(0,len(readTemp)):
    axs[1, 0].plot(distTemp[i][10:13])
for i in range(0,len(readTemp)):
    axs[1, 1].plot(distTemp[i][13:16])
for i in range(0,len(readTemp)):
    axs[1, 2].plot(distTemp[i][16:19])
for i in range(0,len(readTemp)):
    axs[2, 0].plot(distTemp[i][19:22])
for i in range(0,len(readTemp)):
    axs[2, 1].plot(distTemp[i][22:25])
for i in range(0,len(readTemp)):
    axs[2, 2].plot(distTemp[i][25:28])

plt.show()

minDists = []
for j in range(0, len(readTemp)):
    minDists.append([])
    minDists[j].append(min(distTemp[j][0],distTemp[j][1],distTemp[j][2]))
    minDists[j].append(min(distTemp[j][3],distTemp[j][4],distTemp[j][5]))
    minDists[j].append(min(distTemp[j][7],distTemp[j][8],distTemp[j][9]))
    minDists[j].append(min(distTemp[j][10],distTemp[j][11],distTemp[j][12]))
    minDists[j].append(min(distTemp[j][13],distTemp[j][14],distTemp[j][15]))
    minDists[j].append(min(distTemp[j][16],distTemp[j][17],distTemp[j][18]))
    minDists[j].append(min(distTemp[j][19],distTemp[j][20],distTemp[j][21]))
    minDists[j].append(min(distTemp[j][22],distTemp[j][23],distTemp[j][24]))
    minDists[j].append(min(distTemp[j][25],distTemp[j][26],distTemp[j][27]))
#print(minDists)




fig, ax = plt.subplots()
plt.title('Minimum Performance Error of Each Turker (Lower is better)')
minDistsPerQuestion = []
for i in range(len(minDists[0])):
    minDistsPerQuestion.append([])
    for j in range(len(minDists)):
        minDistsPerQuestion[i].append(minDists[j][i])
print(minDistsPerQuestion)
for i in range(len(minDistsPerQuestion)):
    labelsT = []
    bot = []
    for j in range(1,len(USERNAME) + 1):
        labelsT.append("Turk " + str(j))
        bot.append(0)
    for j in range(0,i):
        bot = [sum(x) for x in zip(bot, minDistsPerQuestion[j])]
    #print(bot)
    ax.bar(labelsT,minDistsPerQuestion[i], label= "Question: " + str(i + 1), bottom=bot)
ax.legend()
plt.show()
