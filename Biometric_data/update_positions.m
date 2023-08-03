xxmin=str2num(get(x_xmin_h,'String'));
xxmax=str2num(get(x_xmax_h,'String'));
xymin=str2num(get(x_ymin_h,'String')); 
xymax=str2num(get(x_ymax_h,'String'));
x_new_position=[xxmin xymin xxmax-xxmin xymax-xymin];
xapi.setPosition(x_new_position);

yxmin=str2num(get(y_xmin_h,'String')); 
yxmax=str2num(get(y_xmax_h,'String'));
yymin=str2num(get(y_ymin_h,'String'));
yymax=str2num(get(y_ymax_h,'String'));

y_new_position=[yxmin yymin yxmax-yxmin yymax-yymin];
yapi.setPosition(y_new_position);
                