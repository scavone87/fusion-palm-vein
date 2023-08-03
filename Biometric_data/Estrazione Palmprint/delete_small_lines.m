function [BW2] = delete_small_lines(BW1)

    o = size(BW1);
    oRig = o(1);
    oCol = o(2);
    
    BW2=BW1;
    BW2(1:1,:)=0;
    BW2(:,1:1)=0;
    BW2(:,oCol)=0;
    BW2(oRig,:)=0;

    matriceNuova=BW2;
    matriceTuttiZero=zeros(oRig,oCol);
    w1 = fspecial('average', [3,3]);
    app=double(BW2);
    arit3x3 = imfilter(app,w1);

    count=1;


    % determino la lunghezza ottimale delle linee da eliminare
    if (sum(sum(BW1))<1000)
        lunghezzaLinea=12;    
    elseif (sum(sum(BW1))<2000)
        lunghezzaLinea=17;
    elseif (sum(sum(BW1))<2500)
        lunghezzaLinea=22;     
    else
        lunghezzaLinea=30;
    end



    xx=0;
    yy=0;
    for i=1:oRig
        for j=1:oCol
            if(matriceNuova(i,j)==1 && arit3x3(i,j)>0.12 && arit3x3(i,j)<0.33) %sicuramente è un punto estremo di una linea
                matriceTuttiZero(i,j)=1;
                matriceAppoggioLinea=matriceNuova;
                flag=1;
                a=i;
                b=j;
                while(flag==1) %c'è un pixel adiacente
                    flag=0;
                    for y=-1:1 %le righe adiacenti il punto
                        for x=-1:1 %le colonne adiacenti
                            if(x~=0 || y~=0)
                                if(matriceAppoggioLinea(a+y,b+x)==1)
                                    flag=1;
                                    matriceTuttiZero(a+y,b+x)=1;
                                    count=count+1;
                                    xx=b+x;
                                    yy=a+y;
                                end
                            end
                        end
                    end
                    matriceAppoggioLinea(a,b)=0; %poniamo a 0 il vecchio pixel
                    a=yy;
                    b=xx;
                end
                if(count<=lunghezzaLinea)
                    matriceNuova=matriceNuova-matriceTuttiZero;
                    BW2=BW2-matriceTuttiZero;
                end
                matriceTuttiZero(:,:)=0;
                count=1;
                w1 = fspecial('average', [3,3]);
                app1=double(matriceNuova);
                arit3x3 = imfilter(app1,w1);
            end
        end
    end
    
end    