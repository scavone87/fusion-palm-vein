k=str2double(get(k_h,'String'));
[Z , M] = interp1k ( Z , M , (Z(1):str2double(get(axstep_h,'String')):Z(length(Z))+str2double(get(axstep_h,'String')))' , k ); 
set(xslide_h,'Min',-max(Z)/2,'Max',max(Z)/2,...
    'SliderStep',[(Z(2)-Z(1))/Z(length(Z)) 10*(Z(2)-Z(1))/Z(length(Z))]);
update_surfdetect;