

using Symbolics

#TODO report i.e. skeleton of paper


#=
macro wrap_var(var_args...)
    v = Symbol(var_args...)
    @variables a 2
    #println(b2)
end
=#
function main()

    param_array = []
    x = [[1, 2]]
    #, [5,7], [6,2], [3, 7], [25, 1], [34, 6], [3, 9], 6, 4, 5, 13, 20, 6

    model = []

    labels = [1.5]

    layers = [2, 4, 1]
    
    data_size = 2
    data_num = 2

    weights_size = 2
    lr = 0.0001



    @variables a[1:2, 1:4], b[1:4, 1:1]


    θ_a = [a[1,1] a[1,2] a[1,3] a[1,4];
    a[2,1] a[2,2] a[2,3] a[2,4]]
    
    θ_b = [b[1,1];
    b[2,1];
    b[3,1];
    b[4,1]]
    for epoch in 1:1
        for (i, datum) in enumerate(x)
            layer_1_output = [θ_a[1,1]*datum[1] + θ_a[2,1]*datum[2], θ_a[1,2]*datum[1] + θ_a[2,2]*datum[2], θ_a[1,3]*datum[1] + θ_a[2,3]*datum[2], θ_a[1,4]*datum[1] + θ_a[2,4]*datum[2]]
            prediction = θ_b[1,1]*layer_1_output[1] + θ_b[2,1]*layer_1_output[2] + θ_b[3,1]*layer_1_output[3] + θ_b[4,1]*layer_1_output[4]

            adjust_a = Symbolics.jacobian([(prediction - labels[i])^2], [a[1,1], a[1,2], a[1,3], a[1,4], a[2,1], a[2,2], a[2,3], a[2,4]])
            
            adjust_a = reshape(adjust_a, (2,4))

            θ_a -= lr*adjust_a

            adjust_b = Symbolics.jacobian([(prediction - labels[i])^2], [b[1,1],
            b[2,1],
            b[3,1],
            b[4,1]])
            
            adjust_b = reshape(adjust_b, (4,1))

            θ_b -= lr*adjust_b

            if epoch%10 == 0
                print((prediction - labels[i])^2)
            end
        end
    end

    datum = x[1]

    layer_1_output = [a[1,1]*datum[1] + a[2,1]*datum[2], a[1,2]*datum[1] + a[2,2]*datum[2], a[1,3]*datum[1] + a[2,3]*datum[2], a[1,4]*datum[1] + a[2,4]*datum[2]]
    
    prediction = b[1,1]*layer_1_output[1] + b[2,1]*layer_1_output[2] + b[3,1]*layer_1_output[3] + b[4,1]*layer_1_output[4]
    
    return(substitute.(
        (prediction - labels[1])^2, 
        (Dict(
            a[1,1] => 1, 
            a[2,1]  => 1, 
            a[1,2] => 1, 
            a[2,2] => 1, 
            a[1,3] => 1, 
            a[2,3] => 1, 
            a[1,4] => 1, 
            a[2,4] => 1, 
            b[1,1] => 1, 
            b[2,1] => 1, 
            b[3,1] => 1, 
            b[4,1] => 1),)))

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