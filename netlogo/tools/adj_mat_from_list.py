import numpy as np

num_nodes = 15

# a = [[12, 4, 6, 10],[8,9,13,2],[3,9,13,1],[7,11,14,2],[12,0,6,10],[12,7,11,14],[12,0,4,10],[3,11,14,5],[9,13,1,10],[8,13,1,2],[8,0,4,6],[3,7,14,5],[0,4,6,5],[8,9,1,2],[3,7,11,5]]

input_str = "[[10 4 5 3] [2 8 3 6] [8 1 14 11] [14 7 0 1] [10 0 9 7] [12 9 6 0] [11 13 1 5] [14 3 4 8] [2 1 7 13] [12 5 13 4] [4 0 12 14] [13 6 2 12] [9 5 11 10] [11 6 8 9] [7 3 10 2]]"
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
