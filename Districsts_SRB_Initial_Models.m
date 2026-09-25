%% Univariate models

selected_predictors = [7 11 13 18 20 22 30 35 38];

Y = values_P (:,5);

n_predictors = length(selected_predictors);

beta_std = NaN(n_predictors,1);
CI_low = NaN(n_predictors,1);
CI_high = NaN(n_predictors,1);
R2 = NaN(n_predictors,1);
p_raw = NaN(n_predictors,1);
N = NaN(n_predictors,1);

for i = 1:n_predictors

    X = values_transf_out(:,selected_predictors(i));

    % Keep only complete observations
    valid = ~isnan(X) & ~isnan(Y);

    X_valid = X(valid);
    Y_valid = Y(valid);

    % Number of observations
    N(i) = length(X_valid);

    % Linear regression
    mdl = fitlm(X_valid,Y_valid);

    % Standardized beta
    beta_std(i) = mdl.Coefficients.Estimate(2) * ...
        std(X_valid) / std(Y_valid);

    % 95% CI for raw regression coefficient
    CI = coefCI(mdl);
    CI_low(i) = CI(2,1);
    CI_high(i) = CI(2,2);

    % R-squared
    R2(i) = mdl.Rsquared.Ordinary;

    % Raw p-value
    p_raw(i) = mdl.Coefficients.pValue(2);

end


p_FDR = mafdr(p_raw,'BHFDR',true);

Predictor = VarNames(selected_predictors)';

Results = table(Predictor,N,beta_std,CI_low,CI_high,R2,p_raw,p_FDR, ...
    'VariableNames', ...
    {'Predictor','N','Beta_std','CI_low','CI_high','R2','p_raw','p_FDR'});

disp(Results)

writetable(Results,'Univariate_Regression_results.xlsx');

%% Age adjusted Models
Y = values_P (:,5);

adjustment_var = 7;

predictor_vars = [13 22 18 20 11 30 35 38];

n_models = length(predictor_vars);

Beta65 = NaN(n_models,1);
CI65_low = NaN(n_models,1);
CI65_high = NaN(n_models,1);
p65 = NaN(n_models,1);

Beta_std = NaN(n_models,1);
CI_low = NaN(n_models,1);
CI_high = NaN(n_models,1);
R2 = NaN(n_models,1);
p_raw = NaN(n_models,1);
N = NaN(n_models,1);

for i = 1:n_models

    X1 = values_transf_out(:,adjustment_var);
    X2 = values_transf_out(:,predictor_vars(i));

    valid = ~isnan(Y) & ~isnan(X1) & ~isnan(X2);

    Y_valid = Y(valid);
    X1_valid = X1(valid);
    X2_valid = X2(valid);

    X = [X1_valid X2_valid];

    mdl = fitlm(X,Y_valid);

    N(i) = length(Y_valid);

    % %65+ adjustment variable
    Beta65(i) = mdl.Coefficients.Estimate(2);
    CI65 = coefCI(mdl);
    CI65_low(i) = CI65(2,1);
    CI65_high(i) = CI65(2,2);
    p65(i) = mdl.Coefficients.pValue(2);

    % Main predictor
    beta_raw = mdl.Coefficients.Estimate(3);

    Beta_std(i) = beta_raw * ...
        std(X2_valid) / std(Y_valid);

    CI = coefCI(mdl);

    CI_low(i) = CI(3,1);
    CI_high(i) = CI(3,2);

    p_raw(i) = mdl.Coefficients.pValue(3);

    R2(i) = mdl.Rsquared.Ordinary;

end

% FDR correction ONLY for the 8 main predictors
p_FDR = mafdr(p_raw,'BHFDR',true);

Predictor = VarNames(predictor_vars)';

Results = table( ...
    Predictor, ...
    N, ...
    Beta65, ...
    CI65_low, ...
    CI65_high, ...
    p65, ...
    Beta_std, ...
    CI_low, ...
    CI_high, ...
    R2, ...
    p_raw, ...
    p_FDR, ...
    'VariableNames', ...
    {'Predictor','N', ...
    'Beta_65plus','CI65_low','CI65_high','p65', ...
    'Beta_std','CI_low','CI_high','R2','p_raw','p_FDR'});

disp(Results)
writetable(Results,'Age_Ajdusted_Regression_results.xlsx');

%% Domain Models

Y = values_P(:,5);

model_predictors = {
    [7 13 11]
    [7 22 18]
    [7 22 20]
    [7 30 35]
    [7 38 11]
};

model_names = {
    'Sociodemographic'
    'Health cardiovascular'
    'Health diabetes'
    'Meteorological'
    'Air pollution'
};

Results_all = table();

for i = 1:length(model_predictors)
    
    predictors = model_predictors{i};
    
    X = values_transf_out(:,predictors);
    
    valid = ~isnan(Y) & all(~isnan(X),2);
    
    Y_valid = Y(valid);
    X_valid = X(valid,:);
    
    mdl = fitlm(X_valid,Y_valid);
    
    N_model = length(Y_valid);
    
    % Extract coefficients for all predictors
    for j = 1:length(predictors)
        
        beta_raw = mdl.Coefficients.Estimate(j+1);
        
        beta_std = beta_raw * ...
            std(X_valid(:,j)) / std(Y_valid);
        
        CI = coefCI(mdl);
        
        CI_low = CI(j+1,1);
        CI_high = CI(j+1,2);
        
        R2_model = mdl.Rsquared.Ordinary;
        
        p_value = mdl.Coefficients.pValue(j+1);
        
        new_row = table( ...
            {model_names{i}}, ...
            {VarNames{predictors(j)}}, ...
            N_model, ...
            beta_std, ...
            CI_low, ...
            CI_high, ...
            R2_model, ...
            p_value, ...
            'VariableNames', ...
            {'Model','Predictor','N','Beta_std', ...
            'CI_low','CI_high','R2','p_raw'});
        
        Results_all = [Results_all; new_row];
        
    end
    
end


Results_all.p_FDR = mafdr(Results_all.p_raw,'BHFDR',true);

disp(Results_all)

writetable(Results_all,'Domain_Regression_results.xlsx');

