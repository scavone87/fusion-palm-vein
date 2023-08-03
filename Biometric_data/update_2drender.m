
curr_pos = get(xslide_h,'Value');

if curr_pos ~= curr_x_pos
    curr_x_pos = curr_pos;
    set(x_pos_h,'String',num2str(curr_x_pos));
    figure(xbscan);
    y=curr_x_pos;
    imagesc( X,Z,squeeze(M (:,:,find( abs(Y-y)==(min(abs(Y-y)) ) ))),[0 255]);
    colormap(gray(256));
    set(gca,'ActivePositionProperty','position');
    set(gca,'DataAspectRatio',[1 1 1]);
    xlabel('x-lateral distance [mm]');
    ylabel('axial distance [mm]');
end


curr_pos = get(yslide_h,'Value');

if curr_pos ~= curr_y_pos
    curr_y_pos = curr_pos;
    set(y_pos_h,'String',num2str(curr_y_pos));
    figure(ybscan);
    x=curr_y_pos;
    imagesc(Y,Z,squeeze(M (:,find( abs(X-x)==(min(abs(X-x)) ) ),:)),[0 255]);
    colormap(gray(256));
    set(gca,'ActivePositionProperty','position');
    set(gca,'DataAspectRatio',[1 1 1]);
    xlabel('y-lateral distance [mm]');
    ylabel('axial distance [mm]');
end

curr_pos = get(cslide_h,'Value');

if curr_pos ~= curr_c_pos
    curr_c_pos = curr_pos;
    set(c_pos_h,'String',num2str(curr_c_pos));  
    figure(cscan);
    z=curr_c_pos;
    imagesc(Y,X,squeeze(M(find((abs(Z-z)==(min(abs(Z-z))))),:,:)),[0 255]);
    colormap(gray(256));
    set(gca,'ActivePositionProperty','position');
    set(gca,'DataAspectRatio',[1 1 1]);
    xlabel('y-lateral distance [mm]');
    ylabel('x-lateral distance [mm]');
end
figure(pos2d_control);

