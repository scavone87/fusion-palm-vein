%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BioMetric Data Representation   %
% April 2010 - Alessandro Savoia  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INITIALIZATION

% project directory
directory_name = uigetdir(pwd,'Select the directory of your project (or click Cancel to keep the current directory):') ;
if (directory_name~=0)
    cd(directory_name);
end
    

% acquisition directory
[filename, pathname] = uigetfile({'*.bmp'},'Select Files','Multiselect','on');
filelist=sort(filename);

% probe type used
probelist{1}='ACULAB HF0';
probelist{2}='ACULAB HF2';
probelist{3}='ESAOTE LA424';
probelist{4}='ESAOTE LA523';
probelist{4}='ESAOTE LA532';
[probeselection,ok] = listdlg('PromptString','Select a probe:',...
                'SelectionMode','single',...
                'ListString',probelist);

% scan parameter input: 
% scan depth (mm) ; 
depthlist{1}='21 mm';
depthlist{2}='31 mm';
depthlist{3}='41 mm';
depthlist{4}='52 mm';
depthlist{5}='62 mm';
depthlist{6}='72 mm';
[depthselection,ok] = listdlg('PromptString','Select the scan depth:',...
                'SelectionMode','single',...
                'ListString',depthlist);
    
% mechanical step size (mm)
prompt = {'Enter mechanical scan step size (mm):'};
tit = 'Scan parameters';
lines = 1;
def = {'0.1'};
step = inputdlg(prompt,tit,lines,def);
stepsize=str2num(step{1});


