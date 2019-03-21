function tf = xconstraint(X)
    nMinerals = numel(X)/2;
    size(X)
    delta = .1;
    tf = sum(X{:,nMinerals:end},2) > (1-delta) & sum(X{:,nMinerals:end},2) < (1+delta);
end