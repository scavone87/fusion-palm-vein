% Inizio tempo di esecuzione dello script principale
startTime_mainScript = tic;

estrazioneImmaginiProfondita;
generaTemplate2D;
generaTemplate3D;
identificazioneMatching2D;
identificazioneMatching3D;

% Fine tempo di esecuzione dello script principale
endTime_mainScript = toc(startTime_mainScript);

fprintf('Tempo di esecuzione dello script principale: %.2f secondi\n', endTime_mainScript);