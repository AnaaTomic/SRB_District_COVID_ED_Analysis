load SRB_District_COVID.mat

values_P (:,1)  = values(:,1); % COVID Deeaths 2020
values_P (:,2)  = values(:,2); % Excess Deaths 2020
values_P (:,3)  = values(:,3); % Total Deaths 2020
values_P (:,4)  = values(:,4); % Total Population
values_P(:,5)  = values(:,5); % ED_Rate
values_P(:,6)  = values(:,6); % COVID_MT_Rate

values_transf (:,1)  = values(:,1); % COVID Deeaths 2020 transf
values_transf (:,2)  = values(:,2); % Excess Deaths 2020 transf
values_transf (:,3)  = values(:,3); % Total Deaths 2020 transf
values_transf (:,4)  = values(:,4); % Total Population transf

values_transf(:,5)  = values(:,5); % ED_Rate 
values_transf(:,6)  = values(:,6); % COVID_MT_Rate

values_transf(:,7)  = values(:,7); %65+
values_transf(:,8)  = values(:,8); %MA
values_transf(:,9)  = values(:,9); %Aging Index

values_transf(:,10)  = log(values(:,10)); % Infant Mortality
values_transf(:,11)  = values(:,11);      %UP

values_transf(:,12) = values(:,12);     % GVA change 2019-2020
values_transf(:,13) = log(values(:,13));     % GVA
values_transf(:,14) = values(:,14).^2;;    % Life Expectancy
values_transf(:,15)  = values(:,15);      %Education Index
values_transf(:,16)  = values(:,16);      %GNI Index
values_transf(:,17) = log(values(:,17));     % HDI

values_transf(:,18)  = values(:,18);      %Inc Rate ACS
values_transf(:,19)  = log(values(:,19));      %Mt Rate ACS
values_transf(:,20) = sqrt(values(:,20));    % Inc Rate DM
values_transf(:,21)  = values(:,21);      %Mt Rate DM

values_transf(:,22) = log(values(:,22));     % Dr per 100k
values_transf(:,23) = values(:,23);    % Nursed per 100k
values_transf(:,24) = values(:,24);     % Population per Doctor
values_transf(:,25)  = values(:,25);     % BSG

values_transf(:,26)  = values(:,26);      %TU Mt Rate
values_transf(:,27)  = log(values(:,27));      %CDS Mt Rate
values_transf(:,28)  = values(:,28);      % Resp Mt Rate
values_transf(:,29)  = log(values(:,29));  %Endocrine Disease Mt Rate

values_transf(:,30) = values(:,30).^2;       % Air Pressure
values_transf(:,31) = values(:,31).^2;       % Max Air T
values_transf(:,32) = values(:,32).^2;       % Min AIr T
values_transf(:,33) = values(:,33).^2;       % Mean Air T

values_transf(:,34) = values(:,34).^2;       % Relative Vapor Pressure
values_transf(:,35) = values(:,35).^2;       % Relative Humidity
values_transf(:,36)  = log(values(:,36));     % Days with Maximum  T
values_transf(:,37) = values(:,37).^2;       % Days with Minimal T


values_transf(:,38) = values(:,38);     % SO2 mean
values_transf(:,39) = log(values(:,39));     % SO2 max
values_transf(:,40)  = values(:,40);      %NO2 mean
values_transf(:,41)  = values(:,41);      %NO2 max

skew_after = skewness(values_transf)
%% Remove the outliers: 
[values_transf_out, out_ind] = substituteoutlier(values_transf);
% Check skewness of transformed data:
skewness(values_transf_out)
% Display number of removed outliers: 
disp(sum(out_ind))

%%
save('SRB_District_COVID_ED_Transformed.mat', 'values_P', 'values_transf_out', 'VarNames');

%% save as xlxs
values_transf_out_tab = array2table (values_transf_out);
values_transf_out_tab.Properties.VariableNames = VarNames;

writetable(values_transf_out_tab, ...
    'values_transf_out.xlsx', 'Sheet', 1);

