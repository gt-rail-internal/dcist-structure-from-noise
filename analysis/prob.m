function [p] = prob(t, beta)
    p = exp(-beta*t)*(1 - exp(-beta));
end