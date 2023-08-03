function [ ] = palmoIstanteN( n ,nomeUtente)

p=pantografo_acqua;
% p=p.settaVelocita(400); % per immagini 192x250x256 con PRF 8Khz
p = p.settaVelocita(390); % per immagini 192x300x320 con PRF 10Khz
configurazioniBMode;

%nomeUtente passato come parametro in ingresso alla funzione
mkdir('C:\PcLab\Acquisizioni\',nomeUtente);

saveFolder=strcat('C:\PcLab\Acquisizioni\',nomeUtente);
fileName='palmo';
Link = UOLink(appFolder, saveFolder ,fileName);
Link.Open(fileConfigurazione,probe);

%% 1
p.tornaOrigine;

Link.Freeze(1); %modalità acquisizione avviata - prf off

%il parametro n (passato ingresso chiamando la funzione) indica l'istante
%di tempo dell'acquisizione e in fase di salvataggio sarà presente nel nome
%del file salvato esempio: palmo_n_SliceIQ.uob
Link.AutoSave(1,n); %

%pausa di 1.5 secondi. In questo modo ci sarà
%assestamento delle vibrazioni dovute al ritorno in posizione di origine  
%prima di iniziare il salvataggio.
pause(1.5);

         
p = p.muovi([0.00, 54.00, 20]);

r = Link.Freeze(0);
r = Link.WaitSave(23500);
r = Link.Freeze(1);

end