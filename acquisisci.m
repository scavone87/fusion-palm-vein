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

num_acqusiszioni = iterazioni-1;
for i = istante:num_acqusiszioni + istante
    completamento = (i+1)/ num_acqusiszioni
    palmoIstanteN(i, nomeUtente)
    close all;
    clc;
end
