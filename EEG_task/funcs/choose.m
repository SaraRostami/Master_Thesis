function choice = choose(identity, set, comb)

tmp = permn(set, comb);
ntmp = [randperm(length(set)); zeros(1, length(set))]';

switch identity
    case "identical"
        choice = tmp(tmp(:, comb - 1) == tmp(:, comb), :);
    case "nidentical"
        while length(unique(ntmp(:, 1))) ~= length(unique(ntmp(:, 2)))
            for i = 1:5
                ntmp(i, 2) = randsample(setdiff(ntmp(:, 1), ntmp(i, 1)), 1);
            end
        end
        choice = ntmp;
end

end