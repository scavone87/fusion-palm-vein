soglia = 0.3

passo = 1;
trovato = 0;
for i = 1 : length(T.Score)
if (T.Score(i) <= soglia && T.Genuino(i) == 1)
trovato(passo) = i;
passo = passo + 1;
end
end
trovato

for i = 1 : size(trovato, 2)
disp(T(trovato(i), :));
end