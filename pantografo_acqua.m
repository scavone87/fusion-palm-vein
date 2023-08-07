classdef pantografo_acqua
    
    properties
        coordinate=[0.00, 16.00, 20];
        movimentazione='assoluta';
        fineCorsa=struct('minimi',[-1000, -1000, -1000],'massimi',[1000 21000 5000]);
        velocita=800;
        modalitaV='millimetriAlMinuto';
        s = serial('COM1','Terminator','n');
        
        
        
        
    end%properties
    
    
    
    methods
        function obj=settaModalitaV(obj,modalita)
            switch(modalita)
                case ('millimetriAlMinuto')
                    obj.modalitaV=modalita;
                    stampa(obj.s,'G94');
                case ('reciprocoTempo')%1/minuti
                    obj.modalitaV=modalita;
                    stampa(obj.s,'G93');
                otherwise
                    error('errore di sintassi: modalitaV=millimetriAlMinuto/reciprocoTempo');
            end%switch
        end%settaModalitaV
        
        function obj=settaVelocita(obj,v)
            if (v<=0)
                error('v deve essere positivo');
            else
                obj.velocita=v;
                stampa(obj.s,['F' num2str(v)]);
            end
        end%settaVelocita
        
        
        function obj=settaMovimentazione(obj,tipo)
            switch(tipo)
                case ('assoluta')
                    obj.movimentazione=tipo;
                    stampa(obj.s,'G90');
                case ('relativa')
                    obj.movimentazione=tipo;
                    stampa(obj.s,'G91');
                otherwise
                    error('errore di sintassi: movimentazione=assoluta/relativa');
            end%switch
        end%settaMovimentazione
        
        
        function obj=muovi(obj,vettore)%vettore=[x y z]
            switch obj.movimentazione
                case ('assoluta')
                    obj.coordinate(not(isnan(vettore)))=vettore(not(isnan(vettore)));
                    obj.coordinate=min( max(obj.coordinate,obj.fineCorsa.minimi) , obj.fineCorsa.massimi);
                    switch obj.modalitaV
                        case ('millimetriAlMinuto')
                            stampa(obj.s,['G1 X' num2str(obj.coordinate(1)) ' Y' num2str(obj.coordinate(2)) ' Z' num2str(obj.coordinate(3)) ])
                        case ('reciprocoTempo')
                            stampa(obj.s,['F' num2str(obj.velocita) 'G1 X' num2str(obj.coordinate(1)) ' Y' num2str(obj.coordinate(2)) ' Z' num2str(obj.coordinate(3)) ])
                        otherwise
                            error('modalitaV è maldefinito')
                    end%switch obj.modalitaV
                case ('relativa')
                    vettore(isnan(vettore))=0;
                    coordinate2=obj.coordinate + vettore;
                    coordinate2=min( max(coordinate2,obj.fineCorsa.minimi) , obj.fineCorsa.massimi);
                    
                    vettore=coordinate2-obj.coordinate;
                    obj.coordinate=coordinate2;
                    switch obj.modalitaV
                        case ('millimetriAlMinuto')
                            stampa(obj.s,['G1 X' num2str(vettore(1)) ' Y' num2str(vettore(2)) ' Z' num2str(vettore(3)) ]);
                        case ('reciprocoTempo')
                            stampa(obj.s,['F' num2str(obj.velocita) 'G1 X' num2str(vettore(1)) ' Y' num2str(vettore(2)) ' Z' num2str(vettore(3)) ]);
                        otherwise
                            error('modalitaV è maldefinito')
                    end%switch obj.modalitaV
                otherwise
                    error('movimentazione è maldefinito')
            end%switch obj.movimentazione
        end %muovi
        
        function obj=muoviVeloce(obj,vettore)%vettore=[x y z]
            switch obj.movimentazione
                case ('assoluta')
                    obj.coordinate(not(isnan(vettore)))=vettore(not(isnan(vettore)));
                    obj.coordinate=min( max(obj.coordinate,obj.fineCorsa.minimi) , obj.fineCorsa.massimi);
                    stampa(obj.s,['G0 X' num2str(obj.coordinate(1)) ' Y' num2str(obj.coordinate(2)) ' Z' num2str(obj.coordinate(3)) ]);
                case ('relativa')
                    vettore(isnan(vettore))=0;
                    coordinate2=obj.coordinate + vettore;
                    coordinate2=min( max(coordinate2,obj.fineCorsa.minimi) , obj.fineCorsa.massimi);
                    vettore=coordinate2-obj.coordinate;
                    stampa(obj.s,['G0 X' num2str(vettore(1)) ' Y' num2str(vettore(2)) ' Z' num2str(vettore(3)) ]);
                    obj.coordinate=coordinate2;
                otherwise
                    error('movimentazione è maldefinito')
            end%switch
        end %muovi
        
        function obj=tornaOrigine(obj)%vettore=[x y z]
            switch obj.movimentazione
                case ('assoluta')
                    stampa(obj.s,'G0 X0.00 Y16.00 Z20');
                case ('relativa')
                    stampa(obj.s,'G90');
                    stampa(obj.s,'G0 X0.00 Y16.00 Z20');
                    stampa(obj.s,'G90');
            end%switch
            obj.coordinate=[0.00, 16.00, 20]; 
        end %tornaOrigine
        
        
        function obj=spezzata(obj,punti)%punti=[x1 y1 z1;x2 y2 z2;...]
            if not(strcmp(obj.movimentazione,'assoluta'))
                error('la movimentazione deve essere assoluta');
            else
                v=obj.velocita/60;
                n=length(punti(:,1));
                for i=1:n
                    %stampa al massimo 5 comandi consecutivi
                    if i>5
                        switch(obj.modalitaV)
                            case ('millimetriAlMinuto')
                                spazioPercorso=sqrt(sum( (punti(i,:)-obj.coordinate).^2));
                                tempo=round(spazioPercorso/v*1000)/1000;
                            case ('reciprocoTempo')
                                tempo=round(1000/v)/1000;
                            otherwise
                                error('modalitaV è maldefinito');
                        end
                        t=timer('TimerFcn',@(x,y)[],'StartDelay',tempo);
                        start(t);
                        obj=obj.muovi(punti(i,:));
                        wait(t);
                    else
                        obj=obj.muovi(punti(i,:));
                    end%if
                end%for
            end%if
        end%spezzata
        
        function obj=sequenza(obj,spostamenti)%spostamento=[x1 y1 z1;x2 y2 z2;...]
            if not(strcmp(obj.movimentazione,'relativa'))
                error('la movimentazione deve essere relativa');
            else
                n=length(spostamenti(:,1));
                for i=1:n
                    obj=obj.muovi(spostamenti(i,:));
                end%for
            end%if
        end%spezzata
        
    end%methods
    
    
end%classdef '

function stampa(s,comando)
    if (strcmp(s.status,'closed'))
        fopen(s);
    end
    fprintf(s,comando);
    fclose(s);
end%stampa

