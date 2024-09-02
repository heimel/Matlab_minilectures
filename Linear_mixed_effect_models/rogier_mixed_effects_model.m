% rogier_mixed_effects_model
%
% Example for nested OD data for Rogier
%
% 2024, Alexander Heimel

%% Generate artificial data (for testing purposes)
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


%% Load real data
tbl_excel = readtable('Data overview Yi_per layer and grouped.xlsx',Sheet='Table',DataRange='A1:K145',ReadVariableNames=true);
tbl_excel(1,:) = [];

var_types = {'categorical','categorical','categorical','categorical','categorical','double'};
var_names = {'layer','genotype','md','mouse_name','neuron_name','od'};
tbl = table('Size',[0,length(var_types)],'VariableTypes',var_types,'VariableNames',var_names);

for i=1:height(tbl_excel)
    neuron_count = 1;

    if ~isnan(tbl_excel.neuron_1(i))
        neuron_name = [char(tbl_excel.mouse_name(i)) '_' num2str(neuron_count)];
        tbl = [tbl; {tbl_excel.layer(i),tbl_excel.genotype(i),tbl_excel.md(i),tbl_excel.mouse_name(i),neuron_name,tbl_excel.neuron_1(i)}];
        neuron_count = neuron_count + 1;
    end

    if ~isnan(tbl_excel.neuron_2(i))
        neuron_name = [char(tbl_excel.mouse_name(i)) '_' num2str(neuron_count)];
        tbl = [tbl; {tbl_excel.layer(i),tbl_excel.genotype(i),tbl_excel.md(i),tbl_excel.mouse_name(i),neuron_name,tbl_excel.neuron_2(i)}];
        neuron_count = neuron_count + 1;
    end

    if ~isnan(tbl_excel.neuron_3(i))
        neuron_name = [char(tbl_excel.mouse_name(i)) '_' num2str(neuron_count)];
        tbl = [tbl; {tbl_excel.layer(i),tbl_excel.genotype(i),tbl_excel.md(i),tbl_excel.mouse_name(i),neuron_name,tbl_excel.neuron_3(i)}];
        neuron_count = neuron_count + 1;
    end

    if ~isnan(tbl_excel.neuron_4(i))
        neuron_name = [char(tbl_excel.mouse_name(i)) '_' num2str(neuron_count)];
        tbl = [tbl; {tbl_excel.layer(i),tbl_excel.genotype(i),tbl_excel.md(i),tbl_excel.mouse_name(i),neuron_name,tbl_excel.neuron_4(i)}];
        neuron_count = neuron_count + 1;
    end

    if ~isnan(tbl_excel.neuron_5(i))
        neuron_name = [char(tbl_excel.mouse_name(i)) '_' num2str(neuron_count)];
        tbl = [tbl; {tbl_excel.layer(i),tbl_excel.genotype(i),tbl_excel.md(i),tbl_excel.mouse_name(i),neuron_name,tbl_excel.neuron_5(i)}];
        neuron_count = neuron_count + 1;
    end

        if ~isnan(tbl_excel.neuron_6(i))
        neuron_name = [char(tbl_excel.mouse_name(i)) '_' num2str(neuron_count)];
        tbl = [tbl; {tbl_excel.layer(i),tbl_excel.genotype(i),tbl_excel.md(i),tbl_excel.mouse_name(i),neuron_name,tbl_excel.neuron_6(i)}];
        neuron_count = neuron_count + 1;
    end
end % i

tbl_mice = groupsummary(tbl,"mouse_name","mean","od");
genotype = categorical();
md = categorical();
for m = 1:height(tbl_mice)
    genotype(m,1) = string(unique(tbl.genotype(tbl.mouse_name==tbl_mice.mouse_name(m))));
    md(m,1) = unique(tbl.md(tbl.mouse_name==tbl_mice.mouse_name(m)));
end
tbl_mice = addvars(tbl_mice,genotype,md);

disp('Loaded data and computed average per mouse')

%% Show some results
figure

h1 = subplot(2,2,1);
ivt_graph(...
    {tbl.od(tbl.genotype=='wt' & tbl.md=='nomd'),tbl.od(tbl.genotype=='wt' & tbl.md=='md'),...
    tbl.od(tbl.genotype=='ko' & tbl.md=='nomd'),tbl.od(tbl.genotype=='ko' & tbl.md=='md')},...
    [],'spaced',3,'axishandle',h1,...
    'style','bar','errorbars','sem','xticklabels',{'wt nomd','wt md','ko nomd','ko md'},'ylab','od','signif_y',[4 nan;7 nan])
title('Per unit')

h2 = subplot(2,2,2);
ivt_graph(...
    {tbl_mice.mean_od(tbl_mice.genotype=='wt' & tbl_mice.md=='nomd'),tbl_mice.mean_od(tbl_mice.genotype=='wt' & tbl_mice.md=='md'),...
    tbl_mice.mean_od(tbl_mice.genotype=='ko' & tbl_mice.md=='nomd'),tbl_mice.mean_od(tbl_mice.genotype=='ko' & tbl_mice.md=='md')},...
    [],'spaced',3,'axishandle',h2,...
    'style','bar','errorbars','sem','xticklabels',{'wt nomd','wt md','ko nomd','ko md'},'ylab','od','signif_y',[4 nan;7 nan])
title('Per mouse')


%% Two-way ANOVA
%p = anovan(y,{g1 g2 g3},'model','interaction','varnames',{'g1','g2','g3'})
[p,~] = anovan(tbl.od,{tbl.genotype,tbl.md},'model','interaction','varnames',{'genotype','md'});
disp(['Two-way ANOVA All layer interaction p = ' num2str(p(3))]);

%% Unnested linear mixed effect model
lme_unnested = fitlme(tbl,'od ~ md + genotype + md*genotype ');
disp(['Unnested LME All layer interaction p = ' num2str(lme_unnested.Coefficients.pValue(4))]);

%% Two-way ANOVA per mouse
[p,stat] = anovan(tbl_mice.mean_od,{tbl_mice.genotype,tbl_mice.md},'model','interaction','varnames',{'genotype','md'},'display','off');
disp(['Mouse averages Two-way ANOVA All layer interaction p = ' num2str(p(3))]);

%% Nested linear mixed effect model
lme_nested = fitlme(tbl,'od ~ md + genotype + md*genotype + (1|mouse_name) ');
disp(['Nested LME All layer interaction p = ' num2str(lme_nested.Coefficients.pValue(4))]);

lme_nested = fitlme(tbl(tbl.layer=='L2-3',:),'od ~ md + genotype + md*genotype + (1|mouse_name) ');
disp(['Nested LME L2-3 interaction p = ' num2str(lme_nested.Coefficients.pValue(4))]);
lme_nested = fitlme(tbl(tbl.layer=='L4',:),'od ~ md + genotype + md*genotype + (1|mouse_name) ');
disp(['Nested LME L4 interaction p = ' num2str(lme_nested.Coefficients.pValue(4))]);

lme_nested = fitlme(tbl(tbl.layer=='L5',:),'od ~ md + genotype + md*genotype + (1|mouse_name) ');
disp(['Nested LME L5 interaction p = ' num2str(lme_nested.Coefficients.pValue(4))]);

lme_nested = fitlme(tbl(tbl.layer=='L4'|tbl.layer=='L5',:),'od ~ md + genotype + md*genotype + (1|mouse_name)   ');
disp(['Nested LME L4-5 interaction p = ' num2str(lme_nested.Coefficients.pValue(4))]);

lme_nested = fitlme(tbl(tbl.layer=='L6',:),'od ~ md + genotype + md*genotype + (1|mouse_name) ');
disp(['Nested LME L6 interaction p = ' num2str(lme_nested.Coefficients.pValue(4))]);

