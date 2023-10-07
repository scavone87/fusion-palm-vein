clear
clc

x = inputdlg('inserisci il numero di acquisizioni da effettuare:');
iterazioni = str2num(x{:});

prompt = {'Inserisci nome utente:'};
dlg_title = 'Parametri acquisizione';
num_lines = 1;
defaultans = {'Nome'};
utente = inputdlg(prompt,dlg_title,num_lines,defaultans);
x = inputdlg("inserisci l'istante d'inizio: ");
istante = str2num(x{:});
nomeUtente=char(utente(1));
p=pantografo_acqua;
p.tornaOrigine;
% p=p.settaVelocita(400); % per immagini 192x250x256 con PRF 8Khz
p = p.settaVelocita(390); % per immagini 192x300x320 con PRF 10Khz
%p = p.settaVelocita(200); % per immagini 192x400x256 con PRF 16Khz


num_acqusiszioni = iterazioni-1;
for i = istante:num_acqusiszioni + istante
    completamento = (i+1)/ num_acqusiszioni
    palmoIstanteN(i, nomeUtente);
    %palmoIstanteN_ritorno(10*i,nomeUtente);
    close all;
    clc;
end
