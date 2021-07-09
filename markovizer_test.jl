
using Symbolics
#=
macro wrap_var(var_args...)
    v = Symbol(var_args...)
    @variables a 2
    #println(b2)
end
=#
function main()

    param_array = []
    x = [[1, 2], [2, 3], [3,4], [5,7], [6,2], [3, 7], [25, 1], [34, 6], [3, 9]]
    
    model = []

    labels = [1.5, 2.5, 3.5, 6, 4, 5, 13, 20, 6]

    layers = [2, 1]
    
    data_size = 2
    data_num = 2

    weights_size = 2
    lr = 0.0001


    @variables a[2:1]


    θ = [a[1] a[2]]
    for epoch in 1:5000
        for (i, datum) in enumerate(x)
            prediction = θ[1]*datum[1] + θ[2]*datum[2]
            adjust = Symbolics.jacobian([(prediction - labels[i])^2], [a[1], a[2]])
            θ -= lr*adjust
        end
    end
    
    substitute.(θ, (Dict(a[1] => 37, a[2] => 25),))
    

    #TODO: make this generate variable variables e.g. x_3_1 through x_3_5 to represent weights of neuron 3 connected to a layer of 5
    #future TODO: 
    #=
    for i in 1:size(layers)[1]-1
        for neuron_1 in 1:layers[i]
            for neuron_2 in 1:layers[i+1]
                @variables wrap_var(alphabet_list[i])[layers[i]:layers[i+1]]
            end
        end
    end

    for i in 1:size(layers)[1]-1
        for neuron_1 in 1:layers[i]
            for neuron_2 in 1:layers[i+1]
                @variables wrap_var(alphabet_list[i])[layers[i]:layers[i+1]]
            end
        end
    end
    #assume variables are listed as x_n_m, in list_of_vars

    #TODO: make better by deriving in the loop?

    for i in 1:size(layers)[1]-1
        list_of_weight_lists = []
        for neuron_1 in 1:layers[i]
            weight_list = []
            for neuron_2 in 1:layers[i+1]
                push!(weight_list, alphabet_list[i][neuron_1, neuron_2])
            end
            push!(list_of_weight_lists, weight_list)
        end
    end

=#


end
main()
