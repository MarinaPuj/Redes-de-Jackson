
close all
clear all
clc
format long;

%% Examen
n=20;
lambda=15; %4 clients per hora. 1 cada 15 minuts 
mu1=20;%1 cada 4 minuts.
mu2=60/7;
s=2; % N�mero de finestres
K=n; % Aforament m�xim

for i=1:n
t(i,1)=i;
zero(i,1)=0;
end

noms={'Num_Costumer','Arrival_Time','Service_Time','Server','Time_Service_Begins','Time_Service_Ends','W','Idle_Time'};
T=table(t,zero,zero,zero,zero,zero,zero,zero,'VariableNames', noms);

noms={'Num_Costumer','Arrival_Time','Service_Time','Server','Time_Service_Begins','Time_Service_Ends','W','Idle_Time'};
T2=table(zero,zero,zero,zero,zero,zero,zero,zero,'VariableNames', noms);
t2=1;%indice servidor 2

%Busquem per cada client
for i=1:n
    %T.Num_Costumer(i)=i; %N� client
    T.Interarrival_time(i)=exprnd(lambda); %interarrival time
    T.Arrival_Time(i)=sum(T.Interarrival_time); %Arribada al sistema
    T.Service_Time(i)=exprnd(mu1); %Temps de servei
end

lliures=ones(1,s); %Els servidors lliures son els igual a 1. Si estan ocupats 0.
serv_end=zeros(1,s); %Temps d'acabar de servir de cada servidor. Al principi no han comen�at =0
c=1;
Csys(c)=0; %N�mero clients al sistema
f=1; %�ndex de fora
fora(f)=0; %llista clients que es queden fora

exterior=0;
%Per cada client:
i=1;
volver=1;
while(exterior<n)
    queue=[]; %llista clients al sistema. finestra + cua
    q=1;
    %Calculem els servidors que estan lliures. Iterem al llarg dels servidors
    for ii=1:s
       if (T.Arrival_Time(i)>= serv_end(ii))  %Si el temps de fi de l'�ltim client servit pel servidor m (serv_end(m)) �s m�s petit que el temps d'arribada de i -> el servidor est� lliure
           lliures(ii)=1;
       else
           lliures(ii)=0;
       end
    end
    Csys(i)=0;
    %Comparar arribada client i amb temps de fi de servei dels clients anteriors.
    for t=1:i   
        if(T.Arrival_Time(i)<T.Time_Service_Ends(t)) 
            Csys(i)=Csys(i)+1; %Numero de clients que hi ha sense contar a i.
            queue(q)=t;
            q=q+1;
        end
    end
    %{
     disp(i);
     disp(queue);
    %}
    %CAS1: Hi ha alg�n servidor lliure
    if(sum(lliures)~=0) 
        %Calcular a quin servidor anir� a parar.
        a=rand; %n�mero random entre 0 i 1
        pos=0; 
        if (sum(lliures)==1) %si nom�s hi ha un servidor lliure anir� al lliure
            pos=1; 
        elseif(a==1) %si la a=1 anir� a l'�ltim servidor lliure
            pos=sum(lliures);
        else 
            %Per tenir la mateixa probabilitat d'anar a cada servidor:
            %multipliquem a per el nombre de servidors lliures i eliminem els decimals, despr�s l'hi sumem 1. 
            %Exemple: 2 servidors lliures si a<0.5, pos=a*2 0<=pos<1, pos=0, pos=1; si 0.5<=a<1 1<=pos<2, pos=1, pos=2.
          pos=a*sum(lliures); 
          pos=floor(pos);
          pos=pos+1;
        end
        k=find(lliures==1); %�ndexs de servidors lliures
        T.Server(i)=k(pos); %Guardem el servidor que l'atendr�
        T.Time_Service_Begins(i)=T.Arrival_Time(i); %Nom�s arribar ser� servit ja que hi ha alg�n servidor lliure.
        T.Idle_Time(i)=T.Arrival_Time(i)-serv_end(k(pos)); %El servidor descansa des que marxa l'�ltim client fins que arriba aquest.
        T.Time_Service_Ends(i)=T.Time_Service_Begins(i)+ T.Service_Time(i);
        T.W(i)=T.Service_Time(i);
        serv_end(T.Server(i))=T.Time_Service_Ends(i); %Guardem el temps en que el servidor acaba de servir a l'usuari i.
    
    %CAS 2. No puc entrar. Nombre clients al sistema superior a K.
    elseif(Csys(i)>=K)
        Csys(i)=K;
        fora(f)=i;
        f=f+1;
    %CAS 3. Tots servidors plens per� puc entrar a la cua
    else %if (length(queue)<=K)
        [minim, serv] = min(serv_end); %Ser� at�s pel servidor que acabi primer (el que tingui serv_end m�s petit)
        T.Time_Service_Begins(i)=minim; %Comen�ar� a ser servit quan el servidor acabi
        T.Server(i)=serv; %Guardem el n�mero de servidor.
        T.Idle_Time(i)=0; %El servidor no descansar�
        T.Time_Service_Ends(i)=T.Time_Service_Begins(i)+ T.Service_Time(i);
        T.Wq(i)=T.Time_Service_Begins(i)-T.Arrival_Time(i);
        T.W(i)=T.Wq(i)+T.Service_Time(i);
        serv_end(T.Server(i))=T.Time_Service_Ends(i); %Guardem el temps en que el servidor acaba de servir a l'usuari i.
 
    end
    
    %El client va a M/M/1
    T2.Num_Costumer(t2)=T.Num_Costumer(i);
    T2.Arrival_Time(t2)=T.Time_Service_Ends(i);
    T2.Service_Time(t2)=exprnd(mu2); %Temps de servei
    
    if(t2~=1)
        if T2.Time_Service_Ends(t2-1)>T2.Arrival_Time(t2) %Si hi ha cua (el de davant acaba de ser servit m�s tard del que el de darrere ha arribat)
            T2.Time_Service_Begins(t2)=T2.Time_Service_Ends(t2-1); %inici del servei coincideix amb finalitzaci� servei anterior
             T2.Time_Service_Ends(t2)=T2.Time_Service_Ends(t2-1)+T2.Service_Time(t2);
             T2.Idle_Time(t2)=0;
        else
            T2.Time_Service_Begins(t2)=T2.Arrival_Time(t2); %inici del servei en quant arriba al sistema
            T2.Time_Service_Ends(t2)=T2.Time_Service_Begins(t2)+T2.Service_Time(t2);
            T2.Idle_Time(t2)=T2.Arrival_Time(t2)-T2.Time_Service_Ends(t2-1); 
        end
    else
        T2.Time_Service_Begins(t2)=T2.Arrival_Time(t2);
        T2.Time_Service_Ends(t2)=T2.Time_Service_Begins(t2)+T2.Service_Time(t2);
        T2.Idle_Time(t2)=T2.Arrival_Time(t2);
    end
   
    T2.W(t2)=T2.Time_Service_Ends(t2)-T2.Arrival_Time(t2);
    T2.Wq(t2)=T2.Time_Service_Begins(t2)-T2.Arrival_Time(t2);
   
    %Hemos acabado con la M/M/1
    
    aaa=rand; %n�mero random entre 0 i 1
    %Con probabilidad 0,8
    if(aaa>0.2) %Se va al exterior
     exterior=exterior+1;
    else %Se vuelve a M/M/2
        T.Num_Costumer(n+volver)=T.Num_Costumer(i);
        T.Arrival_Time(n+volver)=T2.Time_Service_Ends(t2);
        T.Service_Time(n+volver)=exprnd(mu1); %Temps de servei
        T = sortrows(T,'Arrival_Time','ascend');
        volver=volver+1;
    end
    
    t2=t2+1;
    i=i+1;
end

volver=volver-1; %clients que tornen
T2.Server=[];

%La tabla 1 corresponde a la M/M/2, que es la estaci�n 1, y hay m�s de una fila por cada cliente
%si es que el cliente repite. De la estaci�n 1, se va a la M/M/1 y de ah�
%se va con probabilidad 0.8 y con 0.2 vuelve a la M/M/1.