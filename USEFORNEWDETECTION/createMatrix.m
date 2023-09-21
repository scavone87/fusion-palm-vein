cartella = dir("Template2D");
x_shape = 835;
y_shape = 820;
raggio_cerchio = 6; % Raggio del cerchio

for i = 3:length(cartella)
    load("Template2D\" + cartella(i).name);
    
    % Inizializza una matrice 2D con zeri
    M = false(x_shape, y_shape);
    
    for j = 1:length(x_coords)
        % Calcola il centro del cerchio in base alle coordinate correnti
        centro_x = y_coords(j) + 1;
        centro_y = x_coords(j) + 1;
        
        % Verifica se il centro del cerchio è all'interno dei limiti della matrice
        if centro_x >= raggio_cerchio + 1 && centro_x <= x_shape - raggio_cerchio && ...
           centro_y >= raggio_cerchio + 1 && centro_y <= y_shape - raggio_cerchio
            % Itera attraverso tutte le coordinate all'interno del rettangolo del cerchio
            for x = -raggio_cerchio:raggio_cerchio
                for y = -raggio_cerchio:raggio_cerchio
                    % Calcola la distanza dalla coordinata corrente al centro
                    distanza = sqrt(x^2 + y^2);

                    % Se la distanza è inferiore o uguale al raggio del cerchio, assegna "true"
                    if distanza <= raggio_cerchio
                        x_coord = centro_x + x;
                        y_coord = centro_y + y;

                        % Asssegna "true" alla coordinata nella matrice
                        M(x_coord, y_coord) = true;
                    end
                end
            end
        end
    end
    M = M(:,196:705);
    % Salva la matrice con il cerchio nel nuovo percorso
    save("template_2D\" + cartella(i).name, "M")
    
    % Calcola il completamento
    completamento = (i - 2) / (length(cartella) - 2) * 100;
    disp("Completamento: " + completamento + "%")
end
clear
cartella = dir("Template3D");
x_shape = 835;
y_shape = 820;
z_shape = 320;
raggio_sfera = 6; % Raggio della sfera

for i = 3:length(cartella)
    load("Template3D\" + cartella(i).name)
    
    % Inizializza una matrice 3D con zeri
    M = false(z_shape, x_shape, y_shape);
    
    for j = 1:length(x_coords)
        % Calcola il centro della sfera in base alle coordinate correnti
        centro_x = y_coords(j) + 1;
        centro_y = x_coords(j) + 1;
        centro_z = z_coords(j) + 1;

        % Verifica se il centro della sfera è all'interno dei limiti della matrice
        if centro_x >= raggio_sfera + 1 && centro_x <= x_shape - raggio_sfera && ...
           centro_y >= raggio_sfera + 1 && centro_y <= y_shape - raggio_sfera && ...
           centro_z >= raggio_sfera + 1 && centro_z <= z_shape - raggio_sfera
        
            % Itera attraverso tutte le coordinate all'interno della sfera
            for x = -raggio_sfera:raggio_sfera
                for y = -raggio_sfera:raggio_sfera
                    for z = -raggio_sfera:raggio_sfera
                        % Calcola la distanza dalla coordinata corrente al centro
                        distanza = sqrt(x^2 + y^2 + z^2);

                        % Se la distanza è inferiore o uguale al raggio della sfera, assegna "true"
                        if distanza <= raggio_sfera
                            x_coord = centro_x + x;
                            y_coord = centro_y + y;
                            z_coord = centro_z + z;

                            % Asssegna "true" alla coordinata nella matrice
                            M(z_coord, x_coord, y_coord) = true;
                        end
                    end
                end
            end
        end
    end
    
    M = M(:,:,196:705);
    % Salva la matrice con la sfera nel nuovo percorso
    save("template_3D\" + cartella(i).name, "M")
    
    % Calcola il completamento
    completamento = (i - 2) / (length(cartella) - 2) * 100
end
