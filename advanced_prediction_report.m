% =========================================================================
% FINAL BATTERY PROGNOSTIC & HEALTH REPORT
% =========================================================================
% This final script generates a comprehensive report with:
% 1. A realistic aging model for more accurate projections.
% 2. Multiple "what-if" scenarios (Gentle, Normal, Harsh use).
% 3. A direct calculation of Remaining Useful Life (RUL).
% 4. Export of key data to a text file for tracking.

clear; close all; clc;

%% --- Step 1: Configuration and Model Loading ---
disp('Loading the trained model...');
load('battery_soh_model.mat'); % Loads 'net' and 'ps'

% --- Define Input Data for the Battery Being Assessed ---
cycle_number = 100;
avg_temp = 42.1;
internal_resistance = 0.105;
current_data_point = [cycle_number, avg_temp, internal_resistance];

% --- Define Health Thresholds ---
ev_eol_threshold = 80;
second_life_eol_threshold = 60;


%% --- Step 2: Build a Simple Aging Model for Realistic Projections ---
% To fix the unrealistic curve, we model how resistance increases with cycles.
% We'll fit a line to the historical data of a representative cell (Cell1).
disp('Building a simple degradation model for internal resistance...');
load('Oxford_Battery_Degradation_Dataset_1.mat'); % Load the full dataset
ir_history = [];
cycle_history = [];
for j = 1:numel(Cell1)
    cycle_id = ['cyc' num2str(j*100,'%04.f')];
    if isfield(Cell1, cycle_id)
        try
            ocv_discharge = Cell1.(cycle_id).OCVdc;
            delta_V = ocv_discharge.v(1) - ocv_discharge.v(10);
            ir_history = [ir_history; abs(delta_V / 0.040)];
            cycle_history = [cycle_history; j*100];
        catch
            continue
        end
    end
end
% Fit a 1st degree polynomial (a line) to the IR vs. Cycle data
p_resistance = polyfit(cycle_history, ir_history, 1);
resistance_slope = p_resistance(1); % How much IR increases per cycle
resistance_intercept = p_resistance(2);


%% --- Step 3: Generate Projections for Multiple Scenarios ---
disp('Generating future projections for multiple scenarios...');
% Create a future timeline
future_cycles = cycle_number:100:cycle_number+4000;

% Scenario 1: Current Projected Path (using the learned slope)
future_ir_normal = future_cycles * resistance_slope + resistance_intercept;
features_normal = [future_cycles', repmat(avg_temp, length(future_cycles), 1), future_ir_normal'];

% Scenario 2: Gentle Use (slower aging, e.g., 70% of the normal rate)
future_ir_gentle = future_cycles * (resistance_slope * 0.7) + resistance_intercept;
features_gentle = [future_cycles', repmat(avg_temp-1, length(future_cycles), 1), future_ir_gentle']; % Slightly cooler temp

% Scenario 3: Harsh Use (faster aging, e.g., 130% of the normal rate)
future_ir_harsh = future_cycles * (resistance_slope * 1.3) + resistance_intercept;
features_harsh = [future_cycles', repmat(avg_temp+1, length(future_cycles), 1), future_ir_harsh']; % Slightly hotter temp

% Normalize all scenarios
norm_features_normal = mapminmax('apply', features_normal', ps);
norm_features_gentle = mapminmax('apply', features_gentle', ps);
norm_features_harsh = mapminmax('apply', features_harsh', ps);

% Get SOH predictions for all scenarios
soh_traj_normal = net(norm_features_normal) * 100;
soh_traj_gentle = net(norm_features_gentle) * 100;
soh_traj_harsh = net(norm_features_harsh) * 100;


%% --- Step 4: Calculate Remaining Useful Life (RUL) ---
disp('Calculating Remaining Useful Life (RUL)...');
predicted_soh_percent = soh_traj_normal(1); % Get the current SOH from the new trajectory

% Find when the trajectory crosses the 60% threshold
idx_rul_normal = find(soh_traj_normal <= second_life_eol_threshold, 1, 'first');
idx_rul_gentle = find(soh_traj_gentle <= second_life_eol_threshold, 1, 'first');
idx_rul_harsh = find(soh_traj_harsh <= second_life_eol_threshold, 1, 'first');

rul_cycles_normal = future_cycles(idx_rul_normal) - cycle_number;
rul_cycles_gentle = future_cycles(idx_rul_gentle) - cycle_number;
rul_cycles_harsh = future_cycles(idx_rul_harsh) - cycle_number;


%% --- Step 5: Generate Final Report (Text & Graphs) ---
% Generate Text Report
report_text = generate_text_report(current_data_point, predicted_soh_percent, rul_cycles_normal, rul_cycles_gentle, rul_cycles_harsh, ev_eol_threshold, second_life_eol_threshold);
disp(report_text);

% Generate Visual Report
generate_visual_report(predicted_soh_percent, future_cycles, soh_traj_normal, soh_traj_gentle, soh_traj_harsh, ev_eol_threshold, second_life_eol_threshold);
disp('Visual report has been generated in a new figure window.');

% Export Data to File
disp('Exporting report to text file...');
fileID = fopen('battery_report.txt','w');
fprintf(fileID, '%s', report_text);
fclose(fileID);
disp('Report saved to battery_report.txt');

%% --- Helper Functions for Report Generation ---
function report_str = generate_text_report(inputs, soh, rul_n, rul_g, rul_h, ev_eol, s_eol)
    header = sprintf('\n==================================================\n      *** BATTERY PROGNOSTIC HEALTH REPORT ***\n==================================================\n');
    gen_time = sprintf('Generated on: %s\n', datestr(now));
    input_params = sprintf('\n--- INPUT PARAMETERS ---\n - Cycle Number: %d\n - Average Temperature: %.1f C\n - Internal Resistance: %.4f Ohms\n', inputs(1), inputs(2), inputs(3));
    predict_result = sprintf('\n--- PREDICTION RESULT ---\n - Estimated State of Health (SOH): %.2f %%\n', soh);
    
    if soh >= ev_eol
        grade = 'A (First Life)'; status = 'Healthy. Suitable for continued use in an Electric Vehicle.'; rec = 'Continue normal operation. Monitor health periodically.';
    elseif soh >= s_eol
        grade = 'B (Second Life Candidate)'; status = 'Retired from EV use, but retains significant capacity.'; rec = 'Repurpose for "Second Life" (e.g., home energy storage) to prevent e-waste.';
    else
        grade = 'C (Recycling Candidate)'; status = 'Reached end of usable life.'; rec = 'Prioritize for responsible recycling to recover valuable materials.';
    end
    recommendation = sprintf('\n--- GRADING & RECOMMENDATION ---\n - GRADE: %s\n - STATUS: %s\n - RECOMMENDATION: %s\n', grade, status, rec);
    
    rul_section = sprintf('\n--- REMAINING USEFUL LIFE (RUL) PROGNOSIS ---\n(Time until SOH reaches %.0f%%)\n', s_eol);
    rul_data = sprintf(' - Projected Normal Use: ~%d Cycles\n - Projected Gentle Use: ~%d Cycles (+%.0f%% life extension)\n - Projected Harsh Use:  ~%d Cycles (-%.0f%% life reduction)\n', rul_n, rul_g, 100*(rul_g-rul_n)/rul_n, rul_h, 100*(rul_n-rul_h)/rul_n);
    
    footer = sprintf('==================================================\n');
    report_str = [header, gen_time, input_params, predict_result, recommendation, rul_section, rul_data, footer];
end

function generate_visual_report(soh, cycles, traj_n, traj_g, traj_h, ev_eol, s_eol)
    figure('Name', 'Final Battery Prognostic Report', 'Position', [100, 100, 1200, 600]);
    
    % Top Plot: Health Gauge
    subplot(2, 1, 1);
    barh(1, soh, 'FaceColor', [0, 0.7, 0.2]); hold on;
    xline(ev_eol, 'r--', 'EV End-of-Life', 'LineWidth', 2);
    xline(s_eol, 'k-.', 'Recycle Threshold', 'LineWidth', 2); hold off;
    set(gca, 'YTick', []); xlim([s_eol-5, 105]);
    xlabel('State of Health (%)'); title('Current Battery Health Gauge'); grid on;
    legend('Current SOH', 'EV EoL (80%)', 'Recycle Threshold (60%)', 'Location', 'southeast');
    text(soh - 7, 1, sprintf('%.2f %%', soh), 'FontWeight', 'bold', 'Color', 'white');
    
    % Bottom Plot: RUL Scenarios
    subplot(2, 1, 2);
    plot(cycles, traj_g, 'g-', 'LineWidth', 2, 'DisplayName', 'Gentle Use Path'); hold on;
    plot(cycles, traj_n, 'b-', 'LineWidth', 2, 'DisplayName', 'Normal Use Path');
    plot(cycles, traj_h, 'm-', 'LineWidth', 2, 'DisplayName', 'Harsh Use Path');
    plot(cycles(1), soh, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Current State');
    yline(s_eol, 'k-.', 'Recycle Threshold (60%)', 'LineWidth', 2); hold off;
    ylim([s_eol-5, 105]); xlim([cycles(1), cycles(end)]);
    xlabel('Cycle Number'); ylabel('Predicted State of Health (%)');
    title('Prognosis: Remaining Useful Life (RUL) Scenarios'); grid on;
    legend('show', 'Location', 'northeast');
end