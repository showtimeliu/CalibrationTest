clearvars; close all; 

strName = '20210119_TREAT_TestRun_NoPol_116058'; 
strDir = 'D:\TREAT\20210119\'; 
strFile = sprintf('%s%s.dat', strDir, strName); 
cellArrays = readHeader(strFile);
nNumberLines = cellArrays{2,3}; % 1024
nLineLength = cellArrays{2,4};  % 2096

disp(strFile);
[pdIMAQ, ~] = readDataFile(strFile, cellArrays); % the matrix pdIMAQ is a frame of multiple spectra: [LineLength, NumberOfLinesInAFrame]

% parallel / perpendicular camera
pdPara = pdIMAQ(:, :, 1); 
pdPerp = pdIMAQ(:, :, 2); 

keyboard; 