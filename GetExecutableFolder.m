% Returns the folder where the compiled executable actually resides.
% If running in the development environment, it returns the Current Folder,
% Which may not be the same as where the code is saved because MATLAB doesn't always
% ask the user if they want to Change Folder if the user is running the m-file with the current folder
% being different than the m-file's folder.
function executableFolder = GetExecutableFolder() 
	try
		if isdeployed 
			% User is running an executable in standalone mode. 
			[status, result] = system('set PATH');
			executableFolder = char(regexpi(result, 'Path=(.*?);', 'tokens', 'once'));
% 			fprintf(1, '\nIn function GetExecutableFolder(), currentWorkingDirectory = %s\n', executableFolder);
		else
			% User is running an m-file from the MATLAB integrated development environment (regular MATLAB).
			executableFolder = pwd; 
		end 
	catch ME
		errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
			ME.stack(1).name, ME.stack(1).line, ME.message);
		uiwait(warndlg(errorMessage));
	end
	return;