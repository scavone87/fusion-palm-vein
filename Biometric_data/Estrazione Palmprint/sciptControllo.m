% clear trovato;
% indice = 1;
% for i = 1 : 100
%     if(aaa.vett_norm_genuino(i) >= 0.0555-0.001 & aaa.vett_norm_genuino(i) <= 0.0555+0.001)
%         trovato(indice,1) = i;
%         indice = indice+1;
%     end
% end
% 
% passo=0;
% for i = 1 : 147
%     if(T.Score(i) >= 12-0.001 & T.Score(i) <= 12+0.001)
%         trovato2(passo + 1) = i;
%         passo=passo+1;
%     end
% end
passo = 1;
trovato = 0;
for i = 1 : 10731
if (T.Score(i) <= 0.21 && T.Genuino(i) == 1)
trovato(passo) = i;
passo = passo + 1;
end
end
trovato