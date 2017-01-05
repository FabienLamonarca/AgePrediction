function reg = regress(T, betas)
%REGRESS Summary of this function goes here
%   Detailed explanation goes here
    A = ones(size(T,1), 1);
    reg = [A T] * betas;
end

