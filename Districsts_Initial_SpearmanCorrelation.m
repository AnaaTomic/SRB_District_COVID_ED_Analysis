%load non-transformed variables

load SRB_District_COVID.mat

% Spearman correlation

[R,P] = corr(values, 'Type', 'Spearman', 'Rows', 'pairwise');

mr_variables_spearman_Table = array2table(R,'VariableNames', VarNames,'RowNames', VarNames);

mr_variables_pVal_Table = array2table(P,'VariableNames', VarNames,'RowNames', VarNames);

save mr_spearman_correlation_tables mr_variables_spearman_Table mr_variables_pVal_Table

writetable(mr_variables_spearman_Table, ...
    'Spearman_Correlations.xlsx', 'Sheet', 1, 'WriteRowNames', true);

writetable(mr_variables_pVal_Table, ...
    'Spearman_Correlations.xlsx', 'Sheet', 2, 'WriteRowNames', true);


%% Spearman correlation heatmaps

figure;
heatmap(VarNames, VarNames, R);
title('Spearman Correlation Matrix (R)');

figure;
heatmap(VarNames, VarNames, P);
title('Spearman Correlation Matrix (P)');


% Keep only upper triangle

R_upper = triu(R,1);

figure('Position',[100 100 1200 1200])

imagesc(R_upper)

clim([-1 1])
axis square
colormap(flipud(jet))
colorbar

hold on

% Overlay lower triangle mask
mask = tril(true(size(R)));

whiteMask = ones(size(R,1), size(R,2), 3);
h = image(whiteMask);
h.AlphaData = mask;

n = length(VarNames);

% Add significance markers
for i = 1:n
    for j = 1:n

        if i < j

            if P(i,j) < 0.001
                marker = '***';
            elseif P(i,j) < 0.01
                marker = '**';
            elseif P(i,j) < 0.05
                marker = '*';
            else
                marker = '';
            end

            if ~isempty(marker)
                text(j,i,marker,...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','middle',...
                    'FontSize',12,...
                    'Color','k')
            end

        end

    end
end

% Labels
xticks(1:n)
yticks(1:n)

xticklabels(VarNames)
yticklabels(VarNames)

xtickangle(45)

ax = gca;
ax.XAxisLocation = 'top';

title('Spearman Correlation Matrix')

hold off


%% Ranking Districts

values_ranked = tiedrank(values);

RankTable = array2table(values_ranked, ...
    'VariableNames', VarNames, ...
    'RowNames', districtNames);

disp(RankTable)
%% Ranking Districts by a heatmap
values_ranked = tiedrank(values);

figure('Position',[100 100 1400 800])

imagesc(values_ranked)

colorbar
clim([1 25])

xticks(1:41)
yticks(1:25)

xticklabels(VarNames)
xtickangle(45)

ylabel('Observation')
xlabel('Variable')
title('Ranks of Observations Across Variables')

yticklabels(districtNames)
%or 
yticklabels(1:25)


%% Rank bar graph with chosen variables 

selected_vars = [5 6 7 13 22 18 20 11 33 35 40 38];

titles = { 
    'COVID Mortality Rate'
    'Excess Deaths Rate'
    '% 65+'
    'GVA'
    'Broj doktora na 100k stanovnika'
    'Incidencija AKS'
    'Incidencija dijabetesa'
    '% urbanog stanovništva'
    'Temperatura vazduha'
    'Relativna vlažnost'
    'NO2'
    'SO2'
};

figure('Position',[50 50 1600 1000])

for k = 1:length(selected_vars)

    var = selected_vars(k);

    [ranked_values, order] = sort(values(:,var), 'descend');

    subplot(6,2,k)

    bar(ranked_values)

    xticks(1:25)
    xticklabels(districtNames(order))
    xtickangle(45)

    ymin = min(ranked_values);
    ymax = max(ranked_values);

    margin = 0.05 * (ymax - ymin);

    ylim([ymin - margin ymax + margin])

    ylabel('Value')
    title(titles{k})

end