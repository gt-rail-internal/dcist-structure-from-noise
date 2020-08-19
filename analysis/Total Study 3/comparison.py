'''
This aggregates from the two parts and then makes comparison graphs
'''
import part3.analyzerpart3
import part2.analyzerpart2

import matplotlib
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import numpy as np


'''
This script takes pieces from each experiment and does a longitudinal comparison between the stages to try to see correlation between them
'''

partOneBeta = [0.0233, 3, 0.2, 0.005, 1, 0, 0, 0.1, 0.1, 1, 2, 0.02, 0.06, 0.005, 0, 1, 0.05, 0.005, 10, 0.25, 0.0001, 0.2, 0.02, 0, 0, 0.05, 0.05, 3, 0.01, 0.005, 0.9, 10, 0.2, 3, 0.05]

def makePlots(partOneBeta, X, Y, mode):
    #print(finalScoresTwo)

    #print(Y)
    fig, ax = plt.subplots()
    print(len(X))
    print(len(Y))
    ax.scatter(X, Y)
    ax.set_ylabel('3rd Study Score (Higher is better)')
    if mode == 0:
        ax.set_xlabel('2nd Study Score (Lower is better)')
    else:
        ax.set_xlabel('2nd Study Score (Higher is better)')
    for i in range(0, len(X)):
        plt.annotate(str(i + 1),
            xy=(X[i], Y[i]), #show point
            xytext=(5, 2), #show annotate
            textcoords='offset points',
            ha='right',
            va='bottom')
    w, residuals, rank, s = np.linalg.lstsq(np.vstack([X, np.ones(len(X))]).T, Y)
    rsquared = (1 - (residuals / (len(Y) * np.var(Y))))
    xx = np.linspace(*plt.gca().get_xlim()).T
    plt.title('2nd vs 3rd study Results R^2 = ' + str(rsquared[0]))
    plt.plot(xx, w[0]*xx + w[1], '-r')
    plt.show()


    fig, ax = plt.subplots()
    ax.scatter(partOneBeta, X)
    if mode == 0:
        ax.set_xscale('log',basex=10)
        ax.set_xlim([0.001,10])
        ax.set_ylabel('2nd Study Score (Lower is better)')
    else:
        ax.set_ylabel('2nd Study Score (Higher is better)')
    plt.title('1st vs 2nd study Results')
    ax.set_xlabel('1st Study Score (Higher is better)')
    w, residuals, rank, s = np.linalg.lstsq(np.vstack([partOneBeta, np.ones(len(partOneBeta))]).T, X)
    rsquared = (1 - (residuals / (len(X) * np.var(X))))
    xx = np.linspace(*plt.gca().get_xlim()).T
    for i in range(0, len(Y)):
        plt.annotate(str(i + 1),
            xy=(partOneBeta[i], X[i]), #show point
            xytext=(5, 2), #show annotate
            textcoords='offset points',
            ha='right',
            va='bottom')
    plt.plot(xx, w[0]*xx + w[1], '-r')
    plt.title('1st vs 2nd study Results R^2 = ' + str(rsquared[0]))
    plt.show()

    fig, ax = plt.subplots()
    ax.scatter(partOneBeta, Y)
    if mode == 0:
        ax.set_xscale('log',basex=10)
        ax.set_xlim([0.001,10])
    ax.set_xlabel('1st Study Score (Higher is better)')
    ax.set_ylabel('3rd Study Score (Higher is better)')

    w, residuals, rank, s = np.linalg.lstsq(np.vstack([partOneBeta, np.ones(len(partOneBeta))]).T, Y)
    rsquared = (1 - (residuals / (len(Y) * np.var(Y))))
    xx = np.linspace(*plt.gca().get_xlim()).T
    for i in range(0, len(Y)):
        plt.annotate(str(i + 1),
            xy=(partOneBeta[i], Y[i]), #show point
            xytext=(5, 2), #show annotate
            textcoords='offset points',
            ha='right',
            va='bottom')
    plt.plot(xx, w[0]*xx + w[1], '-r')
    plt.title('1st vs 3rd study Results R^2 = ' + str(rsquared[0]))
    plt.show()

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
            #print(x)
            #print(y)
            if len(y) == 0:
                finalScoresTwo[u, i] = 0
            elif y[-1] > 495:
                finalScoresTwo[u, i] = y[-1] + ((600 - x[-1]) * 0.25)
            else:
                finalScoresTwo[u, i] = y[-1]
    Y = np.sum(finalScoresTwo[:,1:], axis = 1)
    #makePlots(partOneBeta,X,Y, 0)
    makePlots(partOneBeta,X,Y, 0)
    partOneBeta = np.log10(np.array(partOneBeta) + 0.001)
    partOneBeta = (partOneBeta - np.min(partOneBeta))
    partOneBeta = partOneBeta/np.max(partOneBeta)
    X = -X
    print(X)
    X = X - np.min(X)
    X = X / np.max(X)
    Y = Y  - np.min(Y)
    Y = Y / np.max(Y)
    makePlots(partOneBeta,X,Y, 1)
