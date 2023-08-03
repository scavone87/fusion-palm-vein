if xmeas
    set(measy_h,'Enable','inactive');
    set(measc_h,'Enable','inactive');
    button_state = get(measx_h,'Value');
    if button_state == get(measx_h,'Max')
        if xexists
            figure(xbscan);
            xline = imline(gca, xlinepos);
            xapi = iptgetapi(xline);
            xlinepos = xapi.getPosition();
            p=xlinepos;
            set(x_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)))
            xapi.addNewPositionCallback(@(p) set(x_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)  )));
            xexists=1;
        else
            figure(xbscan);
            xline = imline(gca, []);
            xapi = iptgetapi(xline);
            xlinepos = xapi.getPosition();
            p=xlinepos;
            set(x_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)))
            xapi.addNewPositionCallback(@(p) set(x_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2))));
            xexists=1;
        end
    elseif button_state == get(measx_h,'Min')
        if xexists
        xlinepos = xapi.getPosition();
        xapi.delete();
        end
    end
    xmeas=0;
    set(measy_h,'Enable','on');
    set(measc_h,'Enable','on');
end


if ymeas
    set(measx_h,'Enable','inactive');
    set(measc_h,'Enable','inactive');
    button_state = get(measy_h,'Value');
    if button_state == get(measy_h,'Max')
        if yexists
            figure(ybscan);
            yline = imline(gca, ylinepos);
            yapi = iptgetapi(yline);
            ylinepos = yapi.getPosition();
            p=ylinepos;
            set(y_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)))
            yapi.addNewPositionCallback(@(p) set(y_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2))));
            yexists=1;
        else
            figure(ybscan);
            yline = imline(gca, []);
            yapi = iptgetapi(yline);
            ylinepos = yapi.getPosition();
            p=ylinepos;
            set(y_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)))
            yapi.addNewPositionCallback(@(p) set(y_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2))));
            yexists=1;
        end
    elseif button_state == get(measy_h,'Min')
        if yexists
        ylinepos = yapi.getPosition();
        yapi.delete();
        end
    end
    ymeas=0;
    set(measx_h,'Enable','on');
    set(measc_h,'Enable','on');
end


if cmeas
    set(measy_h,'Enable','inactive');
    set(measx_h,'Enable','inactive');
    button_state = get(measc_h,'Value');
    if button_state == get(measc_h,'Max')
        if cexists
            figure(cscan);
            cline = imline(gca, clinepos);
            capi = iptgetapi(cline);
            clinepos = capi.getPosition();
            p=clinepos;
            set(c_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)))
            capi.addNewPositionCallback(@(p) set(c_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2))));
            cexists=1;
        else
            figure(cscan);
            cline = imline(gca, []);
            capi = iptgetapi(cline);
            clinepos = capi.getPosition();
            p=clinepos;
            set(c_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2)))
            capi.addNewPositionCallback(@(p) set(c_meas_h,'String',num2str(sqrt((p(2)-p(1)).^2+(p(4)-p(3)).^2))));
            cexists=1;
        end
    elseif button_state == get(measc_h,'Min')
        if cexists
        clinepos = capi.getPosition();
        capi.delete();
        end
    end 
    cmeas=0;
    set(measy_h,'Enable','on');
    set(measx_h,'Enable','on');
end

figure(pos2d_control);

