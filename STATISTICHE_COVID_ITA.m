clear all; close all; clc
newFolder='COVID-19';
if ~exist('COVID-19', 'dir')
    !git clone git://github.com/pcm-dpc/COVID-19.git
else
    oldFolder = cd(newFolder);
    !git pull git://github.com/pcm-dpc/COVID-19.git
    cd(oldFolder);
end
if ismac
    % Code to run on Mac platform
elseif isunix
    % Code to run on Linux platform
elseif ispc
    csvfiles = dir('COVID-19\dati-regioni\*.csv');
else
    csvfiles = dir('COVID-19\dati-regioni\*.csv');
end
% csvfiles = dir('COVID-19\dati-regioni\*.csv');
addpath(genpath(newFolder))
csvfiles(end)=[];
csvfiles(end)=[];
k=0;
morti=zeros(1,length(csvfiles));
terapia_intensiva=zeros(1,length(csvfiles));
terapia_intensiva_giornaliera=zeros(1,length(csvfiles));
ricoverati_sintomatici=zeros(1,length(csvfiles));
ricoverati_asintomatici=zeros(1,length(csvfiles));
guariti=zeros(1,length(csvfiles));
nuovi_attuali=zeros(1,length(csvfiles));
attuali=zeros(1,length(csvfiles));
tot_casi=zeros(1,length(csvfiles));
nuovi_casi=zeros(1,length(csvfiles));
nuovi_guariti=zeros(1,length(csvfiles));
nuovi_morti=zeros(1,length(csvfiles));
tamponi=zeros(1,length(csvfiles));
tamponi_per_giorno=zeros(1,length(csvfiles));
diff_infetti=zeros(1,length(csvfiles));
assex=zeros(1,length(csvfiles));
guariti_su_morti_per_giorno=zeros(1,length(csvfiles));
guariti_su_morti=zeros(1,length(csvfiles));
nomi=zeros(1,length(csvfiles));
% test=zeros(1,length(csvfiles));


for file = csvfiles'
    k=k+1;
    [data]=readmatrix(csvfiles(k).name,'Delimiter',',');
    nomi(k)=str2double(csvfiles(k).name(end-11:end-4));
    for i=1:length(data) %data(1,3)= prima riga terza colonna. 7 ricoverati con sintomi, 8 terapia intensiva, 18 TOTALE CASI, 15 deceduti,14 guariti, 12 nuovi attualmente positivi, 11 totale attualmente positivi, 19 numero tamponi fatti
        morti(k)=morti(k)+data(i,15);
        terapia_intensiva(k)=terapia_intensiva(k)+data(i,8);
        guariti(k)=guariti(k)+data(i,14);
        attuali(k)=attuali(k)+data(i,11);
        nuovi_attuali(k)=nuovi_attuali(k)+data(i,12);
        tot_casi(k)=tot_casi(k)+data(i,18);
        tamponi(k)=tamponi(k)+data(i,19);
        ricoverati_sintomatici(k)=ricoverati_sintomatici(k)+data(i,9);
    end
    guariti_su_morti(k)=guariti(k)/morti(k);
    ricoverati_asintomatici(k)=attuali(k)-ricoverati_sintomatici(k);
    assex(k)=k;
    
end

for l = 1:length(nuovi_casi())
    if l==1
        nuovi_casi(l)=tot_casi(l);
        nuovi_guariti(l)=guariti(l);
        nuovi_morti(l)=morti(l);
        tamponi_per_giorno(l)=tamponi(l);
        diff_infetti(l)=nuovi_casi(l);
        terapia_intensiva_giornaliera(l)=terapia_intensiva(l);
%         test(l)=100;
    else
        nuovi_casi(l)=tot_casi(l)-tot_casi(l-1);
        terapia_intensiva_giornaliera(l)=terapia_intensiva(l)-terapia_intensiva(l-1);
        nuovi_guariti(l)=guariti(l)-guariti(l-1);
        nuovi_morti(l)=morti(l)-morti(l-1);
        tamponi_per_giorno(l)=tamponi(l)-tamponi(l-1);
        diff_infetti(l)=nuovi_casi(l)-nuovi_casi(l-1);
%         test(l)=((diff_infetti(l))/nuovi_casi(l-1))*100;
    end
    guariti_su_morti_per_giorno(l)=nuovi_guariti(l)/nuovi_morti(l);
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


Wmorti=zeros(1,settimane_totali);
Wguariti=zeros(1,settimane_totali);
Wattuali=zeros(1,settimane_totali);
Wnuovi_attuali=zeros(1,settimane_totali);
Wtot_casi=zeros(1,settimane_totali);
Wtamponi=zeros(1,settimane_totali);
Wricoverati_sintomatici=zeros(1,settimane_totali);
Wterapia_intensiva=zeros(1,settimane_totali);

Wricoverati_asintomatici=zeros(1,settimane_totali);
Wguariti_su_morti=zeros(1,settimane_totali);

Wassex=zeros(1,length(settimane_totali));
last_index=1;
ending_index=7;

for jj=1:settimane_totali
    
    for kk=last_index:ending_index
        Wnuovi_attuali(jj)=Wnuovi_attuali(jj)+nuovi_attuali(kk);
    end
    Wterapia_intensiva(jj)=terapia_intensiva(kk);
    Wmorti(jj)=morti(kk);
    Wtamponi(jj)=tamponi(kk);
    Wguariti(jj)=guariti(kk);
    Wattuali(jj)=attuali(kk);
    Wtot_casi(jj)=tot_casi(kk);
    Wguariti_su_morti(jj)=Wguariti(jj)/Wmorti(jj);
    Wricoverati_sintomatici(jj)=ricoverati_sintomatici(kk);
    Wricoverati_asintomatici(jj)=Wattuali(jj)-Wricoverati_sintomatici(jj);
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
Wnuovi_morti=zeros(1,settimane_totali);
Wtamponi_per_settimana=zeros(1,settimane_totali);
Wdiff_infetti=zeros(1,settimane_totali);
Wguariti_su_morti_per_giorno=zeros(1,settimane_totali);

for ll = 1:length(Wnuovi_casi())
    if ll==1
        Wnuovi_casi(ll)=Wtot_casi(ll);
        Wnuovi_guariti(ll)=Wguariti(ll);
        Wnuovi_morti(ll)=Wmorti(ll);
        Wtamponi_per_settimana(ll)=Wtamponi(ll);
        Wdiff_infetti(ll)=Wnuovi_casi(ll);
    else        
        Wnuovi_casi(ll)=Wtot_casi(ll)-Wtot_casi(ll-1);
        Wnuovi_guariti(ll)=Wguariti(ll)-Wguariti(ll-1);
        Wnuovi_morti(ll)=Wmorti(ll)-Wmorti(ll-1);
        Wtamponi_per_settimana(ll)=Wtamponi(ll)-Wtamponi(ll-1);
        Wdiff_infetti(ll)=Wnuovi_casi(ll)-Wnuovi_casi(ll-1);
    end
    Wguariti_su_morti_per_giorno(ll)=Wnuovi_guariti(ll)/Wnuovi_morti(ll);
end

%%plotting%%

figure('Name','Nuovi casi')
subplot(2,1,1)
plot(assex,nuovi_attuali,'r-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Nuovi attualmente infetti')
subplot(2,1,2)
plot(assex,tot_casi,'k-+',assex,attuali,'b-+',assex,guariti,'r-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Totali','Attualmente attivi','Guariti')


figure('Name','Morti, guariti e nuovi casi')
subplot(2,2,1)
plot(assex,guariti,'r-+',assex,morti,'b-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Attualmente Guariti','Totale Morti')
subplot(2,2,2)
plot(assex,diff_infetti,'b-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Differenza infetti')
subplot(2,2,3)
plot(assex,nuovi_casi,'b-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Nuovi infetti')
subplot(2,2,4)
plot(assex,nuovi_guariti,'r-+',assex,nuovi_morti,'b-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Nuovi guariti','Nuovi morti')



figure('Name','Tamponi e terapia intensiva')
subplot(2,2,1)
plot(assex,tamponi,'r-+'), grid on
ylabel('Numero tamponi')
xlabel('Tempo [au]')
legend('Numero tamponi effettuati')
subplot(2,2,2)
plot(assex,tamponi_per_giorno,'r-+'), grid on
ylabel('Numero tamponi')
xlabel('Tempo [au]')
legend('Numero tamponi per giorno')
subplot(2,2,3)
plot(assex,ricoverati_sintomatici,'r-+',assex,ricoverati_asintomatici,'b-+',assex,attuali,'g-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Ricoverati sintomatici','Ricoverati asintomatici','Ricoverati totali')
subplot(2,2,4)
plot(assex,terapia_intensiva,'r-+',assex,terapia_intensiva_giornaliera,'b-+'), grid on
ylabel('Numero casi')
xlabel('Tempo [au]')
legend('Dati complessivi terapia intensiva','Dati giornalieri terapia intensiva')

%%WEEK PLOTTING

figure('Name','Nuovi casi ')
subplot(2,1,1)
plot(Wassex,Wnuovi_attuali,'r-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi attualmente infetti')
subplot(2,1,2)
plot(Wassex,Wtot_casi,'k-+',Wassex,Wattuali,'b-+',Wassex,Wguariti,'r-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Totali','Attualmente attivi','Guariti')


figure('Name','Morti, guariti e nuovi casi #2')
subplot(2,2,1)
plot(Wassex,Wguariti,'r-+',Wassex,Wmorti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Attualmente Guariti','Totale Morti')
subplot(2,2,2)
plot(Wassex,Wdiff_infetti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Differenza infetti settimanali')
subplot(2,2,3)
plot(Wassex,Wnuovi_casi,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi infetti per settimana')
subplot(2,2,4)
plot(Wassex,Wnuovi_guariti,'r-+',Wassex,Wnuovi_morti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi guariti','Nuovi morti')


figure('Name','Tamponi e terapia intensiva')
subplot(2,2,1)
plot(Wassex,Wtamponi,'r-+'), grid on
ylabel('Tamponi effettuati')
xlabel('N° settimane passate [au]')
legend('Numero tamponi effettuati')
subplot(2,2,2)
plot(Wassex,Wtamponi_per_settimana,'r-+'), grid on
ylabel('Tamponi effettuati')
xlabel('N° settimane passate [au]')
legend('Numero tamponi effettuati nella settimana')
subplot(2,2,3)
plot(Wassex,Wricoverati_sintomatici,'r-+',Wassex,Wricoverati_asintomatici,'b-+',Wassex,Wattuali,'g-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Ricoverati sintomatici','Ricoverati asintomatici','Ricoverati totali')
subplot(2,2,4)
plot(Wassex,Wterapia_intensiva,'r-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Dati complessivi terapia intensiva')

% figure('Name','Test')
% plot(assex,test), grid on
