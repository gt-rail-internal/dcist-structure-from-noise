import numpy as np

num_nodes = 15

# a = [[12, 4, 6, 10],[8,9,13,2],[3,9,13,1],[7,11,14,2],[12,0,6,10],[12,7,11,14],[12,0,4,10],[3,11,14,5],[9,13,1,10],[8,13,1,2],[8,0,4,6],[3,7,14,5],[0,4,6,5],[8,9,1,2],[3,7,11,5]]

input_str = "[[5 2 12 6] [3 10 14 7] [5 0 9 4] [1 10 13 9] [11 6 2 13] [2 0 7 11] [11 4 0 8] [9 12 1 5] [14 13 6 10] [7 12 3 2] [1 3 8 12] [4 6 5 14] [7 9 10 0] [14 8 4 3] [13 8 11 1]]"
input_str = input_str[2:-2]
adj_list_char = input_str.split("] [")
adj_list = [chars.split(" ") for chars in adj_list_char]
adj_list = [[int(number) for number in adj_list[i]] for i in range(0, len(adj_list))]


adj =np.zeros((num_nodes, num_nodes))
for i in range(0, len(adj_list)):
	for node in adj_list[i]:
		adj[i][node] = 1
		adj[node][i] = 1

for row in adj:
	for j in range(0, len(row)-1):
		print(str(int(row[j]))+', ', end='')	
	print(int(row[-1]))
