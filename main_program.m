
% nomes, nusp e professor
% Denisson José Panta Oliveira - 10355440 - Prof. Silvio
% Lucas Penna Saraiva - 9770566 - Profa. Milana
% Stefan Radzyckyj Raposo- 9267154 - Profa. Milana

%aqui nos chamamos os arquivos fornecidos pelos professores para que possamos usar seus dados
run ('TOP045.m');
run ('CAR045.m');
run ('VOL045.m');
%criação dos dois arquivos externos que vão receber as informaçoes referentes a localização mais provavel do curto de todos os trechos (OUT045)
%e o outro (REL045) que diz o trecho mais provável de cada um dos 10 casos
REL = fopen('REL045.csv','wt');
OUT = fopen('OUT045.csv','wt');
c = cargas;
MATRIZTOP = topologia;
v = Emedido;

%essa variavel serve pra identificar qual dos trechos é o mais provável do
%curto estar
Trecho_Com_Erro = 0;


%tensao de cada fase, consideramos sistema de sequencia direta
Vth = (13800/sqrt(3));
Vthb = Vth*(cos(-120)+i*sin(-120));
Vthc = Vth*(cos(120)+i*sin(120));

%aqui eh calculado a impedancia de cada carga que esta conectada aos nós do
%circuito a partir dos dados do arquivo CAR045. Lembrando que o Zth citado
%no enunciado está conectado a barra 010 e ele nao esta citado no arquivo.
%Lembrando também que para cada i do vetor de impedâncias Z(i) corresponde
%a um nó, por exemplo, para i = 6 a correspondência é o nó 060

Z(1) = (Vth^2)/(((1/3)*10E8)*(cos(80*pi/180)- i*sin(80*pi/180)));

for aux=1:size(cargas,1)
    Z(aux+1) = (13800^2)/(1000*(cargas(aux,2) - i*cargas(aux,2).*tan(acos(cargas(aux,3)))));
end

%calculo das correntes de cada fase da sequencia direta
Ia = Vth/Z(1);
Ib = Vth*(cos(-120)+i*sin(-120))/Z(1);
Ic = Vth*(cos(120)+i*sin(120))/Z(1);

VetorI =[Ia; Ib; Ic];



%aqui o grupo realiza a criação das matrizes Q para o circuito trifásico,
%ou seja, cada elemento de valor 1 seria considerado como uma matriz
%identidade 3x3 e cada elemento de valor 0 seria considerado como uma
%matriz de zeros. Realizamos abaixo a criação de todas as matrizes Q para
%todos os respectivos trechos seguindo a lógica que foi dita no enunciado,
%vale ressaltar também que os elementos do 36 até o final são
%correspondentes aos trechos que realizam a conexão do nó até a terra por
%meio das cargas. 
%temos que adicionar também o nó que conecta a falha ao pai, um nó que
%conecta a falha ao filho e também um nó que conecta a falha ao terra. Para
%cada trecho respectivo o grupo criou uma matriz Q, por isso tambem que as
%nossas iterações vão ate o 71, por conta exatamente da existência da falta

Q = zeros(3);
for k=2:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q(k+1,MATRIZTOP(k,1)/10) = 1;
    Q(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

Q(1,1) = 1;
Q(1,36) = -1;
Q(2,36) = 1;
Q(2,2) = -1;


iteration = 3;
for p = 2 : 36
    Q(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q(36,1) = -1;

Q3= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
%gerar matriz de incidência com elementos sendo matrizes 3x3
for I=1:71
    for J=1:36
        if(Q(I,J)==1)
       
        Q3(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q(I,J)==-1)
            
            Q3(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
            
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q3t = transpose(Q3);

%matriz 20-30
Q23 = zeros(3);

for y=1:1
    Q23(y,MATRIZTOP(y,1)/10) = 1;
    Q23(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q23(2,2) = 1;
Q23(2,36) = -1;
Q23(3,36) = 1;
Q23(3,3) = -1;

for k=3:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q23(k+1,MATRIZTOP(k,1)/10) = 1;
    Q23(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q23(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q23(36,1) = -1;

Q323= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q23(I,J)==1)
       
        Q323(posicaoKiQ,posicaoKjdaQ)= 1;
        Q323(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q323(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q23(I,J)==-1)
            
            Q323(posicaoKiQ,posicaoKjdaQ)= -1;
        Q323(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q323(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
            
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q323t = transpose(Q323);

%matriz 30-40

for y=1:2
    Q34(y,MATRIZTOP(y,1)/10) = 1;
    Q34(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q34(3,3) = 1;
Q34(3,36) = -1;
Q34(4,36) = 1;
Q34(4,4) = -1;

for k=4:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q34(k+1,MATRIZTOP(k,1)/10) = 1;
    Q34(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q34(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q34(36,1) = -1;

Q334= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q34(I,J)==1)
       
        Q334(posicaoKiQ,posicaoKjdaQ)= 1;
        Q334(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q334(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q34(I,J)==-1)
            
            Q334(posicaoKiQ,posicaoKjdaQ)= -1;
        Q334(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q334(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
            
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q334t = transpose(Q323);

%40-50

for y=1:3
    Q45(y,MATRIZTOP(y,1)/10) = 1;
    Q45(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q45(4,4) = 1;
Q45(4,36) = -1;
Q45(5,36) = 1;
Q45(5,5) = -1;

for k=5:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q45(k+1,MATRIZTOP(k,1)/10) = 1;
    Q45(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q45(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q45(36,1) = -1;

Q345= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q45(I,J)==1)
       
        Q345(posicaoKiQ,posicaoKjdaQ)= 1;
        Q345(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q345(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q45(I,J)==-1)
            
            Q345(posicaoKiQ,posicaoKjdaQ)= -1;
        Q345(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q345(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q345t = transpose(Q345);

%50-60

for y=1:4
    Q56(y,MATRIZTOP(y,1)/10) = 1;
    Q56(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q56(5,5) = 1;
Q56(5,36) = -1;
Q56(6,36) = 1;
Q56(6,6) = -1;

for k=6:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q56(k+1,MATRIZTOP(k,1)/10) = 1;
    Q56(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q56(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q56(36,1) = -1;

Q356= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q56(I,J)==1)
       
        Q356(posicaoKiQ,posicaoKjdaQ)= 1;
        Q356(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q356(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q56(I,J)==-1)
            
            Q356(posicaoKiQ,posicaoKjdaQ)= -1;
        Q356(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q356(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q356t = transpose(Q356);

%60-70

for y=1:5
    Q67(y,MATRIZTOP(y,1)/10) = 1;
    Q67(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q67(6,6) = 1;
Q67(6,36) = -1;
Q67(7,36) = 1;
Q67(7,7) = -1;

for k=7:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q67(k+1,MATRIZTOP(k,1)/10) = 1;
    Q67(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q67(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q67(36,1) = -1;

Q367= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q67(I,J)==1)
       
        Q367(posicaoKiQ,posicaoKjdaQ)= 1;
        Q367(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q367(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q67(I,J)==-1)
            
            Q367(posicaoKiQ,posicaoKjdaQ)= -1;
        Q367(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q367(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q367t = transpose(Q367);

%70-270

for y=1:6
    Q727(y,MATRIZTOP(y,1)/10) = 1;
    Q727(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q727(7,7) = 1;
Q727(7,36) = -1;
Q727(8,36) = 1;
Q727(8,27) = -1;

for k=8:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q727(k+1,MATRIZTOP(k,1)/10) = 1;
    Q727(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q727(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q727(36,1) = -1;

Q3727= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q727(I,J)==1)
       
        Q3727(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3727(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3727(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q727(I,J)==-1)
            
            Q3727(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3727(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3727(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q3727t = transpose(Q3727);

%270-280

for y=1:7
    Q2728(y,MATRIZTOP(y,1)/10) = 1;
    Q2728(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2728(8,27) = 1;
Q2728(8,36) = -1;
Q2728(9,36) = 1;
Q2728(9,28) = -1;

for k=9:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2728(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2728(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q2728(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2728(36,1) = -1;

Q32728= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2728(I,J)==1)
       
        Q32728(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32728(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32728(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2728(I,J)==-1)
            
            Q32728(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32728(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32728(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end



Q32728t = transpose(Q32728);

%28-30

for y=1:8
    Q2830(y,MATRIZTOP(y,1)/10) = 1;
    Q2830(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2830(9,28) = 1;
Q2830(9,36) = -1;
Q2830(10,36) = 1;
Q2830(10,30) = -1;

for k=10:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2830(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2830(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q2830(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2830(36,1) = -1;

Q32830= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2830(I,J)==1)
       
        Q32830(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32830(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32830(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2830(I,J)==-1)
            
            Q32830(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32830(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32830(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q32830t = transpose(Q32830);

%30-32

for y=1:9
    Q3032(y,MATRIZTOP(y,1)/10) = 1;
    Q3032(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3032(10,30) = 1;
Q3032(10,36) = -1;
Q3032(11,36) = 1;
Q3032(11,32) = -1;

for k=11:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3032(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3032(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q3032(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3032(36,1) = -1;

Q33032= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3032(I,J)==1)
       
        Q33032(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33032(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33032(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3032(I,J)==-1)
            
            Q33032(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33032(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33032(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33032t = transpose(Q33032);

%3-35

for y=1:10
    Q335(y,MATRIZTOP(y,1)/10) = 1;
    Q335(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q335(11,3) = 1;
Q335(11,36) = -1;
Q335(12,36) = 1;
Q335(12,35) = -1;

for k=12:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q335(k+1,MATRIZTOP(k,1)/10) = 1;
    Q335(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q335(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q335(36,1) = -1;

Q3335= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q335(I,J)==1)
       
        Q3335(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3335(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3335(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q335(I,J)==-1)
            
            Q3335(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3335(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3335(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3335t = transpose(Q3335);

%35-8

for y=1:11
    Q358(y,MATRIZTOP(y,1)/10) = 1;
    Q358(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q358(12,35) = 1;
Q358(12,36) = -1;
Q358(13,36) = 1;
Q358(13,8) = -1;

for k=13:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q358(k+1,MATRIZTOP(k,1)/10) = 1;
    Q358(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q358(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q358(36,1) = -1;

Q3358= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q358(I,J)==1)
       
        Q3358(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3358(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3358(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q358(I,J)==-1)
            
            Q3358(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3358(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3358(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3358t = transpose(Q3358);

%35-9

for y=1:12
    Q359(y,MATRIZTOP(y,1)/10) = 1;
    Q359(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q359(13,35) = 1;
Q359(13,36) = -1;
Q359(14,36) = 1;
Q359(14,9) = -1;

for k=14:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q359(k+1,MATRIZTOP(k,1)/10) = 1;
    Q359(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q359(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q359(36,1) = -1;

Q3359= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q359(I,J)==1)
       
        Q3359(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3359(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3359(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q359(I,J)==-1)
            
            Q3359(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3359(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3359(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3359t = transpose(Q3359);

%35-10

for y=1:13
    Q3510(y,MATRIZTOP(y,1)/10) = 1;
    Q3510(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3510(14,35) = 1;
Q3510(14,36) = -1;
Q3510(15,36) = 1;
Q3510(15,10) = -1;

for k=15:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3510(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3510(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q3510(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3510(36,1) = -1;

Q33510= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3510(I,J)==1)
       
        Q33510(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33510(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33510(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3510(I,J)==-1)
            
            Q33510(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33510(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33510(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33510t = transpose(Q33510);

%4-13

for y=1:14
    Q413(y,MATRIZTOP(y,1)/10) = 1;
    Q413(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q413(15,4) = 1;
Q413(15,36) = -1;
Q413(16,36) = 1;
Q413(16,13) = -1;

for k=16:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q413(k+1,MATRIZTOP(k,1)/10) = 1;
    Q413(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q413(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q413(36,1) = -1;

Q3413= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q413(I,J)==1)
       
        Q3413(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3413(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3413(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q413(I,J)==-1)
            
            Q3413(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3413(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3413(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3413t = transpose(Q3413);

%5-19

for y=1:15
    Q519(y,MATRIZTOP(y,1)/10) = 1;
    Q519(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q519(16,5) = 1;
Q519(16,36) = -1;
Q519(17,36) = 1;
Q519(17,19) = -1;

for k=17:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q519(k+1,MATRIZTOP(k,1)/10) = 1;
    Q519(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q519(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q519(36,1) = -1;

Q3519= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q519(I,J)==1)
       
        Q3519(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3519(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3519(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q519(I,J)==-1)
            
            Q3519(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3519(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3519(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3519t = transpose(Q3519);

%19-20

for y=1:16
    Q1920(y,MATRIZTOP(y,1)/10) = 1;
    Q1920(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q1920(17,19) = 1;
Q1920(17,36) = -1;
Q1920(18,36) = 1;
Q1920(18,20) = -1;

for k=18:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q1920(k+1,MATRIZTOP(k,1)/10) = 1;
    Q1920(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q1920(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q1920(36,1) = -1;

Q31920= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q1920(I,J)==1)
       
        Q31920(posicaoKiQ,posicaoKjdaQ)= 1;
        Q31920(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        
        end
        if(Q1920(I,J)==-1)
            
            Q31920(posicaoKiQ,posicaoKjdaQ)= -1;
        Q31920(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q31920(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q31920t = transpose(Q31920);

%19-21

for y=1:17
    Q1921(y,MATRIZTOP(y,1)/10) = 1;
    Q1921(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q1921(18,19) = 1;
Q1921(18,36) = -1;
Q1921(19,36) = 1;
Q1921(19,21) = -1;

for k=19:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q1921(k+1,MATRIZTOP(k,1)/10) = 1;
    Q1921(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q1921(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q1921(36,1) = -1;

Q31921= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q1921(I,J)==1)
       
        Q31921(posicaoKiQ,posicaoKjdaQ)= 1;
        Q31921(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q31921(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q1921(I,J)==-1)
            
            Q31921(posicaoKiQ,posicaoKjdaQ)= -1;
        Q31921(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q31921(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q31921t = transpose(Q31921);

%21-22

for y=1:18
    Q2122(y,MATRIZTOP(y,1)/10) = 1;
    Q2122(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2122(19,21) = 1;
Q2122(19,36) = -1;
Q2122(20,36) = 1;
Q2122(20,22) = -1;

for k=20:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2122(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2122(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q2122(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2122(36,1) = -1;

Q32122= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2122(I,J)==1)
       
        Q32122(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32122(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32122(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2122(I,J)==-1)
            
            Q32122(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32122(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32122(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q32122t = transpose(Q32122);

%21-23

for y=1:19
    Q2123(y,MATRIZTOP(y,1)/10) = 1;
    Q2123(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2123(20,21) = 1;
Q2123(20,36) = -1;
Q2123(21,36) = 1;
Q2123(21,23) = -1;

for k=21:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2123(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2123(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q2123(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2123(36,1) = -1;

Q32123= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2123(I,J)==1)
       
        Q32123(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32123(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32123(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2123(I,J)==-1)
            
            Q32123(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32123(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32123(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q32123t = transpose(Q32123);

%23-24

for y=1:20
    Q2324(y,MATRIZTOP(y,1)/10) = 1;
    Q2324(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2324(21,23) = 1;
Q2324(21,36) = -1;
Q2324(22,36) = 1;
Q2324(22,24) = -1;

for k=22:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2324(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2324(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q2324(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2324(36,1) = -1;

Q32324= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2324(I,J)==1)
       
        Q32324(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32324(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32324(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2324(I,J)==-1)
            
            Q32324(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32324(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32324(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q32324t = transpose(Q32324);

%23-25

for y=1:21
    Q2325(y,MATRIZTOP(y,1)/10) = 1;
    Q2325(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2325(22,23) = 1;
Q2325(22,36) = -1;
Q2325(23,36) = 1;
Q2325(23,25) = -1;

for k=23:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2325(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2325(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q2325(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2325(36,1) = -1;

Q32325= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2325(I,J)==1)
       
        Q32325(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32325(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32325(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2325(I,J)==-1)
            
            Q32325(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32325(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32325(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q32325t = transpose(Q32325);

%2-33

for y=1:22
    Q233(y,MATRIZTOP(y,1)/10) = 1;
    Q233(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q233(23,2) = 1;
Q233(23,36) = -1;
Q233(24,36) = 1;
Q233(24,33) = -1;

for k=24:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q233(k+1,MATRIZTOP(k,1)/10) = 1;
    Q233(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q233(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q233(36,1) = -1;

Q3233= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q233(I,J)==1)
       
        Q3233(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3233(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3233(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q233(I,J)==-1)
            
            Q3233(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3233(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3233(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3233t = transpose(Q3233);

%33-11

for y=1:23
    Q3311(y,MATRIZTOP(y,1)/10) = 1;
    Q3311(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3311(24,33) = 1;
Q3311(24,36) = -1;
Q3311(25,36) = 1;
Q3311(25,11) = -1;

for k=25:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3311(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3311(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q3311(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3311(36,1) = -1;

Q33311= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3311(I,J)==1)
       
        Q33311(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33311(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33311(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3311(I,J)==-1)
            
            Q33311(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33311(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33311(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33311t = transpose(Q33311);

%33-12

for y=1:24
    Q3312(y,MATRIZTOP(y,1)/10) = 1;
    Q3312(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3312(25,33) = 1;
Q3312(25,36) = -1;
Q3312(26,36) = 1;
Q3312(26,12) = -1;

for k=26:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3312(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3312(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q3312(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3312(36,1) = -1;

Q33312= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3312(I,J)==1)
       
        Q33312(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33312(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33312(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3312(I,J)==-1)
            
            Q33312(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33312(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33312(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33312t = transpose(Q33312);

%5-34

for y=1:25
    Q534(y,MATRIZTOP(y,1)/10) = 1;
    Q534(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q534(26,5) = 1;
Q534(26,36) = -1;
Q534(27,36) = 1;
Q534(27,34) = -1;

for k=27:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q534(k+1,MATRIZTOP(k,1)/10) = 1;
    Q534(k+1,MATRIZTOP(k,2)/10) = -1;
  
end


iteration = 3;
for p = 2 : 36
    Q534(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q534(36,1) = -1;

Q3534= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q534(I,J)==1)
       
        Q3534(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3534(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3534(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q534(I,J)==-1)
            
            Q3534(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3534(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3534(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
        posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3534t = transpose(Q3534);

%34-14;

for y=1:26
    Q3414(y,MATRIZTOP(y,1)/10) = 1;
    Q3414(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3414(27,34) = 1;
Q3414(27,36) = -1;
Q3414(28,36) = 1;
Q3414(28,14) = -1;

for k=28:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3414(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3414(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q3414(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3414(36,1) = -1;

Q33414= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3414(I,J)==1)
       
        Q33414(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33414(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33414(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3414(I,J)==-1)
            
            Q33414(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33414(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33414(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33414t = transpose(Q33414);

%34-15

for y=1:27
    Q3415(y,MATRIZTOP(y,1)/10) = 1;
    Q3415(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3415(28,34) = 1;
Q3415(28,36) = -1;
Q3415(29,36) = 1;
Q3415(29,14) = -1;

for k=29:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3415(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3415(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q3415(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3415(36,1) = -1;

Q33415= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3415(I,J)==1)
       
        Q33415(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33415(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33415(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3415(I,J)==-1)
            
            Q33415(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33415(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33415(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33415t = transpose(Q33415);

%34-16

for y=1:28
    Q3416(y,MATRIZTOP(y,1)/10) = 1;
    Q3416(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3416(29,34) = 1;
Q3416(29,36) = -1;
Q3416(30,36) = 1;
Q3416(30,16) = -1;

for k=30:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q3416(k+1,MATRIZTOP(k,1)/10) = 1;
    Q3416(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q3416(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3416(36,1) = -1;

Q33416= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3416(I,J)==1)
       
        Q33416(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33416(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33416(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3416(I,J)==-1)
            
            Q33416(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33416(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33416(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33416t = transpose(Q33416);

%16-17

for y=1:29
    Q1617(y,MATRIZTOP(y,1)/10) = 1;
    Q1617(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q1617(30,16) = 1;
Q1617(30,36) = -1;
Q1617(31,36) = 1;
Q1617(31,17) = -1;

for k=31:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q1617(k+1,MATRIZTOP(k,1)/10) = 1;
    Q1617(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q1617(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q1617(36,1) = -1;

Q31617= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q1617(I,J)==1)
       
        Q31617(posicaoKiQ,posicaoKjdaQ)= 1;
        Q31617(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q31617(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        Q31617(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q31617t = transpose(Q31617);

%16-18

for y=1:30
    Q1618(y,MATRIZTOP(y,1)/10) = 1;
    Q1618(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q1618(31,16) = 1;
Q1618(31,36) = -1;
Q1618(32,36) = 1;
Q1618(32,18) = -1;

for k=32:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q1618(k+1,MATRIZTOP(k,1)/10) = 1;
    Q1618(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q1618(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q1618(36,1) = -1;

Q31618= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q1618(I,J)==1)
       
        Q31618(posicaoKiQ,posicaoKjdaQ)= 1;
        Q31618(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q31618(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q1618(I,J)==-1)
            
            Q31618(posicaoKiQ,posicaoKjdaQ)= -1;
        Q31618(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q31618(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q31618t = transpose(Q31618);

%6-26

for y=1:31
    Q626(y,MATRIZTOP(y,1)/10) = 1;
    Q626(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q626(32,6) = 1;
Q626(32,36) = -1;
Q626(33,36) = 1;
Q626(33,26) = -1;

for k=33:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q626(k+1,MATRIZTOP(k,1)/10) = 1;
    Q626(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q626(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q626(36,1) = -1;

Q3626= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q626(I,J)==1)
       
        Q3626(posicaoKiQ,posicaoKjdaQ)= 1;
        Q3626(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q3626(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q626(I,J)==-1)
            
            Q3626(posicaoKiQ,posicaoKjdaQ)= -1;
        Q3626(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q3626(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q3626t = transpose(Q3626);

%28-29

for y=1:32
    Q2829(y,MATRIZTOP(y,1)/10) = 1;
    Q2829(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q2829(33,28) = 1;
Q2829(33,36) = -1;
Q2829(34,36) = 1;
Q2829(34,29) = -1;

for k=34:size(MATRIZTOP,1)
  %Gerar matriz de incidência
    Q2829(k+1,MATRIZTOP(k,1)/10) = 1;
    Q2829(k+1,MATRIZTOP(k,2)/10) = -1;
  
end

iteration = 3;
for p = 2 : 36
    Q2829(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q2829(36,1) = -1;

Q32829= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q2829(I,J)==1)
       
        Q32829(posicaoKiQ,posicaoKjdaQ)= 1;
        Q32829(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q32829(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q2829(I,J)==-1)
            
            Q32829(posicaoKiQ,posicaoKjdaQ)= -1;
        Q32829(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q32829(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q32829t = transpose(Q32829);

%30-31

for y=1:33
    Q3031(y,MATRIZTOP(y,1)/10) = 1;
    Q3031(y,MATRIZTOP(y,2)/10) = -1;
    
end

Q3031(34,28) = 1;
Q3031(34,36) = -1;
Q3031(35,36) = 1;
Q3031(35,29) = -1;

iteration = 3;
for p = 2 : 36
    Q3031(iteration + 34, p) = 1;
    iteration = iteration + 1;
end
Q3031(36,1) = -1;

Q33031= zeros(213,108);
posicaoKiQ=1;
posicaoKjdaQ=1;
for I=1:71
    for J=1:36
        if(Q3031(I,J)==1)
       
        Q33031(posicaoKiQ,posicaoKjdaQ)= 1;
        Q33031(posicaoKiQ+1,posicaoKjdaQ+1)=1;
        Q33031(posicaoKiQ+2,posicaoKjdaQ+2)=1;
        
        end
        if(Q3031(I,J)==-1)
            
            Q33031(posicaoKiQ,posicaoKjdaQ)= -1;
        Q33031(posicaoKiQ+1,posicaoKjdaQ+1)=-1;
        Q33031(posicaoKiQ+2,posicaoKjdaQ+2)=-1;
          
        end
        posicaoKjdaQ=3*J+1;
    end
    posicaoKjdaQ=1;
    posicaoKiQ=3*I+1;
end

Q33031t = transpose(Q33031);

funcao= Inf;


MatrizDasCorrentes = zeros(108,1);
for l=1:108
    if(l==1)
        MatrizDasCorrentes(l,1) = Ia;
    end
    if(l==2)
        MatrizDasCorrentes(l,1) = Ib;
    end
    if(l==3)
        MatrizDasCorrentes(l,1) = Ic;
    end
    if(l>3)
        MatrizDasCorrentes(l,1) = 0;
    end
end

%a partir daqui nós realizamos a criação das matrizes de admitâncias,
%através dos dados forncedidos, e ao final, fazemos com que a matriz
%Yprimtiva que é 4D inicialmente, se torne 2D através do comando reshape do
%matlab, para que assim, seja possivel fazer a operação do enunciado que
%envolve a matriz inversa das admitancias primitivas, a propria matriz de
%admitancia primtiiva e a matriz de incidências para obtermos, finalmente,
%a matriz Ynós (YBUS)

for (contador_de_iteracoes=1:10)
    
    E10med = [0;0;0];
    E10MED = [0;0;0];
    E10med = [Emedido(contador_de_iteracoes,2) +1i*(Emedido(contador_de_iteracoes,3));Emedido(contador_de_iteracoes,4) +1i*(Emedido(contador_de_iteracoes,5));Emedido(contador_de_iteracoes,6) +1i*(Emedido(contador_de_iteracoes,7))];
    E10MED(1,1) = E10med(1,1)+E10med(1,2);
    E10MED(2,1) = E10med(2,1)+E10med(2,2);
    E10MED(3,1) = E10med(3,1)+E10med(3,2);
    funcao = Inf;
    funcao_para_RF = Inf;
    %10-20
    for (x=1:MATRIZTOP(1,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)           
                                if(posicaoMatrizdatpologia == 1)
                                    matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 2)
                                    matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 2)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia == 1)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 2)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 2)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho(1,1), matrizYdoTrecho(1,2), matrizYdoTrecho(1,3); matrizYdoTrecho(2,1), matrizYdoTrecho(2,2), matrizYdoTrecho(2,3); matrizYdoTrecho(3,1), matrizYdoTrecho(3,2), matrizYdoTrecho(3,3)];
             end 

             Yprimitiva = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M = reshape(permute(Yprimitiva,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3t*matrizYPrimitiva_M)*Q3);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));
                %aqui nós fazemos a comparação com a função de otimização
                %fornecida no enunciado pelos professores para que seja
                %possível encontrar em qual nó está a falta, e também a sua
                %respectiva impedância, e obviamente a sua distância x
                %realizamos isso em todos os trechos de cada caso
             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 1;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end

    %aqui acontece a obtençao dos dados para uma tabela no excel assim como
    %foi especificado no enunciado do exercicio programa
    fprintf (OUT,'%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,10 ,20 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
%20-30
    for (x=1:MATRIZTOP(2,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 2)
                                    matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 2)
                                    matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 3)
                                    matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 3)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho2(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho2(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 2)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 2)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 3)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 3)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho2(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena2 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho2(1,1), matrizYdoTrecho2(1,2), matrizYdoTrecho2(1,3); matrizYdoTrecho2(2,1), matrizYdoTrecho2(2,2), matrizYdoTrecho2(2,3); matrizYdoTrecho2(3,1), matrizYdoTrecho2(3,2), matrizYdoTrecho2(3,3)];
             end 

             Yprimitiva2 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva2(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena2(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva2(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M2 = reshape(permute(Yprimitiva2,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q323t*matrizYPrimitiva_M2)*Q323);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 2;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end 
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,20 ,30 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    
    %30-40
    
    for (x=1:MATRIZTOP(3,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 3)
                                    matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 3)
                                    matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 4)
                                    matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 4)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho3(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho3(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 3)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 3)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 4)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 4)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho3(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena3 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho3(1,1), matrizYdoTrecho3(1,2), matrizYdoTrecho3(1,3); matrizYdoTrecho3(2,1), matrizYdoTrecho3(2,2), matrizYdoTrecho3(2,3); matrizYdoTrecho3(3,1), matrizYdoTrecho3(3,2), matrizYdoTrecho3(3,3)];
             end 

             Yprimitiva3 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva3(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena3(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva3(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M3 = reshape(permute(Yprimitiva3,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q334t*matrizYPrimitiva_M3)*Q334);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 3;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end 
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,30 ,40 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
%40-50

    for (x=1:MATRIZTOP(4,3)-1)
        for rf =0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 4)
                                    matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 4)
                                    matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 5)
                                    matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 5)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho4(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho4(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 4)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 4)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 5)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 5)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho4(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena4 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho4(1,1), matrizYdoTrecho4(1,2), matrizYdoTrecho4(1,3); matrizYdoTrecho4(2,1), matrizYdoTrecho4(2,2), matrizYdoTrecho4(2,3); matrizYdoTrecho4(3,1), matrizYdoTrecho4(3,2), matrizYdoTrecho4(3,3)];
             end 

             Yprimitiva4 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva4(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena4(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva4(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M4 = reshape(permute(Yprimitiva4,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q345t*matrizYPrimitiva_M4)*Q345);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 4;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end

    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,40 ,50 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %50-60
    
    for (x=1:MATRIZTOP(5,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 5)
                                    matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 5)
                                    matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 6)
                                    matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 6)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho5(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho5(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 5)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 5)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 6)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 6)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho5(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena5 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho5(1,1), matrizYdoTrecho5(1,2), matrizYdoTrecho5(1,3); matrizYdoTrecho5(2,1), matrizYdoTrecho5(2,2), matrizYdoTrecho5(2,3); matrizYdoTrecho5(3,1), matrizYdoTrecho5(3,2), matrizYdoTrecho5(3,3)];
             end 

             Yprimitiva5 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva5(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena5(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva5(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M5 = reshape(permute(Yprimitiva5,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q356t*matrizYPrimitiva_M5)*Q356);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 5;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,50 ,60 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    
    %60-70
    
    for (x=1:MATRIZTOP(6,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 6)
                                    matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 6)
                                    matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 7)
                                    matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 7)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho6(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho6(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 6)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 6)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 7)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 7)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho6(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena6 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho6(1,1), matrizYdoTrecho6(1,2), matrizYdoTrecho6(1,3); matrizYdoTrecho6(2,1), matrizYdoTrecho6(2,2), matrizYdoTrecho6(2,3); matrizYdoTrecho6(3,1), matrizYdoTrecho6(3,2), matrizYdoTrecho6(3,3)];
             end 

             Yprimitiva6 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva6(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena6(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva6(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M6 = reshape(permute(Yprimitiva6,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q367t*matrizYPrimitiva_M6)*Q367);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 6;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,60 ,70 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %70=270
    
    for (x=1:MATRIZTOP(7,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 7)
                                    matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 7)
                                    matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 8)
                                    matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 8)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho7(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho7(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 7)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 7)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 8)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 8)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho7(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena7 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho7(1,1), matrizYdoTrecho7(1,2), matrizYdoTrecho7(1,3); matrizYdoTrecho7(2,1), matrizYdoTrecho7(2,2), matrizYdoTrecho7(2,3); matrizYdoTrecho7(3,1), matrizYdoTrecho7(3,2), matrizYdoTrecho7(3,3)];
             end 

             Yprimitiva7 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva7(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena7(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva7(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M7 = reshape(permute(Yprimitiva7,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3727t*matrizYPrimitiva_M7)*Q3727);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 7;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,70 ,270 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %27-28
    
     for (x=1:MATRIZTOP(8,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 8)
                                    matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 8)
                                    matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 9)
                                    matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 9)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho8(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho8(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 8)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 8)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 9)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 9)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho8(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena8 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho8(1,1), matrizYdoTrecho8(1,2), matrizYdoTrecho8(1,3); matrizYdoTrecho8(2,1), matrizYdoTrecho8(2,2), matrizYdoTrecho8(2,3); matrizYdoTrecho8(3,1), matrizYdoTrecho8(3,2), matrizYdoTrecho8(3,3)];
             end 

             Yprimitiva8 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva8(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena8(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva8(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M8 = reshape(permute(Yprimitiva8,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32728t*matrizYPrimitiva_M8)*Q32728);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 8;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,270 ,280 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );

     funcao_para_RF = Inf;
    %28-30
    
    for (x=1:MATRIZTOP(9,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 9)
                                    matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 9)
                                    matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 10)
                                    matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 10)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho9(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho9(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 9)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 9)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 10)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 10)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho9(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena9 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho9(1,1), matrizYdoTrecho9(1,2), matrizYdoTrecho9(1,3); matrizYdoTrecho9(2,1), matrizYdoTrecho9(2,2), matrizYdoTrecho9(2,3); matrizYdoTrecho9(3,1), matrizYdoTrecho9(3,2), matrizYdoTrecho9(3,3)];
             end 

             Yprimitiva9 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva9(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena9(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva9(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M9 = reshape(permute(Yprimitiva9,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32830t*matrizYPrimitiva_M9)*Q32830);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 9;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,280 ,300 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %30-32
    
    for (x=1:MATRIZTOP(10,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 10)
                                    matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 10)
                                    matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 11)
                                    matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 11)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho10(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho10(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 10)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 10)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 11)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 11)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho10(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena10 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho10(1,1), matrizYdoTrecho10(1,2), matrizYdoTrecho10(1,3); matrizYdoTrecho10(2,1), matrizYdoTrecho10(2,2), matrizYdoTrecho10(2,3); matrizYdoTrecho10(3,1), matrizYdoTrecho10(3,2), matrizYdoTrecho10(3,3)];
             end 

             Yprimitiva10 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva10(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena10(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva10(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M10 = reshape(permute(Yprimitiva10,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33032t*matrizYPrimitiva_M10)*Q33032);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 10;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,300 ,320 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %3-35
    
    for (x=1:MATRIZTOP(11,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 11)
                                    matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 11)
                                    matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 12)
                                    matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 12)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho11(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho11(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 11)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 11)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 12)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 12)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho11(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena11 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho11(1,1), matrizYdoTrecho11(1,2), matrizYdoTrecho11(1,3); matrizYdoTrecho11(2,1), matrizYdoTrecho11(2,2), matrizYdoTrecho11(2,3); matrizYdoTrecho11(3,1), matrizYdoTrecho11(3,2), matrizYdoTrecho11(3,3)];
             end 

             Yprimitiva11 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva11(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena11(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva11(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M11 = reshape(permute(Yprimitiva11,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3335t*matrizYPrimitiva_M11)*Q3335);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 11;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,30 ,350 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
      %35-8
    for (x=1:MATRIZTOP(12,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 12)
                                    matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 12)
                                    matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 13)
                                    matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 13)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho12(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho12(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 12)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 12)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 13)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 13)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho12(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena12 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho12(1,1), matrizYdoTrecho12(1,2), matrizYdoTrecho12(1,3); matrizYdoTrecho12(2,1), matrizYdoTrecho12(2,2), matrizYdoTrecho12(2,3); matrizYdoTrecho12(3,1), matrizYdoTrecho12(3,2), matrizYdoTrecho12(3,3)];
             end 

             Yprimitiva12 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva12(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena12(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva12(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M12 = reshape(permute(Yprimitiva12,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3358t*matrizYPrimitiva_M12)*Q3358);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 12;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,350 ,80 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %35-9
    
    for (x=1:MATRIZTOP(13,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 13)
                                    matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 13)
                                    matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 14)
                                    matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 14)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho13(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho13(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 13)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 13)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 14)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 14)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho13(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena13 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho13(1,1), matrizYdoTrecho13(1,2), matrizYdoTrecho13(1,3); matrizYdoTrecho13(2,1), matrizYdoTrecho13(2,2), matrizYdoTrecho13(2,3); matrizYdoTrecho13(3,1), matrizYdoTrecho13(3,2), matrizYdoTrecho13(3,3)];
             end 

             Yprimitiva13 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva13(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena13(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva13(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M13 = reshape(permute(Yprimitiva13,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3359t*matrizYPrimitiva_M13)*Q3359);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 13;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,350 ,90 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %35-10
    
    for (x=1:MATRIZTOP(14,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 14)
                                    matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 14)
                                    matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 15)
                                    matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 15)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho14(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho14(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 14)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 14)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 15)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 15)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho14(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena14 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho14(1,1), matrizYdoTrecho14(1,2), matrizYdoTrecho14(1,3); matrizYdoTrecho14(2,1), matrizYdoTrecho14(2,2), matrizYdoTrecho14(2,3); matrizYdoTrecho14(3,1), matrizYdoTrecho14(3,2), matrizYdoTrecho14(3,3)];
             end 

             Yprimitiva14 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva14(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena14(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva14(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M14 = reshape(permute(Yprimitiva14,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33510t*matrizYPrimitiva_M14)*Q33510);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
            E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 14;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,350 ,100 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %4-13
    
    for (x=1:MATRIZTOP(15,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 15)
                                    matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 15)
                                    matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 16)
                                    matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 16)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho15(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho15(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 15)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 15)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 16)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 16)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho15(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena15 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho15(1,1), matrizYdoTrecho15(1,2), matrizYdoTrecho15(1,3); matrizYdoTrecho15(2,1), matrizYdoTrecho15(2,2), matrizYdoTrecho15(2,3); matrizYdoTrecho15(3,1), matrizYdoTrecho15(3,2), matrizYdoTrecho15(3,3)];
             end 

             Yprimitiva15 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva15(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena15(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva15(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M15 = reshape(permute(Yprimitiva15,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3413t*matrizYPrimitiva_M15)*Q3413);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros()
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 15;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,40 ,130 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %5-19
    
    for (x=1:MATRIZTOP(16,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 16)
                                    matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 16)
                                    matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 17)
                                    matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 17)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho16(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho16(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 16)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 16)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 17)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 17)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho16(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena16 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho16(1,1), matrizYdoTrecho16(1,2), matrizYdoTrecho16(1,3); matrizYdoTrecho16(2,1), matrizYdoTrecho16(2,2), matrizYdoTrecho16(2,3); matrizYdoTrecho16(3,1), matrizYdoTrecho16(3,2), matrizYdoTrecho16(3,3)];
             end 

             Yprimitiva16 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva16(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena16(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva16(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M16 = reshape(permute(Yprimitiva16,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3519t*matrizYPrimitiva_M16)*Q3519);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 16;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    fprintf (OUT,'%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,50 ,190 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %19-20
    
    for (x=1:MATRIZTOP(17,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 17)
                                    matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia,3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end
                                if(posicaoMatrizdatpologia == 17)
                                    matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 18)
                                    matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 18)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho17(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho17(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                                if(posicaoMatrizdatpologia < 17)
                                   if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                   end
                                   if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                   end
                                   if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                   end
                                   if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                   end
                                    
                                end
                                if(posicaoMatrizdatpologia == 17)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 18)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 18)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho17(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                    
                    
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena17 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho17(1,1), matrizYdoTrecho17(1,2), matrizYdoTrecho17(1,3); matrizYdoTrecho17(2,1), matrizYdoTrecho17(2,2), matrizYdoTrecho17(2,3); matrizYdoTrecho17(3,1), matrizYdoTrecho17(3,2), matrizYdoTrecho17(3,3)];
             end 

             Yprimitiva17 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva17(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena17(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva17(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M17 = reshape(permute(Yprimitiva17,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q31920t*matrizYPrimitiva_M17)*Q31920);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 17;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
    end
    
    fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,190 ,200 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %trecho 18
    
     for (x=1:MATRIZTOP(18,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 18)
                                    matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 18)
                                    matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 19)
                                    matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 19)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho18(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho18(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 18)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 18)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 19)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 19)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho18(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena18 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho18(1,1), matrizYdoTrecho18(1,2), matrizYdoTrecho18(1,3); matrizYdoTrecho18(2,1), matrizYdoTrecho18(2,2), matrizYdoTrecho18(2,3); matrizYdoTrecho18(3,1), matrizYdoTrecho18(3,2), matrizYdoTrecho18(3,3)];
             end 

             Yprimitiva18 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva18(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena18(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva18(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M18 = reshape(permute(Yprimitiva18,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q31921t*matrizYPrimitiva_M18)*Q31921);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 18;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
    
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,190 ,210 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;


% trecho 19 210-220

     for (x=1:MATRIZTOP(19,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 19)
                                    matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 19)
                                    matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 20)
                                    matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 20)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho19(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35))
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho19(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf)
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 19)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 19)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 20)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 20)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho19(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena19 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho19(1,1), matrizYdoTrecho19(1,2), matrizYdoTrecho19(1,3); matrizYdoTrecho19(2,1), matrizYdoTrecho19(2,2), matrizYdoTrecho19(2,3); matrizYdoTrecho19(3,1), matrizYdoTrecho19(3,2), matrizYdoTrecho19(3,3)];
             end 

             Yprimitiva19 = zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva19(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena19(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva19(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M19 = reshape(permute(Yprimitiva19,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32122t*matrizYPrimitiva_M19)*Q32122);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 19;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,210 ,220 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
 % trecho 20 - trecho 210 230
    
     for (x=1:MATRIZTOP(20,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 20)
                                    matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 20)
                                    matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 21)
                                    matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 21)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho20(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho20(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 20)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 20)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 21)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 21)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho20(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena20 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho20(1,1), matrizYdoTrecho20(1,2), matrizYdoTrecho20(1,3); matrizYdoTrecho20(2,1), matrizYdoTrecho20(2,2), matrizYdoTrecho20(2,3); matrizYdoTrecho20(3,1), matrizYdoTrecho20(3,2), matrizYdoTrecho20(3,3)];
             end 

             Yprimitiva20= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva20(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena20(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva20(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M20 = reshape(permute(Yprimitiva20,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32123t*matrizYPrimitiva_M20)*Q32123);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 20;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,210 ,230 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
  
 %trecho 21 230-240
 
     for (x=1:MATRIZTOP(21,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 21)
                                    matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 21)
                                    matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 22)
                                    matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 22)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho21(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho21(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 21)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 21)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 22)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 22)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho21(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena21 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho21(1,1), matrizYdoTrecho21(1,2), matrizYdoTrecho21(1,3); matrizYdoTrecho21(2,1), matrizYdoTrecho21(2,2), matrizYdoTrecho21(2,3); matrizYdoTrecho21(3,1), matrizYdoTrecho21(3,2), matrizYdoTrecho21(3,3)];
             end 

             Yprimitiva21= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva21(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena21(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva21(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M21 = reshape(permute(Yprimitiva21,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32324t*matrizYPrimitiva_M21)*Q32324);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                Trecho_Com_Erro = 21;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,230 ,240 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    
%trecho 22 230-250
 
     for (x=1:MATRIZTOP(22,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 22)
                                    matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 22)
                                    matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 23)
                                    matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 23)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho22(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho22(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 22)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 22)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 23)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 23)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho22(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena22 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho22(1,1), matrizYdoTrecho22(1,2), matrizYdoTrecho22(1,3); matrizYdoTrecho22(2,1), matrizYdoTrecho22(2,2), matrizYdoTrecho22(2,3); matrizYdoTrecho22(3,1), matrizYdoTrecho22(3,2), matrizYdoTrecho22(3,3)];
             end 

             Yprimitiva22= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva22(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena22(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva22(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M22 = reshape(permute(Yprimitiva22,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32325t*matrizYPrimitiva_M22)*Q32325);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 22;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,230 ,250 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    
 
 
% trecho 23    020 - 330

     for (x=1:MATRIZTOP(23,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 23)
                                    matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 23)
                                    matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 24)
                                    matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 24)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho23(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho23(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 23)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 23)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 24)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 24)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho23(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena23 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho23(1,1), matrizYdoTrecho23(1,2), matrizYdoTrecho23(1,3); matrizYdoTrecho23(2,1), matrizYdoTrecho23(2,2), matrizYdoTrecho23(2,3); matrizYdoTrecho23(3,1), matrizYdoTrecho23(3,2), matrizYdoTrecho23(3,3)];
             end 

             Yprimitiva23= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva23(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena23(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva23(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M23 = reshape(permute(Yprimitiva23,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3233t*matrizYPrimitiva_M23)*Q3233);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 23;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,20 ,330 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );

    funcao_para_RF = Inf;
 
 % trecho 24 330 - 110
     for (x=1:MATRIZTOP(24,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 24)
                                    matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 24)
                                    matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 25)
                                    matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 25)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho24(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho24(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 24)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 24)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 25)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 25)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho24(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena24 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho24(1,1), matrizYdoTrecho24(1,2), matrizYdoTrecho24(1,3); matrizYdoTrecho24(2,1), matrizYdoTrecho24(2,2), matrizYdoTrecho24(2,3); matrizYdoTrecho24(3,1), matrizYdoTrecho24(3,2), matrizYdoTrecho24(3,3)];
             end 

             Yprimitiva24= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva24(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena24(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva24(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M24 = reshape(permute(Yprimitiva24,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33311t*matrizYPrimitiva_M24)*Q33311);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 24;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,330 ,110 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
 % trecho 25 330 - 120
     for (x=1:MATRIZTOP(25,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 25)
                                    matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 25)
                                    matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 26)
                                    matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 26)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho25(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho25(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 25)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 25)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 26)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 26)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho25(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena25 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho25(1,1), matrizYdoTrecho25(1,2), matrizYdoTrecho25(1,3); matrizYdoTrecho25(2,1), matrizYdoTrecho25(2,2), matrizYdoTrecho25(2,3); matrizYdoTrecho25(3,1), matrizYdoTrecho25(3,2), matrizYdoTrecho25(3,3)];
             end 

             Yprimitiva25= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva25(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena25(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva25(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M25 = reshape(permute(Yprimitiva25,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33312t*matrizYPrimitiva_M25)*Q33312);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 25;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,330 ,120 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
 % trecho 26 050 - 340
     for (x=1:MATRIZTOP(26,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 26)
                                    matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 26)
                                    matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 27)
                                    matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 27)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho26(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho26(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 26)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 26)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 27)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 27)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho26(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena26 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho26(1,1), matrizYdoTrecho26(1,2), matrizYdoTrecho26(1,3); matrizYdoTrecho26(2,1), matrizYdoTrecho26(2,2), matrizYdoTrecho26(2,3); matrizYdoTrecho26(3,1), matrizYdoTrecho26(3,2), matrizYdoTrecho26(3,3)];
             end 

             Yprimitiva26= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva26(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena26(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva26(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M26 = reshape(permute(Yprimitiva26,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3534t*matrizYPrimitiva_M26)*Q3534);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 26;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,50 ,340 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
     
     %trecho 27 340-140
     
     for (x=1:MATRIZTOP(27,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 27)
                                    matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 27)
                                    matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 28)
                                    matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 28)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho27(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho27(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 27)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 27)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 28)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 28)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho27(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena27 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho27(1,1), matrizYdoTrecho27(1,2), matrizYdoTrecho27(1,3); matrizYdoTrecho27(2,1), matrizYdoTrecho27(2,2), matrizYdoTrecho27(2,3); matrizYdoTrecho27(3,1), matrizYdoTrecho27(3,2), matrizYdoTrecho27(3,3)];
             end 

             Yprimitiva27= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva27(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena27(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva27(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M27 = reshape(permute(Yprimitiva27,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33414t*matrizYPrimitiva_M27)*Q33414);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 27;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end

     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,340 ,140 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
%trecho 28 340-150
     
     for (x=1:MATRIZTOP(28,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 28)
                                    matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 28)
                                    matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 29)
                                    matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 29)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho28(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho28(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 28)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 28)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 29)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 29)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho28(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena28 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho28(1,1), matrizYdoTrecho28(1,2), matrizYdoTrecho28(1,3); matrizYdoTrecho28(2,1), matrizYdoTrecho28(2,2), matrizYdoTrecho28(2,3); matrizYdoTrecho28(3,1), matrizYdoTrecho28(3,2), matrizYdoTrecho28(3,3)];
             end 

             Yprimitiva28= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva28(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena28(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva28(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M28 = reshape(permute(Yprimitiva28,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33415t*matrizYPrimitiva_M28)*Q33415);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 28;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end     
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,340 ,150 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;

     
     %trecho 29 340-160
     
     for (x=1:MATRIZTOP(29,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 29)
                                    matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 29)
                                    matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 30)
                                    matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 30)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho29(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho29(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 29)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 29)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 30)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 30)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho29(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena29 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho29(1,1), matrizYdoTrecho29(1,2), matrizYdoTrecho29(1,3); matrizYdoTrecho29(2,1), matrizYdoTrecho29(2,2), matrizYdoTrecho29(2,3); matrizYdoTrecho29(3,1), matrizYdoTrecho29(3,2), matrizYdoTrecho29(3,3)];
             end 

             Yprimitiva29= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva29(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena29(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva29(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M29 = reshape(permute(Yprimitiva29,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33416t*matrizYPrimitiva_M29)*Q33416);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 29;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end

     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,340 ,160 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
 
     %trecho 30 160-170
     
     for (x=1:MATRIZTOP(30,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 30)
                                    matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 30)
                                    matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 31)
                                    matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 31)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho30(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho30(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 30)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 30)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 31)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 31)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho30(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena30 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho30(1,1), matrizYdoTrecho30(1,2), matrizYdoTrecho30(1,3); matrizYdoTrecho30(2,1), matrizYdoTrecho30(2,2), matrizYdoTrecho30(2,3); matrizYdoTrecho30(3,1), matrizYdoTrecho30(3,2), matrizYdoTrecho30(3,3)];
             end 

             Yprimitiva30= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva30(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena30(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva30(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M30 = reshape(permute(Yprimitiva30,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q31617t*matrizYPrimitiva_M30)*Q31617);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 30;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end

     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,160 ,170 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
    %trecho 31 160-180
     
     for (x=1:MATRIZTOP(31,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 31)
                                    matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 31)
                                    matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 32)
                                    matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 32)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho31(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho31(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 31)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 31)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 32)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 32)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho31(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena31 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho31(1,1), matrizYdoTrecho31(1,2), matrizYdoTrecho31(1,3); matrizYdoTrecho31(2,1), matrizYdoTrecho31(2,2), matrizYdoTrecho31(2,3); matrizYdoTrecho31(3,1), matrizYdoTrecho31(3,2), matrizYdoTrecho31(3,3)];
             end 

             Yprimitiva31= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva31(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena31(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva31(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M31 = reshape(permute(Yprimitiva31,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q31618t*matrizYPrimitiva_M31)*Q31618);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 31;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
      end    

      fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,160 ,180 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
      %trecho 32 060-260 
     for (x=1:MATRIZTOP(32,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 32)
                                    matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 32)
                                    matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 33)
                                    matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 33)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho32(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho32(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 32)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 32)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 33)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 33)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho32(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena32 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho32(1,1), matrizYdoTrecho32(1,2), matrizYdoTrecho32(1,3); matrizYdoTrecho32(2,1), matrizYdoTrecho32(2,2), matrizYdoTrecho32(2,3); matrizYdoTrecho32(3,1), matrizYdoTrecho32(3,2), matrizYdoTrecho32(3,3)];
             end 

             Yprimitiva32= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva32(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena32(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva32(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M32 = reshape(permute(Yprimitiva32,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q3626t*matrizYPrimitiva_M32)*Q3626);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 32;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end    

     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,60 ,260 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
    funcao_para_RF = Inf;
   %trecho 33 280-290
     for (x=1:MATRIZTOP(33,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 33)
                                    matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 33)
                                    matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 34)
                                    matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 34)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho33(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho33(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 33)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 33)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 34)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 34)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho33(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena33 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho33(1,1), matrizYdoTrecho33(1,2), matrizYdoTrecho33(1,3); matrizYdoTrecho33(2,1), matrizYdoTrecho33(2,2), matrizYdoTrecho33(2,3); matrizYdoTrecho33(3,1), matrizYdoTrecho33(3,2), matrizYdoTrecho33(3,3)];
             end 

             Yprimitiva33= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva33(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena33(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva33(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M33 = reshape(permute(Yprimitiva33,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q32829t*matrizYPrimitiva_M33)*Q32829);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));

             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 33;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
     end  
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,280 ,290 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );

     funcao_para_RF = Inf;
     %trecho 34 300-310
     for (x=1:MATRIZTOP(34,3)-1)
        for rf = 0.1:0.1:10
             for posicaoMatrizdatpologia = 1 : 71
                for LinhaMatrizpequena = 1 : 3
                    for colunaMatrizpequena = 1 : 3
                           if (LinhaMatrizpequena == colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 34)
                                    matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                               end
                               
                                if(posicaoMatrizdatpologia == 34)
                                    matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( x*(MATRIZTOP(posicaoMatrizdatpologia, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                if(posicaoMatrizdatpologia == 35)
                                    matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                end  
                                %a partir do trecho que liga o nó pai ao F, posicaoMatrizdatpologia-1%
                                if(posicaoMatrizdatpologia > 35)
                                    if(posicaoMatrizdatpologia <= 35)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*(MATRIZTOP(posicaoMatrizdatpologia-1, 4 + 8*(LinhaMatrizpequena-1)) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 5 + 8*(LinhaMatrizpequena-1))));
                                    end
                                    if(posicaoMatrizdatpologia > 35 && posicaoMatrizdatpologia < 71)
                                        matrizYdoTrecho34(LinhaMatrizpequena,colunaMatrizpequena) = inv(Z(posicaoMatrizdatpologia - 35));
                                    end
                                    if(posicaoMatrizdatpologia == 71)
                                        matrizYdoTrecho34(LinhaMatrizpequena,colunaMatrizpequena) = inv(rf);
                                    end
                                end
                           end
                           if(LinhaMatrizpequena ~= colunaMatrizpequena)
                               if (posicaoMatrizdatpologia < 34)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia, 3)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                               end
                               
                                if(posicaoMatrizdatpologia == 34)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (x)*( MATRIZTOP(posicaoMatrizdatpologia, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia, 19)));
                                    end
                                end
                                if(posicaoMatrizdatpologia == 35)
                                    if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                    end
                                    if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                    end
                                    if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv((MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                    end
                                    if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                        matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( (MATRIZTOP(posicaoMatrizdatpologia-1, 3)-x)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                    end
                                end
                    
                                if(posicaoMatrizdatpologia > 35)
                                    if (posicaoMatrizdatpologia <= 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 6) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 7)));
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 8) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 9)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 10) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 11)));
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                            matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 14) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 15)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                            matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 16) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 17)));
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                            matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = inv( MATRIZTOP(posicaoMatrizdatpologia-1, 3)*( MATRIZTOP(posicaoMatrizdatpologia-1, 18) + 1i*MATRIZTOP(posicaoMatrizdatpologia-1, 19)));
                                        end
                                    end
                                    if (posicaoMatrizdatpologia > 35)
                                        if(LinhaMatrizpequena == 1 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 1 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 2 && colunaMatrizpequena == 3)
                                             matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 1)
                                             matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                                        if (LinhaMatrizpequena == 3 && colunaMatrizpequena == 2)
                                             matrizYdoTrecho34(LinhaMatrizpequena, colunaMatrizpequena) = 0;
                                        end
                   
                                    end
                                end    
                           end
                    end
                end
    
                matrizYpequena34 (:,:,posicaoMatrizdatpologia) = [matrizYdoTrecho34(1,1), matrizYdoTrecho34(1,2), matrizYdoTrecho34(1,3); matrizYdoTrecho34(2,1), matrizYdoTrecho34(2,2), matrizYdoTrecho34(2,3); matrizYdoTrecho34(3,1), matrizYdoTrecho34(3,2), matrizYdoTrecho34(3,3)];
             end 

             Yprimitiva34= zeros(3);

             for iterationTrechos = 1 : 71
                for iterationTrechusColunas = 1 : 71
                    if (iterationTrechos == iterationTrechusColunas) 
                        Yprimitiva34(:,:,iterationTrechos, iterationTrechusColunas) = matrizYpequena34(:, :, iterationTrechusColunas);
                    else
                        Yprimitiva34(:,:,iterationTrechos, iterationTrechusColunas) = 0;
                    end
        
                end
             end

             matrizYPrimitiva_M34 = reshape(permute(Yprimitiva34,[1,3,2,4]),213, 213);

             MatrizAdmitanciasBUS = ((Q33031t*matrizYPrimitiva_M34)*Q33031);


             MatrizTensao = inv(MatrizAdmitanciasBUS)*MatrizDasCorrentes;
    
             E10calc =zeros();
             E10calc = [MatrizTensao(1,1);MatrizTensao(2,1);MatrizTensao(3,1)];
             funcao_otimizacao_passoAnterior = (abs(E10MED(1,1) - E10calc(1,1)))./(abs(E10MED(1,1)))+(abs(E10MED(2,1) - E10calc(2,1)))./(abs(E10MED(2,1)))+(abs(E10MED(3,1) - E10calc(3,1)))./(abs(E10MED(3,1)));
             
             if (funcao_otimizacao_passoAnterior < funcao || rcalculado_antes <= 0.9)
                 Trecho_Com_Erro = 34;
                xcalculado_antes = x;
                rcalculado_antes = rf;
                funcao = funcao_otimizacao_passoAnterior;
             end
             
             funcao_para_RF_antes= funcao_otimizacao_passoAnterior;
             if (funcao_para_RF_antes < funcao_para_RF || resistenciaFalta_calculada <= 0.9)
                distanciaX_RF = x;
                resistenciaFalta_calculada = rf;
                funcao_para_RF = funcao_para_RF_antes;
             end
        end
        
    
     end
     
     fprintf (OUT, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,300 ,310 , distanciaX_RF , resistenciaFalta_calculada , funcao_para_RF );
     
     if (Trecho_Com_Erro == 1)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,10 ,20 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 2)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,20 ,30 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 3)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,30 ,40 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 4)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,40 ,50 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 5)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,50 ,60 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 6)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,60 ,70 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 7)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,70 ,270 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 8)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,270 ,280 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 9)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,280 ,300 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 10)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,300 ,320 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 11)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,30 ,350 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 12)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,350 ,80 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 13)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,350 ,90 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 14)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,350 ,100 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 15)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,40 ,130 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 16)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,50 ,190 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 17)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,190 ,200 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 18)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,190 ,210 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 19)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,210 ,220 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 20)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,210 ,230 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 21)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,230 ,240 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 22)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,230 ,250 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 23)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,20 ,330 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 24)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,330 ,110 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 25)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,330 ,120 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 26)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,50 ,340 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 27)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,340 ,140 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 28)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,340 ,150 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 29)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,340 ,160 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 30)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,160 ,170 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 31)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,160 ,180 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 32)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,60 ,260 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 33)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,280 ,290 , xcalculado_antes , rcalculado_antes , funcao );
     end
     if (Trecho_Com_Erro == 34)
        fprintf (REL, '%2.0f ,%3.0f,%2.0f ,%2.0f ,%2.1f ,%2.3f\n', contador_de_iteracoes ,300 ,310 , xcalculado_antes , rcalculado_antes , funcao );
     end

end
fclose(OUT)
fclose(REL)
     





