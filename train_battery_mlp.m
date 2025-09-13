% =========================================================================
% PART 2: MLP MODEL TRAINING & ANALYSIS (Final Version)
% =========================================================================
% This script uses the validated features from Part 1 to train, validate,
% and test a Multi-Layer Perceptron (MLP) for SOH prediction.
% Its final output is the saved model file: 'battery_soh_model.mat'.

clear; close all; clc;

%% --- Step 1: Load, Consolidate, and Extract Features ---
disp('Step 1: Loading and extracting features...');
load('Oxford_Battery_Degradation_Dataset_1.mat');

% Consolidate data into a single 'data' struct from the separate
% 'Cell1', 'Cell2', etc. variables.
disp('Consolidating data structure...');
data = struct(); 
for i = 1:8
    variable_name = ['Cell' num2str(i)];
    data.(variable_name) = eval(variable_name);
end
disp('Data consolidated.');

% --- Feature Extraction Loop ---
% We will now loop through all the data to create our final dataset for training.
disp('Extracting features from all cells...');
nominal_capacity = 740;
feature_matrix = []; % Stores inputs: [cycle_number, avg_temp, internal_resistance]
target_vector = [];  % Stores output: [soh]
cell_names = fieldnames(data);

for i = 1:numel(cell_names)
    cell_id = cell_names{i};
    cycle_names = fieldnames(data.(cell_id));
    for j = 1:numel(cycle_names)
        cycle_id = cycle_names{j};
        try
            % Target (SOH) - using the corrected calculation
            discharge_data = data.(cell_id).(cycle_id).C1dc;
            capacity = max(abs(discharge_data.q));
            soh = capacity / nominal_capacity;
            
            % Feature 1: Cycle Number
            cycle_number = sscanf(cycle_id, 'cyc%d');
            
            % Feature 2: Average Temperature
            avg_temp = mean(discharge_data.T);
            
            % Feature 3: Internal Resistance - using the corrected calculation
            ocv_discharge = data.(cell_id).(cycle_id).OCVdc;
            delta_V = ocv_discharge.v(1) - ocv_discharge.v(10);
            current_in_amps = 0.040;
            internal_resistance = abs(delta_V / current_in_amps);
            
            % Add the data to our matrices, ensuring it is valid
            if ~isnan(internal_resistance) && ~isinf(internal_resistance)
                feature_matrix = [feature_matrix; [cycle_number, avg_temp, internal_resistance]];
                target_vector = [target_vector; soh];
            end
        catch
            continue; % Skip any cycles that have missing data
        end
    end
end
disp('Feature extraction complete.');
fprintf('Created a dataset with %d samples and %d features.\n', ...
        size(feature_matrix, 1), size(feature_matrix, 2));


%% --- Step 2: Data Preprocessing ---
disp('Step 2: Preprocessing data for the neural network...');
inputs = feature_matrix';
targets = target_vector';

% Normalize inputs to the range [-1, 1] for efficient training
[inputs_normalized, ps] = mapminmax(inputs);


%% --- Step 3: Define and Visualize the MLP Network ---
disp('Step 3: Creating and visualizing the MLP network...');

% A network with two hidden layers (20 neurons in the first, 10 in the second).
% This architecture is powerful enough to learn the complex degradation patterns.
hiddenLayerSizes = [20 10];
net = feedforwardnet(hiddenLayerSizes);

% Configure the data to be split into training (70%), validation (15%), and testing (15%)
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Display the network architecture diagram in a new window
figure('Name', 'MLP Network Architecture');
view(net);


%% --- Step 4: Train the Model ---
disp('Step 4: Training the network... (A training window will appear)');
% The 'train' function uses the backpropagation algorithm to learn from the data.
[net, tr] = train(net, inputs_normalized, targets);
disp('Training complete.');


%% --- Step 5: Analyze Performance with Graphs ---
disp('Step 5: Analyzing model performance on unseen test data...');

% Use the test data (which the model has never seen) to evaluate its performance
test_indices = tr.testInd;
x_test = inputs_normalized(:, test_indices);
y_test = targets(:, test_indices);
y_pred = net(x_test);

% Calculate the final performance metric: Root Mean Squared Error (RMSE)
errors = y_test - y_pred;
rmse = sqrt(mean(errors.^2));
fprintf('\n==================================================\n');
fprintf('Final Model Performance:\n');
fprintf('Root Mean Squared Error (RMSE) on Test Data = %.4f\n', rmse);
fprintf('This means our SOH prediction is, on average, off by only %.2f%%.\n', rmse*100);
fprintf('==================================================\n');

% --- Performance Graphs ---
% The Training Performance plot shows how the error decreased during training
figure('Name', 'Training Performance');
plotperform(tr);

% The Regression Plot shows how well the predicted SOH matches the actual SOH.
% For a good model, the data points should be very close to the 45-degree line.
figure('Name', 'SOH Prediction: Actual vs. Predicted (Test Data)');
plotregression(y_test, y_pred);

%% --- Step 6: Save the Trained Model ---
% This is the most important final step. It saves the 'net' (the model)
% and 'ps' (the normalization settings) to a file for Part 3.
disp('Saving trained model as `battery_soh_model.mat`...');
save('battery_soh_model.mat', 'net', 'ps');
disp('Part 2 Complete: Model is trained and saved.');