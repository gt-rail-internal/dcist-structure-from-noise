import numpy as np

a = [[12, 4, 6, 10],[8,9,13,2],[3,9,13,1],[7,11,14,2],[12,0,6,10],[12,7,11,14],[12,0,4,10],[3,11,14,5],[9,13,1,10],[8,13,1,2],[8,0,4,6],[3,7,14,5],[0,4,6,5],[8,9,1,2],[3,7,11,5]]

adj =np.zeros((15, 15))
print(adj.shape)
for i in range(0, len(a)):
	for node in a[i]:
		adj[i][node] = 1
		adj[node][i] = 1

for row in adj:
	for col in row:
		print(str(int(col))+', ', end='')
	print("")
