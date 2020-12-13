clear all; close all; clc
if ismac
    currentFolder = pwd;
    newFolder='COVID-19';
    csvfilesreg = dir('COVID-19/dati-regioni/*.csv');
elseif isunix
    currentFolder = pwd;
    newFolder='COVID-19';
    csvfilesreg = dir('COVID-19/dati-regioni/*.csv');
elseif ispc
    csvfilesreg = dir('COVID-19\dati-regioni\*.csv');
    newFolder='COVID-19';
else
    csvfilesreg = dir('COVID-19\dati-regioni\*.csv');
    newFolder='COVID-19';
end

if ~exist(newFolder, 'dir')
    !git clone git://github.com/pcm-dpc/COVID-19.git
else
    oldFolder = cd(newFolder);
    !git pull git://github.com/pcm-dpc/COVID-19.git
    cd(oldFolder);
end
if ismac
    currentFolder = pwd;
    newFolder='COVID-19';
    csvfilesreg = dir('COVID-19/dati-regioni/*.csv');
elseif isunix
    currentFolder = pwd;
    newFolder='COVID-19';
    csvfilesreg = dir('COVID-19/dati-regioni/*.csv');
elseif ispc
    csvfilesreg = dir('COVID-19\dati-regioni\*.csv');
    newFolder='COVID-19';
else
    csvfilesreg = dir('COVID-19\dati-regioni\*.csv');
    newFolder='COVID-19';
end

% csvfiles = dir('COVID-19\dati-regioni\*.csv');
addpath(genpath(newFolder))
csvfilesreg(end)=[];
csvfilesreg(end)=[];
k=0;
deceduti=zeros(1,length(csvfilesreg));
terapia_intensiva=zeros(1,length(csvfilesreg));
terapia_intensiva_giornaliera=zeros(1,length(csvfilesreg));
ricoverati_sintomatici=zeros(1,length(csvfilesreg));
isolamento_domiciliare=zeros(1,length(csvfilesreg));
totale_ospedalizzati=zeros(1,length(csvfilesreg));
guariti=zeros(1,length(csvfilesreg));
nuovi_attuali_positivi=zeros(1,length(csvfilesreg));
attuali_positivi=zeros(1,length(csvfilesreg));
totale_casi=zeros(1,length(csvfilesreg));
nuovi_casi=zeros(1,length(csvfilesreg));
nuovi_guariti=zeros(1,length(csvfilesreg));
nuovi_deceduti=zeros(1,length(csvfilesreg));
tamponi=zeros(1,length(csvfilesreg));
rapporto_infetti_su_tamponi=zeros(1,length(csvfilesreg));
tamponi_per_giorno=zeros(1,length(csvfilesreg));
differenza_infetti=zeros(1,length(csvfilesreg));
assex=zeros(1,length(csvfilesreg));
nomi=zeros(1,length(csvfilesreg));
% test=zeros(1,length(csvfiles));


for file = csvfilesreg'
    k=k+1;
    [data]=readmatrix(csvfilesreg(k).name,'Delimiter',',');
    nomi(k)=str2double(csvfilesreg(k).name(end-11:end-4));
    for i=1:length(data(:,1)) %data(1,3)= prima riga terza colonna. 7 ricoverati con sintomi, 8 terapia intensiva, 9 totale ospedalizzati, 10 isolamento domiciliare, 18 TOTALE CASI, 15 deceduti,14 guariti, 12(13?) nuovi attualmente positivi, 11 totale attualmente positivi, 19 numero tamponi fatti
        deceduti(k)=deceduti(k)+data(i,15);
        terapia_intensiva(k)=terapia_intensiva(k)+data(i,8);
        guariti(k)=guariti(k)+data(i,14);
        attuali_positivi(k)=attuali_positivi(k)+data(i,11);
        nuovi_attuali_positivi(k)=nuovi_attuali_positivi(k)+data(i,12);
        totale_casi(k)=totale_casi(k)+data(i,18);
        tamponi(k)=tamponi(k)+data(i,19);
        ricoverati_sintomatici(k)=ricoverati_sintomatici(k)+data(i,7);
        totale_ospedalizzati(k)=totale_ospedalizzati(k)+data(i,9);
        isolamento_domiciliare(k)=isolamento_domiciliare(k)+data(i,10);
        
    end
    assex(k)=k;
    
end

for l = 1:length(nuovi_casi())
    if l==1
        nuovi_casi(l)=totale_casi(l);
        nuovi_guariti(l)=guariti(l);
        nuovi_deceduti(l)=deceduti(l);
        tamponi_per_giorno(l)=tamponi(l);
        differenza_infetti(l)=nuovi_casi(l);
        terapia_intensiva_giornaliera(l)=terapia_intensiva(l);
        %         test(l)=100;
    else
        nuovi_casi(l)=totale_casi(l)-totale_casi(l-1);
        terapia_intensiva_giornaliera(l)=terapia_intensiva(l)-terapia_intensiva(l-1);
        nuovi_guariti(l)=guariti(l)-guariti(l-1);
        nuovi_deceduti(l)=deceduti(l)-deceduti(l-1);
        tamponi_per_giorno(l)=tamponi(l)-tamponi(l-1);
        differenza_infetti(l)=nuovi_casi(l)-nuovi_casi(l-1);
        %         test(l)=((diff_infetti(l))/nuovi_casi(l-1))*100;
    end
    rapporto_infetti_su_tamponi(l)=(nuovi_casi(l)*100)/tamponi_per_giorno(l);
end

%%RIASSUNTO SETTIMANALE
%%24/02/2020 primo report, lunedì

numero_di_settimane=fix(k/7);
giorni_rimanenti=(k/7-numero_di_settimane)*7;


if giorni_rimanenti == 0
    settimane_totali=numero_di_settimane;
else
    settimane_totali=numero_di_settimane+1;
end


Wdeceduti=zeros(1,settimane_totali);
Wguariti=zeros(1,settimane_totali);
Wattuali_positivi=zeros(1,settimane_totali);
Wnuovi_attuali=zeros(1,settimane_totali);
Wtotale_casi=zeros(1,settimane_totali);
Wtamponi=zeros(1,settimane_totali);
Wcasi_sintomatici=zeros(1,settimane_totali);
Wterapia_intensiva=zeros(1,settimane_totali);
Wtotale_ospedalizzati=zeros(1,settimane_totali);
Wisolamento_domiciliare=zeros(1,settimane_totali);

Wassex=zeros(1,length(settimane_totali));
last_index=1;
ending_index=7;

for jj=1:settimane_totali
    
    for kk=last_index:ending_index
        Wnuovi_attuali(jj)=Wnuovi_attuali(jj)+nuovi_attuali_positivi(kk);
        Wterapia_intensiva(jj)=Wterapia_intensiva(jj)+terapia_intensiva_giornaliera(kk);
    end
%     Wterapia_intensiva(jj)=terapia_intensiva(kk);
    Wdeceduti(jj)=deceduti(kk);
    Wtamponi(jj)=tamponi(kk);
    Wguariti(jj)=guariti(kk);
    Wattuali_positivi(jj)=attuali_positivi(kk);
    Wtotale_casi(jj)=totale_casi(kk);
    Wisolamento_domiciliare(jj)=isolamento_domiciliare(kk);
    Wcasi_sintomatici(jj)=ricoverati_sintomatici(kk);
    Wtotale_ospedalizzati(jj)=totale_ospedalizzati(kk);
    Wassex(jj)=jj;
    
    if fix(ending_index/7) == numero_di_settimane
        if giorni_rimanenti == 0
            ending_index=ending_index+7; %nuova settimana
        else
            ending_index=ending_index+giorni_rimanenti;
        end
    else
        ending_index=ending_index+7; %nuova settimana
    end
    last_index=kk+1; %alla fine del for sopra sono ancora all'ultimo elemento. mi devo spostare al nuovo
end


Wnuovi_casi=zeros(1,settimane_totali);
Wnuovi_guariti=zeros(1,settimane_totali);
Wnuovi_deceduti=zeros(1,settimane_totali);
Wtamponi_per_settimana=zeros(1,settimane_totali);
Wdiff_infetti=zeros(1,settimane_totali);
Wguariti_su_morti_per_giorno=zeros(1,settimane_totali);
Wrapporto_infetti_su_tamponi=zeros(1,settimane_totali);

for ll = 1:length(Wnuovi_casi())
    if ll==1
        Wnuovi_casi(ll)=Wtotale_casi(ll);
        Wnuovi_guariti(ll)=Wguariti(ll);
        Wnuovi_deceduti(ll)=Wdeceduti(ll);
        Wtamponi_per_settimana(ll)=Wtamponi(ll);
        Wdiff_infetti(ll)=Wnuovi_casi(ll);
    else
        Wnuovi_casi(ll)=Wtotale_casi(ll)-Wtotale_casi(ll-1);
        Wnuovi_guariti(ll)=Wguariti(ll)-Wguariti(ll-1);
        Wnuovi_deceduti(ll)=Wdeceduti(ll)-Wdeceduti(ll-1);
        Wtamponi_per_settimana(ll)=Wtamponi(ll)-Wtamponi(ll-1);
        Wdiff_infetti(ll)=Wnuovi_casi(ll)-Wnuovi_casi(ll-1);
    end
    Wguariti_su_morti_per_giorno(ll)=Wnuovi_guariti(ll)/Wnuovi_deceduti(ll);
    Wrapporto_infetti_su_tamponi(ll)=(Wnuovi_casi(ll)*100)/Wtamponi_per_settimana(ll);
end

%%plotting%%

figure('Name','Nuovi casi')
subplot(2,2,1)
plot(assex,nuovi_attuali_positivi,'r-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Nuovi attualmente infetti')
subplot(2,2,2)
plot(assex,totale_casi,'k-+',assex,attuali_positivi,'b-+',assex,guariti,'r-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Totali','Attualmente attivi','Guariti')
subplot(2,2,3)
plot(assex,differenza_infetti,'b-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Differenza infetti')
subplot(2,2,4)
plot(assex,nuovi_casi,'b-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Nuovi infetti')


figure('Name','Deceduti, guariti e ospedalizzazione')
subplot(2,2,1)
plot(assex,guariti,'r-+',assex,deceduti,'b-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Attualmente Guariti','Totale Deceduti')
subplot(2,2,2)
plot(assex,nuovi_guariti,'r-+',assex,nuovi_deceduti,'b-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Nuovi guariti','Nuovi Deceduti')
subplot(2,2,3)
plot(assex,ricoverati_sintomatici,'r-+',assex,isolamento_domiciliare,'g-+',assex,totale_ospedalizzati,'k-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Ricoverati sintomatici','Isolamento domiciliare','Totale ospedalizzati')
subplot(2,2,4)
plot(assex,terapia_intensiva,'r-+',assex,terapia_intensiva_giornaliera,'b-+'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Dati complessivi terapia intensiva','Dati giornalieri terapia intensiva')


figure('Name','Tamponi')
subplot(3,1,1)
plot(assex,tamponi,'r-+'), grid on
ylabel('Numero tamponi')
xlabel('Giorni da inizio [au]')
legend('Numero tamponi effettuati')
subplot(3,1,2)
plot(assex,tamponi_per_giorno,'r-+'), grid on
ylabel('Numero tamponi')
xlabel('Giorni da inizio [au]')
legend('Numero tamponi per giorno')
subplot(3,1,3)
plot(assex,rapporto_infetti_su_tamponi,'r-+'), grid on
ylabel('Valori in %')
xlabel('Giorni da inizio [au]')
legend('Rapporto tamponi/infetti per giorno')
% subplot(2,2,4)


%%WEEK PLOTTING

figure('Name','Nuovi casi ')
subplot(2,2,1)
plot(Wassex,Wnuovi_attuali,'r-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi attualmente infetti')
subplot(2,2,2)
plot(Wassex,Wtotale_casi,'k-+',Wassex,Wattuali_positivi,'b-+',Wassex,Wguariti,'r-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Totali','Attualmente attivi','Guariti')
subplot(2,2,3)
plot(Wassex,Wdiff_infetti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Differenza infetti settimanali')
subplot(2,2,4)
plot(Wassex,Wnuovi_casi,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi infetti per settimana')

figure('Name','Deceduti, guariti e ospedalizzazione')
subplot(2,2,1)
plot(Wassex,Wguariti,'r-+',Wassex,Wdeceduti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Attualmente Guariti','Totale Deceduti')
subplot(2,2,2)
plot(Wassex,Wnuovi_guariti,'r-+',Wassex,Wnuovi_deceduti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi guariti','Nuovi Deceduti')
subplot(2,2,3)
plot(Wassex,Wcasi_sintomatici,'r-+',Wassex,Wisolamento_domiciliare,'g-+',Wassex,Wtotale_ospedalizzati,'k-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Ricoverati sintomatici','Isolamento domiciliare','Totale ospedalizzati')
subplot(2,2,4)
plot(Wassex,Wterapia_intensiva,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Variazione settimanale terapia intensiva')



figure('Name','Tamponi')
subplot(3,1,1)
plot(Wassex,Wtamponi,'r-+'), grid on
ylabel('Tamponi effettuati')
xlabel('N° settimane passate [au]')
legend('Numero tamponi effettuati')
subplot(3,1,2)
plot(Wassex,Wtamponi_per_settimana,'r-+'), grid on
ylabel('Tamponi effettuati')
xlabel('N° settimane passate [au]')
legend('Numero tamponi effettuati nella settimana')
subplot(3,1,3)
plot(Wassex,Wrapporto_infetti_su_tamponi,'r-+'), grid on
ylabel('Valori in %')
xlabel('N° settimane passate [au]')
legend('Rapporto tamponi/infetti per settimana')
% subplot(2,2,4)


% figure('Name','Test')
% plot(assex,test), grid on
