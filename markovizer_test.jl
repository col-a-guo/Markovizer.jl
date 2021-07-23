

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

    layers = [2, 2, 1]
    
    data_size = 2
    data_num = 2

    weights_size = 2
    lr = 0.0001



    @variables a[1:1, 1:2], b[1:2, 1:1], α[1:1, 1:2], β[1:2, 1:1]


    θ_a = [a[1,1] a[1,2]]
    
    θ_b = [b[1,1];
    b[2,1];]
    substituted = []
    for epoch in 1:1
        for (i, datum) in enumerate(x)
            layer_1_output = [θ_a[1,1]*datum[1], θ_a[1,2]*datum[1]]
            prediction = θ_b[1,1]*layer_1_output[1] + θ_b[2,1]*layer_1_output[2]

            adjust_a = Symbolics.jacobian([(prediction - labels[i])^2], [a[1,1], a[1,2]])
            
            adjust_a = reshape(adjust_a, (1,2))

            θ_a -= lr*adjust_a

            adjust_b = Symbolics.jacobian([(prediction - labels[i])^2], [b[1,1], b[2,1]])
            
            adjust_b = reshape(adjust_b, (2,1))

            θ_b -= lr*adjust_b

            println(θ_a)
            println()
            println(θ_b)
            θ = hcat(θ_b, reshape(θ_b, 1,2))
            substituted = simplify.(θ; expand = true) #consider increasing subtree
            #substituted = substitute.(simplified, (Dict(b[1,1]^2 => b[1,1]*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1])/6),))
            #Markovizing Part

        end
    end
    datum = x[1]

    #convert via stochastic substitution (1 = sum of all variables)
    
    #step 1: placeholder all but the degree 1 variables
    #TODO: Figure out how to do this more generally - also use julia shortform for loop (TODO: Ask Alok)
    original_vars_list = [a[1,1],a[1,2],a[2,1],a[2,2],b[1,1],b[2,1]]
    placeholder_vars_list = [α[1,1],α[1,2],α[2,1],α[2,2],β[1,1],β[2,1]]
    
    for (index_1, o_var_1) in enumerate(original_vars_list)
        for (index_2, o_var_2) in enumerate(original_vars_list)
            for (index_3, o_var_3) in enumerate(original_vars_list)
                full_degree_var = simplify.(o_var_1*o_var_2*o_var_3)
                println(full_degree_var)
                println()
                substitute_var = simplify.(placeholder_vars_list[index_1]*placeholder_vars_list[index_2]*placeholder_vars_list[index_3]; expand = true)
                
                println(substitute_var)
                println()
                substituted = substitute.(substituted, (Dict(full_degree_var => substitute_var),))
            end
        end
    end

    println(substituted)

    println()

    for (index_1, o_var_1) in enumerate(original_vars_list)
        for (index_2, o_var_2) in enumerate(placeholder_vars_list)
            full_degree_var = simplify.(o_var_1*o_var_2)
            substitute_var = simplify.(placeholder_vars_list[index_1]*placeholder_vars_list[index_2]; expand = true)
            substituted = substitute.(substituted, (Dict(full_degree_var => substitute_var),))
        end
    end

    println(substituted)
#=
    #step 2: start substituting sum of all variables = 1: i.e. multiplying by (a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1]). Add back in lowest-dim placeholders then repeat.
    for target_degree in 1:2
        for (i, o_var) in enumerate(original_vars_list)
            #multiply by 1 = (a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1])
            substituted = substitute.(substituted, (Dict(o_var^target_degree => o_var^target_degree*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1])),))
            substituted = simplify.(substituted; expand = true)
                
            println(substituted)
            println()
        end
        #Adding back in placeholders; TODO make this automatic: Recursion or for loop macro?
        println(substituted)
        if target_degree == 1
            for (index_1, o_var_1) in enumerate(original_vars_list)
                for (index_2, o_var_2) in enumerate(placeholder_vars_list)
                    full_degree_var = simplify.(o_var_1*o_var_2)
                    substitute_var = simplify.(placeholder_vars_list[index_1]*placeholder_vars_list[index_2]; expand = true)
                    substituted = substitute.(substituted, (Dict(substitute_var => full_degree_var),))
                end
            end
        end
        println(substituted)
        if target_degree == 2
            for (index_1, o_var_1) in enumerate(original_vars_list)
                for (index_2, o_var_2) in enumerate(placeholder_vars_list)
                    for (index_3, o_var_3) in enumerate(placeholder_vars_list)
                        full_degree_var = simplify.(o_var_1*o_var_2*o_var_3; expand = true)
                        substitute_var = simplify.(placeholder_vars_list[index_1]*placeholder_vars_list[index_2]*placeholder_vars_list[index_3]; expand = true)
                        substituted = substitute.(substituted, (Dict(substitute_var => full_degree_var),))
                    end
                end
            end
        end
        println(substituted)
    end
=#
    #step 3: turn into a markov chain with 36 states (2 players, 6 options for each; you should definitely use more than this but I want this done and actually readable)

    

    
    #=
    substituted = substitute.(simplified, (Dict(b[1,1]^2 => b[1,1]*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1]),)))

    substituted = substitute.(simplified, (Dict(b[1,1]^2 => b[1,1]*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1]),)))
    substituted = substitute.(simplified, (Dict(b[1,1]^2 => b[1,1]*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1])/6),))
    substituted = substitute.(simplified, (Dict(b[1,1]^2 => b[1,1]*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1])/6),))
    substituted = substitute.(simplified, (Dict(b[1,1]^2 => b[1,1]*(a[1,1]+a[1,2]+a[2,1]+a[2,2]+b[1,1]+b[2,1])/6),))
    =#

    #=
    return(substitute.(
        (prediction - labels[1])^2, 
        (Dict(
            a[1,1] => 1, 
            a[2,1]  => 1, 
            a[1,2] => 1, 
            a[2,2] => 1, 
            b[1,1] => 1, 
            b[2,1] => 1),)))=#

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
