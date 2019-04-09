function testsim_dprime_2AFC_type2std
% d' 2AFC and meta-d', using http://www.columbia.edu/~bsm2105/type2sdt/
% uses type2sdt 

% % INPUTS
% stimID:   1xN vector. stimID(i) = 0 --> stimulus on i'th trial was S1.
%                       stimID(i) = 1 --> stimulus on i'th trial was S2.
%
% response: 1xN vector. response(i) = 0 --> response on i'th trial was "S1".
%                       response(i) = 1 --> response on i'th trial was "S2".
%
% rating:   1xN vector. rating(i) = X --> rating on i'th trial was X.
%                       X must be in the range 1 <= X <= nRatings.

rating_scale = [1 2 3 4 5 6];
nRatings	= length(rating_scale);

% random performance and certainty rating
stimID		= [zeros(1,30) ones(1,30)];
response	= randsample([0 1],60,1);
rating		= randsample(rating_scale,60,1);

% good performance, random certainty rating
stimID		= [zeros(1,30) ones(1,30)];
response	= [zeros(1,25) ones(1,5) ones(1,25) zeros(1,5)];
rating		= randsample(rating_scale,60,1);

% good performance, good certainty rating
stimID		= [zeros(1,30) ones(1,30)];
response	= [zeros(1,25) ones(1,5) ones(1,25) zeros(1,5)];
rating		= [randsample(rating_scale,25,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,5,1,[0.3 0.2 0.2 0.15 0.1 0.05])...
		   randsample(rating_scale,25,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,5,1,[0.3 0.2 0.2 0.15 0.1 0.05])];
	   
% bad performance, good certainty rating
stimID		= [zeros(1,30) ones(1,30)];
response	= [zeros(1,18) ones(1,12) ones(1,18) zeros(1,12)];
rating		= [randsample(rating_scale,18,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,12,1,[0.3 0.2 0.2 0.15 0.1 0.05])...
		   randsample(rating_scale,18,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,12,1,[0.3 0.2 0.2 0.15 0.1 0.05])];


% good performance, almost optimal certainty rating
stimID		= [zeros(1,30) ones(1,30)];
response	= [zeros(1,25) ones(1,5) ones(1,25) zeros(1,5)];
rating		= [randsample(rating_scale,25,1,[0.025 0.025 0.025 0.025 0.05 0.85]) randsample(rating_scale,5,1,[0.85 0.05 0.025 0.025 0.025 0.025])...
		   randsample(rating_scale,25,1,[0.025 0.025 0.025 0.025 0.05 0.85]) randsample(rating_scale,5,1,[0.85 0.05 0.025 0.025 0.025 0.025])];

% good performance for S1 but not so good for S2, good certainty rating
stimID		= [zeros(1,150) ones(1,150)];
response	= [zeros(1,148) ones(1,2) ones(1,100) zeros(1,50)];
rating		= [randsample(rating_scale,148,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,2,1,[0.3 0.2 0.2 0.15 0.1 0.05])...
		   randsample(rating_scale,100,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,50,1,[0.3 0.2 0.2 0.15 0.1 0.05])];
	   
% good performance for S1 but not so good for S2, not good certainty rating
stimID		= [zeros(1,150) ones(1,150)];
response	= [zeros(1,148) ones(1,2) ones(1,100) zeros(1,50)];
rating		= [randsample(rating_scale,148,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,2,1,[0 0.1 0.15 0.2 0.2 0.35])...
		   randsample(rating_scale,100,1,[0.05 0.1 0.15 0.2 0.2 0.3]) randsample(rating_scale,50,1,[0 0.1 0.15 0.2 0.2 0.35])];

% CIKO023
% left S1, right S2
load('Data_CIKO231_2019-01-16_01.mat');
idx_completed	= find(stimID==1 | stimID==0);
stimID		= stimID(idx_completed);
response	= response(idx_completed);
rating		= rating(idx_completed);

	   
[nR_S1, nR_S2] = trials2counts(stimID, response, rating, nRatings,0,0);

% basic d'
% the question has to be reformulated from "is there S1 or S2?" to "is there S1?"

Hits			= sum(stimID == 0 & response == 0);
Misses			= sum(stimID == 0 & response == 1);
FalseAlarms		= sum(stimID == 1 & response == 0);
CorrectRejections	= sum(stimID == 1 & response == 1);

pHit = Hits / (Hits + Misses);
pFA = FalseAlarms / (FalseAlarms + CorrectRejections);

[d_prime,beta] = testsim_dprime(pHit,pFA)

out = type2_SDT_SSE(nR_S1, nR_S2)

testsim_rocCurve_confidence(rating, stimID==response, 1);





