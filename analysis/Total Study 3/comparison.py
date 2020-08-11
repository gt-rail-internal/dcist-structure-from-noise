'''
This aggregates from the two parts and then makes comparison graphs
'''
import part3.analyzerpart3
import part2.analyzerpart2

import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np


partOneBeta = [0.0233, 3, 0.01, 1, 1, 0.0233, 3, 0.006, 1, 0.025, 3, 0.005, 1, 1, 0.005]

if __name__ == "__main__":
    #part 2 stuff
    minDistsPerQuestion = part2.analyzerpart2.processData(True,'part2/out.csv')
    #print(np.array(minDistsPerQuestion))
    X= np.sum(minDistsPerQuestion, axis = 0)
    #print(X)
    ##part 3 stuff
    finalScoresTwo = np.empty([len(part3.analyzerpart3.USERNAME),3])
    for i in range(0, 3):
        scoresYList, timesXList, actionList, pointactionList = part3.analyzerpart3.mainconcat(i, 'part3/out.csv')
        for u in range(0, len(part3.analyzerpart3.USERNAME)):
            x = np.sort(np.concatenate((timesXList[u], actionList[u])))
            y = np.sort(np.concatenate((scoresYList[u], pointactionList[u])))
            print(x)
            print(y)
            if len(y) == 0:
                finalScoresTwo[u, i] = 0
            elif y[-1] > 495:
                finalScoresTwo[u, i] = y[-1] + (600 - x[-1])
            else:
                finalScoresTwo[u, i] = y[-1]
    #print(finalScoresTwo)
    Y = np.sum(finalScoresTwo[:,1:], axis = 1)
    #print(Y)
    fig, ax = plt.subplots()
    ax.scatter(X, Y)
    plt.title('2nd vs 3rd study Results')
    ax.set_xlabel('2nd Study Score (Lower is better)')
    ax.set_ylabel('3rd Study Score (Higher is better)')
    for i in range(0, len(X)):
        plt.annotate(str(i + 1),
            xy=(X[i], Y[i]), #show point
            xytext=(5, 2), #show annotate
            textcoords='offset points',
            ha='right',
            va='bottom')
    plt.show()


    fig, ax = plt.subplots()
    ax.scatter(partOneBeta, X)
    ax.set_xscale('log',basex=10)
    ax.set_xlim([0.001,10])
    plt.title('1st vs 2nd study Results')
    ax.set_xlabel('1st Study Score (Higher is better)')
    ax.set_ylabel('2nd Study Score (Lower is better)')
    for i in range(0, len(Y)):
        plt.annotate(str(i + 1),
            xy=(partOneBeta[i], X[i]), #show point
            xytext=(5, 2), #show annotate
            textcoords='offset points',
            ha='right',
            va='bottom')
    plt.show()

    fig, ax = plt.subplots()
    ax.scatter(partOneBeta, Y)
    ax.set_xscale('log',basex=10)
    ax.set_xlim([0.001,10])
    plt.title('1st vs 3rd study Results')
    ax.set_xlabel('1st Study Score (Higher is better)')
    ax.set_ylabel('3rd Study Score (Higher is better)')
    for i in range(0, len(Y)):
        plt.annotate(str(i + 1),
            xy=(partOneBeta[i], Y[i]), #show point
            xytext=(5, 2), #show annotate
            textcoords='offset points',
            ha='right',
            va='bottom')
    plt.show()
