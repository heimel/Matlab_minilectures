% Example for nested OD data for Rogier
%
% 2024, Alexander Heimel

%% Generate artificial data
%  od = mean_od + genotype * effect_genotype + md * effect_md + genotype*md*effect_interaction + mouse_effect + neuron_effect;


n_mice_per_group = 20; % mice per group
n_per_mouse = 20; % neurons per mouse
mean_od = 1;
sigma_mice = 0.01; % sigma of mice around group mean
sigma_neurons = 0.02; % sigma of neurons around mouse mean
effect_genotype = 0.1; 
effect_md = -0.5;
effect_interaction = 0.5;


var_types = {'double','double','categorical','categorical','double'};
var_names = {'genotype','md','mouse_name','neuron_name','od'};
tbl = table('Size',[0,length(var_types)],'VariableTypes',var_types,'VariableNames',var_names);
for genotype = 0:1
    for md = 0:1
        for m = 1:n_mice_per_group
            mouse_effect = normrnd(0,sigma_mice,1);
            mouse_name = [num2str(genotype) '_' num2str(md) '_' num2str(m)];
            for i = 1:n_per_mouse
                neuron_name = [mouse_name '_' num2str(i) ];
                neuron_effect = normrnd(0,sigma_neurons,1);
                od = mean_od + genotype * effect_genotype + md * effect_md + genotype*md*effect_interaction + mouse_effect + neuron_effect;
                tbl = [tbl; {genotype,md,mouse_name,neuron_name,od}];
            end % i
        end % m
    end % mdtbl
end % genotype
%tbl.genotype = ordinal(tbl.genotype);
%tbl.md = ordinal(tbl.md);

mean(tbl.od(tbl.md==0)) % mean OD without MD
%% Compute linear mixed effect model

lme = fitlme(tbl,'od ~ md + genotype + md*genotype + (1|mouse_name) + (1|neuron_name)')

% Result:
%
% lme = 
% 
% 
% Linear mixed-effects model fit by ML
% 
% Model information:
%     Number of observations            1600
%     Fixed effects coefficients           4
%     Random effects coefficients       1680
%     Covariance parameters                3
% 
% Formula:
%     od ~ 1 + genotype*md + (1 | mouse_name) + (1 | neuron_name)
% 
% Model fit statistics:
%     AIC        BIC        LogLikelihood    Deviance
%     -7752.2    -7714.6    3883.1           -7766.2 
% 
% Fixed effects coefficients (95% CIs):
%     Name                   Estimate    SE           tStat      DF      pValue         Lower       Upper   
%     {'(Intercept)'}          1.001     0.0021295     470.06    1596              0     0.99683      1.0052
%     {'genotype'   }        0.09575     0.0030116     31.794    1596    2.9375e-172    0.089842     0.10166
%     {'md'         }        -0.5023     0.0030116    -166.79    1596              0     -0.5082    -0.49639
%     {'genotype:md'}        0.50471     0.0042591      118.5    1596              0     0.49636     0.51306
% 
% Random effects covariance parameters (95% CIs):
% Group: mouse_name (80 Levels)
%     Name1                  Name2                  Type           Estimate     Lower        Upper   
%     {'(Intercept)'}        {'(Intercept)'}        {'std'}        0.0083347    0.0068062    0.010207
% 
% Group: neuron_name (1600 Levels)
%     Name1                  Name2                  Type           Estimate    Lower         Upper     
%     {'(Intercept)'}        {'(Intercept)'}        {'std'}        0.015793    3.5501e-35    7.0254e+30
% 
% Group: Error
%     Name               Estimate    Lower        Upper     
%     {'Res Std'}        0.013236    4.382e-49    3.9979e+44

