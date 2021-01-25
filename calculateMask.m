function pdMask = calculateMask(nLineLength, nLeft, nRight, nRound)
%CALCULATEMASK Calculate the mask to apply on spectrum or depth profile

nMidLineLength = nLineLength / 2; 
%% mask parameter error check 
if nRound < 1
    nRound = 1; 
end
if nRound > nMidLineLength / 4
    nRound = nMidLineLength / 4; 
end

if nLeft < nRound
    nLeft = nRound;
end
if nLeft > nMidLineLength - nRound - 1
    nLeft = nMidLineLength - nRound - 1; 
end

if nRight < nRound + 1
    nRight = nRound + 1; 
end
if nRight > nMidLineLength - nRound
    nRight = nMidLineLength - nRound; 
end

if (nLeft >= nRight)
    nRight = nLeft + 1; 
end

%% create mask
pdMask = zeros(nMidLineLength, 1); 

for nPoint = 1 : nMidLineLength
   if (nPoint > nLeft - nRound && nPoint <= nLeft)
       pdMask(nPoint) = 0.5 * (cos(pi * (nPoint - nLeft) / nRound) + 1); 
   end
    
end

end

