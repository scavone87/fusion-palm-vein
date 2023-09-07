%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BioMetric Data Representation   %
% April 2010 - Alessandro Savoia  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%PREPROCESSING MODULE%%%%%%%%
clear all
close all
clc

init_bio
probes_bio
depths_bio
data_bio
crop_bio
interp_bio

save data.mat M X Y Z 

