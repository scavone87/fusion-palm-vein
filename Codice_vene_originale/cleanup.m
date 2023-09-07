function cleanup(basepath, filtered)
%CLEANUP Elimina i file generati dai passaggi intermedi
cd(basepath);
cd 'Dati elaborati'/'b-scan estratti'/;
dirData = dir();

dirList = dirData([dirData.isdir]);
dirList = dirList(~ismember({dirList.name}, {'.', '..'}));
for iDir = 1:numel(dirList)
    rmdir(dirList(iDir).name, 's');
end
cd ../'mask b-scan'/;
delete *.*;
cd ..
cd 'regioniconnesse b-scan'/;
delete *.*;
if filtered == 1
    cd ../'srad filtered b-scan'/;
    delete *.*;
end
if filtered == 2
    cd ../'gabor filtered b-scan'/;
    delete *.*;
end
end

