import numpy as np

num_nodes = 10

# change this string to the logged output graph from netlogo
# the code will output the adjacency matrix, which can be visualized using an online graph visualizer
input_str = "[[9 3 2 8] [5 4 6 8] [0 9 3 7] [0 9 2 7] [5 1 6 8] [1 4 6 7] [5 1 4 8] [5 9 3 2] [0 1 4 6] [0 3 2 7]]"
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
