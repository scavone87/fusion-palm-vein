X = uint8(M);

% Crea una struttura di metadati DICOM
metadata = struct();
metadata.PatientName = 'Nome Paziente';
metadata.PatientID = 'ID Paziente';
% ... Assegna altri metadati DICOM ...

% Specifica il percorso completo del file DICOM di riferimento esistente
referenceDicomFile = fullfile(pwd, 'checkMatrix.dcm');

% Creazione di un oggetto dicominfo per specificare le informazioni sull'immagine
info = dicominfo(referenceDicomFile); % Ottieni le informazioni DICOM dal file di riferimento

% Salva i dati in un file DICOM
dicomFilename = fullfile(pwd, 'checkMatrix.dcm'); % Specifica il percorso e il nome del file DICOM da creare

% Reshape l'array X nel formato corretto [256 192 1 250]
X_reshaped = reshape(X, [256 470 1 523]);

% Scrivi i dati DICOM nel file
dicomwrite(X_reshaped, dicomFilename, info, 'CreateMode', 'Copy', 'MultiframeSingleFile', true);

dicomInfo = dicominfo(dicomFilename);
dicomImage = dicomread(dicomInfo);
dicomImage = squeeze(dicomImage); % Rimuovi eventuali dimensioni singleton

% [h,w,d,c] = size(dicomImage);
% pixelsSmoothed = zeros(h,w,d);
% for i = 1:d
%     pixelsSmoothed(:,:,i) = specklefilt(dicomImage(:,:,i),DegreeOfSmoothing=0.45,NumIterations=50);
% end

% Visualizza un singolo piano dell'immagine 3D
%sliceIndex = 1; % Specifica l'indice dello slice da visualizzare
%imshow(dicomImage(:,:,sliceIndex), []);

% Oppure puoi visualizzare l'intera immagine 3D in una serie di immagini
montage(dicomImage, []);

% Se desideri visualizzare una serie di immagini come animazione
implay(dicomImage)