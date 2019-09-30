chdir("C:\Users\Asus\Documents\Applied Physics 186\act 9");

music_sheet = imread("cropped.jpg");
music_sheet = im2bw(music_sheet, 0.2);;
scf(); imwrite(music_sheet, "thresholded.png");
music_sheet = imcomplement(music_sheet);
scf(); imwrite(music_sheet, "inverted_ms.png");

//morphological operation
se1 = CreateStructureElement('circle',3);
se2 = CreateStructureElement('circle',2);
music_sheet = CloseImage(music_sheet,se1);
music_sheet = OpenImage(music_sheet,se2);
scf(); imwrite(music_sheet, "morphed.png");

//locating the centroid of each blobs 
Object = SearchBlobs(music_sheet);
x_cent=zeros(1,max(Object))
y_cent=zeros(1,max(Object))

for i=1:max(Object)
    [y,x]=find(Object==i)
    xmean=mean(x)
    ymean=mean(y)
    x_cent(i)=xmean
    y_cent(i)=ymean
end

C = 261.63*2;
D = 293.66*2;
E = 329.63*2;
F = 349.23*2;
G = 392*2;
A = 440*2;

note=zeros(1,size(y_cent,2))
for j=1:size(y_cent,2)
    if y_cent(1,j)>44 & y_cent(1,j)<46
        note(1,j) = C
    end
    if y_cent(1,j)>31 & y_cent(1,j)<33
        note(1,j) = G
    end
    if y_cent(1,j)>28 & y_cent(1,j)<31
        note(1,j) = A
    end
    if y_cent(1,j)>34 & y_cent(1,j)<36
        note(1,j) = F
    end
    if y_cent(1,j)>37 & y_cent(1,j)<39
        note(1,j) = E
    end
    if y_cent(1,j)>40 & y_cent(1,j)<42
        note(1,j) = D
    end
end

spacing=diff(x_cent)
timing=zeros(1,size(x_cent,2))
for j=1:size(spacing,2)
    if spacing(j)>60
        timing(j)=4
    end
    if spacing(j)<60
        timing(j)=2
    end
end
timing(1,14)=2

function n = note_function(f, t)
    n = sin(2*%pi*f*linspace(0,t,8192*t));
    line1 = linspace(0, 1, 410*t); 
    line2 = linspace(1, 1, 819*t); 
    line3 = linspace(1, 0.9, 819*t); 
    line4 = linspace(0.9, 0.45, 5734*t); 
    line5 = linspace(0.45, 0, 410*t); 
    envelope=[line1,line2,line3,line4,line5];
    n=n.*envelope
endfunction;


music = []
for i=1:size(note,2)
   music =cat(2,music,note_function(note(1,i),(timing(1,i)))) 
end
sound(music,8192)
wavwrite(music, "twinkle_with_envelope(high).mp3")
