disp('Scegli il tipo di strategia di analisi 2D');
disp('1 DiBello');
disp('2 Restaino');
disp('3 Dionisio');
disp('4 Gugliotta');
disp('5 Marino');
disp('6 Micucci');
x = input('Scelta: ');
x = num2str(x);
switch x
    case '1'
        sceltaRadioButton = 'DiBello';
    case '2'
        sceltaRadioButton = 'Restaino';
    case '3'
        sceltaRadioButton = 'Dionisio';
    case '4'
        sceltaRadioButton = 'Gugliotta';
    case '5'
        sceltaRadioButton = 'Marino';
    case '6'
        sceltaRadioButton = 'Micucci';
end
        

analisi2D(sceltaRadioButton);