function XTable = fitcdiscrCVF(XTable)
        nMinerals = numel(XTable)/2;
        XTable{1,1:nMinerals} = XTable{1,1:nMinerals}/sum(XTable{1,1:nMinerals});
end