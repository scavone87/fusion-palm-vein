[nomefilemat, pathfilemat]=uiputfile([filenameuob(1:7) '.mat'],'SAVE FILE .mat');
save([pathfilemat nomefilemat],'M','X','Y','Z');