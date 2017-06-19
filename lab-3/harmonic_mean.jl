function harmonic_mean(x...)
    sum = 0
    for i = 1:length(x)
        sum = 1/x[i] + sum
    end
    mean = length(x) / sum
    return mean
end