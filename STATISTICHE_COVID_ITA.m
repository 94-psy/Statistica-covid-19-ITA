clear all; close all; clc

% da aggiungere: linea verticale ad ogni anno ed eventualmente una che si
% sposta in base al giorno e mostra anche una linea nell'anno precedete

%% DATA
currentFolder = pwd;
newFolder='COVID-19';
if ~exist(newFolder, 'dir')
    !git clone git://github.com/pcm-dpc/COVID-19.git
else
    oldFolder = cd(newFolder);
    !git pull git://github.com/pcm-dpc/COVID-19.git
    cd(oldFolder);
end
if ismac
    %     currentFolder = pwd;
    newFolder='COVID-19';
    csvfilesreg = dir('COVID-19/dati-regioni/*.csv');
    csvfilesprov = dir('COVID-19/dati-province/*.csv');
elseif isunix
    %     currentFolder = pwd;
    newFolder='COVID-19';
    csvfilesreg = dir('COVID-19/dati-regioni/*.csv');
    csvfilesprov = dir('COVID-19/dati-province/*.csv');
else
    csvfilesreg = dir('COVID-19\dati-regioni\*.csv');
    csvfilesprov = dir('COVID-19\dati-province\*.csv');
    newFolder='COVID-19';
end

% csvfiles = dir('COVID-19\dati-regioni\*.csv');
addpath(genpath(newFolder))

%% elaborazione
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
        %         tamponi_per_giorno(l)=abs(tamponi(l)-tamponi(l-1));
        tamponi_per_giorno(l)=tamponi(l)-tamponi(l-1);
        if tamponi_per_giorno(l) < 0
            tamponi_per_giorno(l)=tamponi_per_giorno(l-1);
        end
        differenza_infetti(l)=nuovi_casi(l)-nuovi_casi(l-1);
        %         test(l)=((diff_infetti(l))/nuovi_casi(l-1))*100;
    end
    rapporto_infetti_su_tamponi(l)=(nuovi_casi(l)*100)/tamponi_per_giorno(l);
end

%%RIASSUNTO SETTIMANALE
%%24/02/2020 primo report, lunedì, 54-esimo giorno dell'anno, quindi
%%mancano 53 giorni

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

%% calcolo per anno %%

tot_anni=ceil((length(totale_casi)+53)/365.25);

anno_deceduti=nan(tot_anni,366);
anno_terapia_intensiva=nan(tot_anni,366);
anno_terapia_intensiva_giornaliera=nan(tot_anni,366);
anno_ricoverati_sintomatici=nan(tot_anni,366);
anno_isolamento_domiciliare=nan(tot_anni,366);
anno_totale_ospedalizzati=nan(tot_anni,366);
anno_guariti=nan(tot_anni,366);
anno_nuovi_attuali_positivi=nan(tot_anni,366);
anno_attuali_positivi=nan(tot_anni,366);
anno_totale_casi=nan(tot_anni,366);
anno_nuovi_casi=nan(tot_anni,366);
anno_nuovi_guariti=nan(tot_anni,366);
anno_nuovi_deceduti=nan(tot_anni,366);
anno_tamponi=nan(tot_anni,366);
anno_rapporto_infetti_su_tamponi=nan(tot_anni,366);
anno_tamponi_per_giorno=nan(tot_anni,366);
anno_differenza_infetti=nan(tot_anni,366);

k=1;
fine_ciclo=0;

for i = 1:tot_anni
    if mod(i-1,4) == 0
        lim_anno=366;
    else
        lim_anno=365;
    end
    for ii=1:lim_anno
        if i == 1 && ii < 54
            anno_deceduti(i,ii)=nan;
            anno_terapia_intensiva(i,ii)=nan;
            anno_terapia_intensiva_giornaliera(i,ii)=nan;
            anno_ricoverati_sintomatici(i,ii)=nan;
            anno_isolamento_domiciliare(i,ii)=nan;
            anno_totale_ospedalizzati(i,ii)=nan;
            anno_guariti(i,ii)=nan;
            anno_nuovi_attuali_positivi(i,ii)=nan;
            anno_attuali_positivi(i,ii)=nan;
            anno_totale_casi(i,ii)=nan;
            anno_nuovi_casi(i,ii)=nan;
            anno_nuovi_guariti(i,ii)=nan;
            anno_nuovi_deceduti(i,ii)=nan;
            anno_tamponi(i,ii)=nan;
            anno_rapporto_infetti_su_tamponi(i,ii)=nan;
            anno_tamponi_per_giorno(i,ii)=nan;
            anno_differenza_infetti(i,ii)=nan;
        else
            anno_deceduti(i,ii)=deceduti(k);
            anno_terapia_intensiva(i,ii)=terapia_intensiva(k);
            anno_terapia_intensiva_giornaliera(i,ii)=terapia_intensiva_giornaliera(k);
            anno_ricoverati_sintomatici(i,ii)=ricoverati_sintomatici(k);
            anno_isolamento_domiciliare(i,ii)=isolamento_domiciliare(k);
            anno_totale_ospedalizzati(i,ii)=totale_ospedalizzati(k);
            anno_guariti(i,ii)=guariti(k);
            anno_nuovi_attuali_positivi(i,ii)=nuovi_attuali_positivi(k);
            anno_attuali_positivi(i,ii)=attuali_positivi(k);
            anno_totale_casi(i,ii)=totale_casi(k);
            anno_nuovi_casi(i,ii)=nuovi_casi(k);
            anno_nuovi_guariti(i,ii)=nuovi_guariti(k);
            anno_nuovi_deceduti(i,ii)=nuovi_deceduti(k);
            anno_tamponi(i,ii)=tamponi(k);
            anno_rapporto_infetti_su_tamponi(i,ii)=rapporto_infetti_su_tamponi(k);
            anno_tamponi_per_giorno(i,ii)=tamponi_per_giorno(k);
            anno_differenza_infetti(i,ii)=differenza_infetti(k);
            k=k+1;
        end
        if k > length(differenza_infetti)
            
            return
            
        end
        
    end
end



%calcolo media mobile 7 giorni
% i=1;
% var_index=1;
% uscita=false(1);
% while ~uscita
%     last_i=i;
%
%     while (i-last_i ) < 7
%         MOBnuovi_attuali(var_index)=MOBnuovi_attuali(var_index)+nuovi_attuali_positivi(i);
%         MOBdiff_terapia_intensiva(var_index)=MOBdiff_terapia_intensiva(var_index)+
%         MOBdiff_ospedalizzati(var_index)=MOBdiff_ospedalizzati(var_index)+
%         MOBdiff_isolamento_domiciliare(var_index)=MOBdiff_isolamento_domiciliare(var_index)+
%         MOBnuovi_casi(var_index)=MOBnuovi_casi(var_index)+
%         MOBnuovi_guariti(var_index)=MOBnuovi_guariti(var_index)+
%         MOBnuovi_deceduti(var_index)=MOBnuovi_deceduti(var_index)+
%         MOBtamponi_per_periodo(var_index)=MOBtamponi_per_periodo(var_index)+
%         MOBdiff_infetti(var_index)=MOBdiff_infetti(var_index)+
%         MOBguariti_su_morti_per_periodo(var_index)=MOBguariti_su_morti_per_periodo(var_index)+
%         MOBrapporto_infetti_su_tamponi(var_index)=MOBrapporto_infetti_su_tamponi(var_index)+
%         i=i+1;
%     end
%
%
%     i=last_i+1;
%     test_i=i+7;
%     var_index=var_index+1; %indice per i vettori
%     if test_i >= length(length(csvfilesreg))
%         uscita=true(1);
%     end
% end

%% test audio

% data_audio=1.5*differenza_infetti/max(differenza_infetti);
% resample_prova=resample(data_audio,fix(44100/400),1);
% FS=44100;
% audiowrite('test.wav',resample_prova,FS);

%% plotting %%

figure('Name','Nuovi casi')
subplot(2,2,1)
plot(assex,nuovi_attuali_positivi,'r'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Nuovi attualmente infetti')
subplot(2,2,2)
plot(assex,totale_casi,'k',assex,attuali_positivi,'b',assex,guariti,'r'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Totali','Attualmente attivi','Guariti')
subplot(2,2,3)
plot(assex,differenza_infetti,'b'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Differenza infetti')
subplot(2,2,4)
plot(assex,nuovi_casi,'b'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Nuovi infetti')


figure('Name','Deceduti, guariti e ospedalizzazione')
subplot(2,2,1)
plot(assex,guariti,'r',assex,deceduti,'b'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Attualmente Guariti','Totale Deceduti')
subplot(2,2,2)
plot(assex,nuovi_guariti,'r',assex,nuovi_deceduti,'b'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Nuovi guariti','Nuovi Deceduti')
subplot(2,2,3)
plot(assex,ricoverati_sintomatici,'r',assex,isolamento_domiciliare,'g',assex,totale_ospedalizzati,'k'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Ricoverati sintomatici','Isolamento domiciliare','Totale ospedalizzati')
subplot(2,2,4)
plot(assex,terapia_intensiva,'r',assex,terapia_intensiva_giornaliera,'b'), grid on
ylabel('Numero casi')
xlabel('Giorni da inizio [au]')
legend('Dati complessivi terapia intensiva','Dati giornalieri terapia intensiva')


figure('Name','Tamponi')
subplot(3,1,1)
plot(assex,tamponi,'r'), grid on
ylabel('Numero tamponi')
xlabel('Giorni da inizio [au]')
legend('Numero tamponi effettuati')
subplot(3,1,2)
plot(assex,tamponi_per_giorno,'r'), grid on
ylabel('Numero tamponi')
xlabel('Giorni da inizio [au]')
legend('Numero tamponi per giorno')
subplot(3,1,3)
plot(assex,rapporto_infetti_su_tamponi,'r'), grid on
ylabel('Valori in %')
xlabel('Giorni da inizio [au]')
legend('Rapporto infetti per giorno/tamponi')
% subplot(2,2,4)


%%WEEK PLOTTING

figure('Name','Nuovi casi ')
subplot(3,1,1)
plot(Wassex,Wnuovi_attuali,'r-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi attualmente infetti')
subplot(3,1,2)
plot(Wassex,Wnuovi_casi,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi infetti per settimana')
subplot(3,1,3)
plot(Wassex,Wdiff_infetti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Differenza infetti settimanali')


figure('Name','Deceduti, guariti e ospedalizzazione')
subplot(2,1,1)
plot(Wassex,Wnuovi_guariti,'r-+',Wassex,Wnuovi_deceduti,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Nuovi guariti','Nuovi Deceduti')
subplot(2,1,2)
plot(Wassex,Wterapia_intensiva,'b-+'), grid on
ylabel('Numero casi per settimana')
xlabel('N° settimane passate [au]')
legend('Variazione settimanale terapia intensiva')



figure('Name','Tamponi')
subplot(2,1,1)
plot(Wassex,Wtamponi_per_settimana,'r-+'), grid on
ylabel('Tamponi effettuati')
xlabel('N° settimane passate [au]')
legend('Numero tamponi effettuati nella settimana')
subplot(2,1,2)
plot(Wassex,Wrapporto_infetti_su_tamponi,'r-+'), grid on
ylabel('Valori in %')
xlabel('N° settimane passate [au]')
legend('Rapporto infetti per settimana/tamponi')
% subplot(2,2,4)


%ANNUAL PLOTTING


figure('Name','Attualmente Positivi')
for i=1:tot_anni
    subplot(2,1,1)
    hold on;
    anno_in_corso=2020+i-1;
    txt = ['Nuovi attualmente positivi (al netto di guarigioni e decessi), anno ',num2str(anno_in_corso)];
    plot(anno_nuovi_attuali_positivi(i,:),'DisplayName',txt), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
    
    subplot(2,1,2)
    hold on;
    txt1 = ['Attualmente positivi, anno ',num2str(anno_in_corso)];
    plot(anno_attuali_positivi(i,:),'DisplayName',txt1), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
end

figure('Name','Nuovi Casi')
for i=1:tot_anni
    subplot(2,1,1)
    hold on;
    anno_in_corso=2020+i-1;
    txt = ['Nuovi casi positivi registrati, anno ',num2str(anno_in_corso)];
    plot(anno_nuovi_casi(i,:),'DisplayName',txt), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
    
    subplot(2,1,2)
    hold on;
    txt1 = ['Differenza nuovi infetti giornaliera, anno ',num2str(anno_in_corso)];
    plot(anno_differenza_infetti(i,:),'DisplayName',txt1), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
end


figure('Name','Tamponi')
for i=1:tot_anni
    subplot(2,1,1)
    hold on;
    anno_in_corso=2020+i-1;
    txt = ['Tamponi giornalieri, anno ',num2str(anno_in_corso)];
    plot(anno_tamponi_per_giorno(i,:),'DisplayName',txt), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
    
    subplot(2,1,2)
    hold on;
    txt1 = ['Rapporto infetti su tamponi, anno ',num2str(anno_in_corso)];
    plot(anno_rapporto_infetti_su_tamponi(i,:),'DisplayName',txt1), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
end

figure('Name','Decessi e Guarigioni')
for i=1:tot_anni
    subplot(2,1,1)
    hold on;
    anno_in_corso=2020+i-1;
    txt = ['Decessi, anno ',num2str(anno_in_corso)];
    plot(anno_nuovi_deceduti(i,:),'DisplayName',txt), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
    
    subplot(2,1,2)
    hold on;
    txt1 = ['Guarigioni, anno ',num2str(anno_in_corso)];
    plot(anno_nuovi_guariti(i,:),'DisplayName',txt1), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
end

figure('Name','Terapia intensiva')
for i=1:tot_anni
    subplot(2,1,1)
    hold on;
    anno_in_corso=2020+i-1;
    txt = ['Variazione giornaliera terapia intensiva, anno ',num2str(anno_in_corso)];
    plot(anno_terapia_intensiva_giornaliera(i,:),'DisplayName',txt), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
    
    subplot(2,1,2)
    hold on;
    txt1 = ['Totale occupazione terapia intensiva, anno ',num2str(anno_in_corso)];
    plot(anno_terapia_intensiva(i,:),'DisplayName',txt1), grid on
    ylabel('Numero casi')
    xlabel('Giorni')
    legend show
end

% anno_deceduti=nan(tot_anni,366);
% anno_ricoverati_sintomatici=nan(tot_anni,366);
% anno_isolamento_domiciliare=nan(tot_anni,366);
% anno_totale_ospedalizzati=nan(tot_anni,366);
% anno_guariti=nan(tot_anni,366);
% anno_totale_casi=nan(tot_anni,366);
% anno_tamponi=nan(tot_anni,366);

% figure('Name','Test')
% plot(assex,test), grid on
