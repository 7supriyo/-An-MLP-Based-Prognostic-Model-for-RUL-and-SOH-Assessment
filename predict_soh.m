% =========================================================================
% PART 3: USING THE TRAINED MODEL TO MAKE A PREDICTION
% =========================================================================
% This script loads the pre-trained MLP model ('battery_soh_model.mat')
% and uses it to predict the State of Health (SOH) of a new,
% hypothetical battery data point.

clear; close all; clc;

%% --- Step 1: Load the Trained Model and Normalization Settings ---
disp('Loading the trained model...');
try
    load('battery_soh_model.mat'); % This loads 'net' and 'ps' into the workspace
    disp('Model loaded successfully.');
catch
    error('Model file "battery_soh_model.mat" not found. Please run the training script (Part 2) first.');
end


%% --- Step 2: Define a New Data Point for Prediction ---
% This is where you would input the measured data from a real battery.
% The features MUST be in the same order as our training data:
% Feature 1: cycle_number
% Feature 2: avg_temp
% Feature 3: internal_resistance

disp('Defining a new data point to predict...');

% Example Scenario: We have a battery from the field that has been in use.
% We run a short test and measure its current parameters.
cycle_number = 5000;
avg_temp = 42.1; % degrees C
internal_resistance = 0.105; % Ohms

new_data_point = [cycle_number, avg_temp, internal_resistance];

fprintf('\nPredicting SOH for the following battery condition:\n');
fprintf(' - Cycle Number: %d\n', new_data_point(1));
fprintf(' - Average Temperature: %.1f C\n', new_data_point(2));
fprintf(' - Internal Resistance: %.4f Ohms\n', new_data_point(3));


%% --- Step 3: Preprocess the New Data ---
% IMPORTANT: We MUST normalize this new data using the exact same settings ('ps')
% that were used for the original training data. The 'apply' command does this.
normalized_data = mapminmax('apply', new_data_point', ps);


%% --- Step 4: Make the Prediction ---
% Feed the normalized data into the trained network ('net') to get the prediction.
predicted_soh_fractional = net(normalized_data);

% The output of the network is a fraction (e.g., 0.82).
% We convert it to a percentage for a more user-friendly result.
predicted_soh_percent = predicted_soh_fractional * 100;


%% --- Step 5: Display the Final Result ---
% This is the final output of our entire project.
fprintf('\n==================================================\n');
fprintf('           PREDICTION RESULT\n');
fprintf('--------------------------------------------------\n');
fprintf('   Estimated State of Health (SOH) = %.2f %%\n', predicted_soh_percent);
fprintf('==================================================\n');