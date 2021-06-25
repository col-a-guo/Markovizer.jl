#unsuccessful python iteration

import autograd.numpy as np  # Thinly-wrapped numpy
from autograd import grad 

param_array = []
data_array = [[1, 2]
[2, 3], [3,4]]

model = []

labels = []

layers = [2, 1]

data_size = 2
data_num = 2

weights_size = 2
lr = 0.1
x_n_grads

x_ns = np.zeros(weights_size)
weights_ns = np.zeros(weights_size)

for i in range(weights_size):
    x_ns.append(0)

'''
def generate_dense(layer_input):
    def dense(layer_input):
        y = 0
        for i, node in enumerate(layer_input[layer1]):
            y = y+weights_ns[i]*node
        return y
    return dense
'''



for i in range(size(weights_ns)-1):
    layer1 = i
    layer2 = i+1
    generate_dense(layer1)


'''
with auto_diff.AutoDiff(x) as x:
    f_eval = generate_dense(x, u)
    y, Jf = auto_diff.get_value_and_jacobian(f_eval)
'''
x_ns = []

#Assume linear only layers

#loop of process
for i in range(epochs):
    x_ns_old = x_ns
    x_ns_grads
    for i in range data_size:
        x_ns[i] = x_ns_old += x_ns grads
