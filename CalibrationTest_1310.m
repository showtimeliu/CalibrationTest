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

pdData = pdPara; 

%% calculate and apply mask 
% find the peak to determine the boundaries of the mask 
pdFFT = fft(pdData); 
figure, plot(10 * log10((abs(pdFFT) .^ 2))); xlim([1, nMidLineLength]); 

nLeft = 47; nRight = 71; 




