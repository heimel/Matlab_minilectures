function stats_demo
%Written by Xing 11/6/14.
%Provides examples of how to use Matlab functions to carry out hypothesis
%testing. Structure and format of input & output arguments. This
%demonstrates the most basic capabilities of each function- for more
%options, check the help manual.
%Tests:
%t-tests, ANOVAs, non-parametric tests, correlations, descriptive stats
%(normality, skewness, kurtosis, scedasticity), chi-squared tests, circular
%statistics.

%Generally speaking, 
%h==1: reject the null hypothesis (the confidence interval does not span 0);
%h==0: fail to reject the null hypothesis (the CI spans 0).


%1. t-tests & non-parametric analogs

%Test whether mean of a distribution is significantly different from zero:
mu=10;%mean
sigma=5;%SD
x=normrnd(mu,sigma,1,100);%generate 100 values that form a normal distribution
[h p ci stats]=ttest(x)

%Test whether mean of a distribution is significantly different from a certain value, m:
mu=10;
sigma=5;
x=normrnd(mu,sigma,1,100);%generate 100 values that form a normal distribution
m=9;%hypothesized mean
[h p ci stats]=ttest(x,m)

%Test whether the means of two differently sized distributions are significantly different from each other:
mu1=10;
sigma1=5;
mu2=14;
sigma2=5;
x1=normrnd(mu1,sigma1,1,100);%generate 100 values that form the first distribution
x2=normrnd(mu2,sigma2,1,50);%generate 50 values that form the second distribution
[h p ci stats]=ttest2(x1,x2)

%Test whether the means of two distributions are significantly different from each other:
mu1=10;
sigma1=5;
mu2=12;
sigma2=5;
x1=normrnd(mu1,sigma1,1,100);%generate 100 values that form the first distribution
x2=normrnd(mu2,sigma2,1,100);%generate 100 values that form the second distribution
[h p ci stats]=ttest(x1,x2,[],'both')%paired t-test
[h p ci stats]=ttest2(x1,x2)%unpaired t-test

x1=sort(x1);%see what happens when you introduce a systematic offset between the two distributions
x2=sort(x2);
[h p ci stats]=ttest(x1,x2,[],'both')%paired t-test

%Report the t statistic, the df (in brackets), and the p-value
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = ',num2str(p)])
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)

%Can also specify whether to perform one-tailed or two-tailed tests

%For non-parametric distributions:

%[p h stats]=signrank(x) performs a two-sided signed rank test of the null
%hypothesis that data in the vector x comes from a continuous, symmetric
%distribution with zero median, against the alternative that the
%distribution does not have zero median. The p-value of the test is
%returned in p.

%[p h stats]=signrank(x,y) performs a paired, two-sided signed rank test of the null
% hypothesis that data in the vector x-y come from a continuous, symmetric
% distribution with zero median, against the alternative that the
% distribution does not have zero median. x and y must have equal lengths.
% Note that a hypothesis of zero median for x-y is not equivalent to a
% hypothesis of equal median for x and y.    

%[p h stats]=ranksum(x,y) performs a two-sided rank sum test of the null hypothesis
% that data in the vectors x and y are independent samples from identical
% continuous distributions with equal medians, against the alternative that
% they do not have equal medians. x and y can have different lengths. The
% p-value of the test is returned in p. The test is equivalent to a
% Mann-Whitney U-test.


%2. correlations and partial correlations

sessions=1:10;%for example, check whether data values change linearly over recording sessions
data=sessions+(rand(1,10)-0.5)*10;%generate simulated data
plot(sessions,data,'ko','LineStyle','--','MarkerFaceColor','k');
xlim([0 11]);
formattedInput=[sessions' data'];

%Calculate the pairwise linear Pearson's correlation coefficient between two
%variables:
[rho p]=corr(formattedInput);
Rvalue=rho(2)
pval=p(2)
df=length(data)-2
sprintf(['r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval)

%Calculate the pairwise linear Spearman's correlation coefficient between two
%variables (uses rank order instead of actual values):
[rho p]=corr(formattedInput,'type','Spearman');
Rvalue=rho(2)
pval=p(2)
df=length(data)-2
sprintf(['r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval)

%Can also specify whether to perform one-tailed or two-tailed tests, e.g.
[rho p]=corr(formattedInput,'tail','right');
Rvalue=rho(2)
pval=p(2)
df=length(data)-2
sprintf(['r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval)

%Partial correlation to 'partition' out the effects of other variables:
sessions=1:20;%for example, check whether data values change linearly over recording sessions
data=sessions+(rand(1,20)-0.5)*10;%generate simulated data
otherVariable1=sessions+(rand(1,20)-0.5)*10;%generate simulated data for another variable, pattern of distribution is similar to that of 'data'
otherVariable2=(rand(1,20)-0.5)*10;%generate simulated data for another variable, dissimilar to 'data'
[rho p]=partialcorr(data',sessions',[otherVariable1' otherVariable2'])
%see what happens when the patterns underlying BOTH of the 'other variables' are
%similar to that of the original data:
otherVariable2=sessions+(rand(1,20)-0.5)*10;
[rho p]=partialcorr(data',sessions',[otherVariable1' otherVariable2'])
%for the second calculation of rho, when both 'otherVariable1' and
%'otherVariable2' have similar patterns to 'data,' should find that the
%factor 'sessions' is less able to explain patterns in 'data' because effects
%of other variables are now taken into account 

%Note that corr is very similar to corrcoef


%3. ANOVA & non-parametric analogs

%1-way ANOVA to check whether means differ between groups:
load hogg
data=hogg;
% hogg =
%group 1     2     3     4     5
%     --------------------------
%     24    14    11     7    19
%     15     7     9     7    24
%     21    12     7     4    19
%     27    17    13     7    15
%     33    14    12    12    10
%     23    16    18    18    20
[p table stats] = anova1(data);
for columnInd=1:size(data,2)%calculate mean and variance for each group:
    dataStats(1,columnInd)=mean(data(:,columnInd));
    dataStats(2,columnInd)=var(data(:,columnInd));
end
dfBetween=table{2,3};
dfWithin=table{3,3};
Fstat=table{2,5};
[c m h]=multcompare(stats,'dimension',[1 2])%can specify the dimension(s) over which to calculate the population marginal means
%In figure generated by multcompare, axes are rotated 90 degrees clockwise, relative to those generated when calling anova function 
%Important note: remember that 'anova1' draws boxplots with 25% & 75%
%percentiles, whereas multcompare draws graphs with comparison intervals.
%Only the latter (comparison intervals) are indicative of significance of
%overlap between groups.
%Report the F statistic, the between-groups df (the first number in
%brackets), the within-groups df (the second number in brackets), and the
%p-value 
sprintf(['F(',num2str(dfBetween),',',num2str(dfWithin),') = ',num2str(Fstat),', p = %.4f'],p)

%N-way ANOVA to check whether means differ between groups, depending on n
%factors:
load hogg
data=hogg;
%Let's say that group number is a factor-
numValsPerGroup=size(data,1);
groupAssignment=[];
for groupInd=1:size(data,2)%for each group, create 'coding' index
    groupAssignment=[groupAssignment zeros(numValsPerGroup,1)+groupInd];
end
% groupAssignment =
%      1     2     3     4     5
%      1     2     3     4     5
%      1     2     3     4     5
%      1     2     3     4     5
%      1     2     3     4     5
%      1     2     3     4     5
%Let's also say that some other independent variable, such as recording
%day, is a factor, and that the first 3 rows correspond to Day 1, while the
%bottom 3 rows correspond to Day 2-
dayAssignment=[];%for each day, create 'coding' index
for groupInd=1:size(data,2)
    dayAssignment=[dayAssignment [1;1;1;2;2;2]];
end
% dayAssignment =
%      1     1     1     1     1
%      1     1     1     1     1
%      1     1     1     1     1
%      2     2     2     2     2
%      2     2     2     2     2
%      2     2     2     2     2
formattedData=data(:);
formattedGroupAssignment=groupAssignment(:);
formattedDayAssignment=dayAssignment(:);
%Run the 2-way ANOVA without examining interaction effects between the two
%factors (just examine main effects):
[p,table,stats,terms]=anovan(formattedData,{formattedGroupAssignment formattedDayAssignment})
%Run the 2-way ANOVA with an examination of interactions and main effects:
[p,table,stats,terms]=anovan(formattedData,{formattedGroupAssignment formattedDayAssignment},'model','full')
[p,table,stats,terms]=anovan(formattedData,{formattedGroupAssignment formattedDayAssignment},'model','interaction')

%Note: for non-parametric data, use rank order instead of actual values,
%e.g. a Kruskal-Wallis test (the non-parametric equivalent of a 1-way
%ANOVA):
 p=kruskalwallis(data)%each column in the data corresponds to a group
 %or a Friedman's test (as a non-parametric version of a 2-way ANOVA):
 reps=2;%specifies that each pair of rows corresponds to a repetition
 p=friedman(data,reps)

 
%4. Lilliefors test for normality:

%Perform a Lilliefors test of the default null
%hypothesis that the sample in vector x comes from a distribution in the
%normal family, against the alternative that it does not come from a
%normal distribution.
mu=10;
sigma=5;
x=normrnd(mu,sigma,1,100);%generate 100 values that form a normal distribution
[h p kstat critval]=lillietest(x) 


%5. measure of skewness:

mu=10;
sigma=5;
x=normrnd(mu,sigma,1,100);%generate 100 values that form a normal distribution
skewnessMeasure=skewness(x)
%If skewness is negative, this means that the data are spread out more to
%the left of the mean than to the right. If skewness is positive, the data
%are spread out more to the right. The skewness of the normal distribution
%(or any perfectly symmetric distribution) is zero.
xSkewed=x.^2;%create a positively skewed distribution
skewnessMeasure=skewness(xSkewed)


%6. measure of kurtosis:

mu=10;
sigma=5;
x=normrnd(mu,sigma,1,100);%generate 100 values that form a normal distribution
kurtosisMeasure=kurtosis(x)
%Kurtosis is a measure of how 'peaked' a distribution is. The kurtosis
%of the normal distribution is 3. Distributions that are more outlier-prone
%than the normal distribution have kurtosis greater than 3; distributions
%that are less outlier-prone have kurtosis less than 3.  


%7. tests for scedasticity:

% Perform a Bartlett test of the null hypothesis that the columns of data
% vector x come from normal distributions with the same variance (homoscedastic). 
%The alternative hypothesis is that not all columns of data have the same
% variance heteroscedastic). 
mu1=10;%mean
sigma1=5;%SD
mu2=14;
sigma2=10;%try it with an SD that is closer to the SD of the first distribution, e.g. sigma2=6;
x1=normrnd(mu1,sigma1,100,1);%generate 100 values that form the first distribution
x2=normrnd(mu2,sigma2,100,1);%generate 100 values that form the second distribution
formattedInput=[x1 x2];%different groups separated by column
[p stats]=vartestn(formattedInput) 
%Perform a Levene's test for equal variances:
p = vartestn(formattedInput,[],'on','robust')
load carsmall;
p = vartestn(MPG,Model_Year,'TestType','LeveneAbsolute')%newer versions of Matlab
p = vartestn(MPG,Model_Year,'on','robust')%older versions of Matlab
%Perform a Brown-Forsythe test for equal variances:
load examgrades;
[p,stats] = vartestn(grades,'TestType','BrownForsythe','Display','on')%newer versions of Matlab


%8. Chi-square test of variance:
mu=10;%mean
sigma=5;%standard deviation
x=normrnd(mu,sigma,1,100);%generate 100 values that form a normal distribution
v=sigma^2;%hypothesized variance (variance=SD^2)
[h p ci stats]=vartest(x,v)


%9. Chi-square goodness of fit test:
%Perform a chi-square goodness-of-fit test of the default
%null hypothesis that the data in vector x are a random sample from a
%normal distribution with mean and variance estimated from x, against the
%alternative that the data are not normally distributed with the estimated
%mean and variance.    
[h p ci stats]=chi2gof(x)
%for example:
observedOrientations=rand(1000,1)*180;%create simulated data consisting of 1000 values, from a uniform distribution with a range of 0 to 180
edges=linspace(0,180,4)%create a certain number of bins (specify number of edges)
expectedCounts=zeros(1,length(edges)-1)+length(observedOrientations)/(length(edges)-1)
[h p stats]=chi2gof(observedOrientations,'edges',edges,'expected',expectedCounts)
%Report the degrees of freedom, the sample size, the Chi-square value, and the p-value:
sprintf(['X(',num2str(stats.df),',',num2str(length(observedOrientations)),') = ',num2str(stats.chi2stat),', p = %.4f'],p)
%another example, this time using a non-uniform distribution:
mu=1;%mean
sigma=2;%SD
observedOrientations=normrnd(mu,sigma,1000,1)*180;%create simulated data consisting of 1000 values, from a normal (i.e. non-uniform) distribution with a range of 0 to 180
edges=linspace(0,180,4)%create a certain number of bins (specify number of edges)
expectedCounts=zeros(1,length(edges)-1)+length(observedOrientations)/(length(edges)-1)
[h p stats]=chi2gof(observedOrientations,'edges',edges,'expected',expectedCounts)
%Report the degrees of freedom, the sample size, the Chi-square value, and the p-value:
sprintf(['X(',num2str(stats.df),',',num2str(length(observedOrientations)),') = ',num2str(stats.chi2stat),', p = %.4f'],p)


%10. Pearson's Chi-square test of independence:

%table = crosstab(x1,x2) returns a cross-tabulation table of two vectors of
%the same length x1 and x2. table is m-by-n, where m is the number of
%distinct values in x1 and n is the number of distinct values in x2. 
%x1 and x2 are grouping variables. 
%table(i,j) is a count of indices where grp2idx(x1) is i and grp2idx(x2) is
%j. The numerical order of grp2idx(x1) and grp2idx(x2) order rows and columns of table, respectively.      
%[table,chi2,p] = crosstab(x1,...,xn) also returns the chi-square statistic chi2 and its p value p for a test that table is independent in each dimension. The null hypothesis is that the proportion in any entry of table is the product of the proportions in each dimension.
[table chi2 p]=crosstab(x1,x2)


%11. tests for circular statistics (e.g. a von Mises distribution)

%Download circstat toolbox and add paths to the folder containing the
%circstats functions. This demontrates a few handy functions; there are
%many more.
observedOrientations=rand(100,1)*360;%create simulated data from a uniform distribution with a range of 0 to 360
convertedOri=observedOrientations/180*pi;%convert to radians
%Plot data:
figure
rho=ones(length(convertedOri),1)-0.25;%slightly shorter stem
[x,y] = pol2cart(convertedOri,rho);
handle=compass(x,y); hold on
set(handle,{'Color'},{[1 0 0]},'LineWidth',2)

%Rayleigh test to identify unimodal deviation from uniformity:
pRayleigh=circ_rtest(convertedOri);

%Omnibus test to identify multimodal deviations from uniformity:
pOmnibus=circ_otest(convertedOri);

%Watson-Williams test to compare means of two samples. (N.A. if not enough
%data present). Performs like a one-way ANOVA test for circular data
observedOrientations2=rand(20,1)*180;%create simulated data from a uniform distribution with a range of 0 to 360
convertedOri2=observedOrientations2/180*pi;%convert to radians
[p stats]=circ_wwtest(convertedOri',convertedOri2');
%Plot data:
shortenStemFactor=2;%set to two to make arrows half the length
rho=ones(length(convertedOri2),1)-0.25*shortenStemFactor;%slightly shorter stem
[x,y] = pol2cart(convertedOri2,rho);
handle=compass(x,y); hold on
set(handle,{'Color'},{[0 0 1]},'LineWidth',2)


%12. test goodness-of-fit for regression:
figure
numVals=20;
x=[1:numVals]';
y=x+normrnd(1,2,numVals,1);
%Introduce an outlier to examine how robust fitting compares with ordinary
%least squares:
y(numVals)=y(1);
scatter(x,y,'filled','r');
hold on
%To perform a multilinear regression which is robust to outliers:
%B = ROBUSTFIT(X,Y) returns the vector B of regression coefficients,
%   obtained by performing robust regression to estimate the linear model
%   Y = Xb.  X is an n-by-p matrix of predictor variables, and Y is an
%   n-by-1 vector of observations.
[brob stats]=robustfit(x,y)%brob(1) is the intercept of the best-fit line; brob(2) is the slope
stats.p%returns p-values for each coefficient in the model, indicating 
%whether a given coefficient differes significantly from zero. 
stats.p(2)%Good for checking whether the slope of a regression line is 
%significantly different from zero.
plot(x,brob(1)+brob(2)*x,'k','LineWidth',2)
%To perform a multiple linear regression using least squares:
%   B = REGRESS(Y,X) returns the vector B of regression coefficients in the
%   linear model Y = X*B.  X is an n-by-p design matrix, with rows
%   corresponding to observations and columns to predictor variables.  Y is
%   an n-by-1 vector of response observations.
[bls bint r rint stats]=regress(y,[ones(numVals,1) x])
%The vector STATS contains, in the following order: the R-square statistic,
%the F statistic and p value for the full model, and an estimate of the error variance.
stats(3)%This is the p-value for the whole model (from the F test for 
%whether the model fits significantly better than the null model,
%'y = constant'- as opposed to the current model with a slope and an
%intercept, 'y = b + ax').
plot(x,bls(1)+bls(2)*x,'b','LineWidth',2);
%Notice how the outlier affects curve fitting when using an ordinary least
%squares approach, whereas robustfit remains unaffected.


%Alternatively, use the fitlm function:
load hospital
y = hospital.BloodPressure(:,1);
X = double(hospital(:,2:5));
mdl = fitlm(X,y)%Requires newer version of Matlab
mdl.Rsquared.Ordinary
mdl.Rsquared.Adjusted

close all hidden%command used to close statistical tables as well as ordinary figures