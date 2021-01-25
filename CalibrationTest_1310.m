clearvars; close all; 

strName = '20210120_CoverslipOnRef_SampleBlk_117305'; 
strDir = 'D:\Raw data\1310 System\20210120 Calibration\Ref arm only with coverslip\'; 
strFile = sprintf('%s%s.dat', strDir, strName); 
cellArrays = readHeader(strFile);
nNumberLines = cellArrays{2,3}; 
nLineLength = cellArrays{2,4};  

nMidLineLength = nLineLength / 2; 

disp(strFile);
[pdIMAQ, ~] = readDataFile(strFile, cellArrays); % the matrix pdIMAQ is a frame of multiple spectra: [LineLength, NumberOfLinesInAFrame]

% parallel / perpendicular camera
pdPara = pdIMAQ(:, :, 1); 
pdPerp = pdIMAQ(:, :, 2); 

% pdData = pdPara; 
pdLine = pdPara(:, 100); 

%% calculate and apply mask 
% find the peak to determine the boundaries of the mask 
pdFFT = fft(pdLine); 

nLeft = 47; nRight = 71; 
nRound = 32; 
pdMask = calculateMask(nLineLength, nLeft, nRight, nRound); 
pdFFTMask = pdFFT .* pdMask; 

% inverse FFT of the peak 
pdPeakSpectrum = ifft(pdFFTMask); 

figure, 
plot(10 * log10((abs(pdFFT) .^ 2))); 
hold on; plot(10 * log10((abs(pdFFT).^2)) .* pdMask); hold off;

% figure, 
% plot(10 * log10((abs(pdFFT) .^ 2)));  
% hold on; plot(10 * log10((abs(pdFFT).^2)) .* pdMask1); hold off;

% figure, 
% p1 = plot(abs(pdPeakSpectrum)); hold on; 
% p2 = plot(abs(pdPeakSpectrum1)); hold off; 
% legend([p1, p2], {'two-peak mask', 'one-peak mask'}, 'Location', 'northeast'); 

%% calculate and unwrap phase
pdAngle = unwrap(angle(pdPeakSpectrum)); 
figure, plot(pdAngle); title('raw phase line'); 








%% temporary functions 
function pdMask = calculateMask2(nLineLength, nLeft, nRight, nRound)
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
pdMask = zeros(nLineLength, 1); 

for nPoint = 1 : nMidLineLength
   if (nPoint > nLeft - nRound && nPoint <= nLeft)
       pdMask(nPoint) = 0.5 * (cos(pi * (nPoint - nLeft) / nRound) + 1); 
       pdMask(nLineLength - nPoint + 1) = 0.5 * (cos(pi * (nPoint - nLeft) / nRound) + 1); 
   end
   if (nPoint > nLeft && nPoint <= nRight)
       pdMask(nPoint) = 1.0; 
       pdMask(nLineLength - nPoint + 1) = 1.0; 
   end
   if (nPoint > nRight && nPoint <= nRight + nRound)
       pdMask(nPoint) = 0.5 * (cos(pi * (nPoint - nRight) / nRound) + 1); 
       pdMask(nLineLength - nPoint + 1) = 0.5 * (cos(pi * (nPoint - nRight) / nRound) + 1); 
   end
end

end









