function [fileName,pathName,filterIndex, isSelected] = selectFile(title, extensions, isSave)
%%

%% Preprocessing

% Defaults
if exist('extensions', 'var') == false; extensions = {'*.csv'; '*.xlsx'; '*.xls'}; end
if exist('title', 'var') == false; title = 'Select File'; end
if exist('isSave', 'var') == false; isSave = false; end

%% Main

% Load file
if isSave==false
    [fileName,pathName,filterIndex] = uigetfile(extensions, title);
else
    [fileName,pathName,filterIndex] = uiputfile(extensions, title, 'Output');
end

% Analyze file selected
if fileName == 0; isSelected = false; else; isSelected = true; end

end