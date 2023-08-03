%converte i dati UOB in immagini bmp
%se non si vuole usare la procedura eliminaResidui
%basta commentare la riga   X=X.*S

X=zeros(dimZ,dimX,dimY);
disp(dimY);
disp(dimZ);
disp(dimX);
for i=1:dimY
    Read(DataObj,'firstPri',dimX*(i-1)+1,'npri',dimX);
    x=abs(DataObj.LastReadData);
    X(:,:,i)=x;
end
X=X.*S;
M=max(max(max(X)));

soglia=-50;
nome=pathnameBS;

for i=1:dimY
    x=X(:,:,i);
    x=20*log10(x/M);
    x(x<soglia)=soglia;
    x=-(x-soglia)/soglia*255;
    x=imresize(x,[dimZ v.new_dimX]);
    x=uint8(x);
    if i<10          
        imwrite(x,[nome '00' num2str(i) '.bmp']);
    else
        if i<100
            imwrite(x,[nome '0' num2str(i) '.bmp']);
        else
            imwrite(x,[nome num2str(i) '.bmp']);

        end
    end
end

