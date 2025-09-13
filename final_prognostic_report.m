% =========================================================================
% DEFINITIVE PROGNOSTIC & DECISION SUPPORT REPORT (Final Corrected Version)
% =========================================================================
% This definitive version includes all previous logic and adds a command
% to force a stable graphics renderer, fixing the final visual bug.

clear; close all; clc;

% --- BULLETPROOF GRAPHICS FIX ---
% This command forces MATLAB to use a more stable graphics engine, which
% should resolve the issue with the scrambled bottom plot.
set(groot, 'defaultfigurerenderer', 'painters');

%% --- Step 1: Configuration and Model Loading ---
disp('Loading the trained MLP model...');
load('battery_soh_model.mat'); % Loads 'net' and 'ps'

% --- Define Input Data for the Battery Being Assessed ---
cycle_number = 1000;
avg_temp = 42.5;
internal_resistance = 0.99;
current_data_point = [cycle_number, avg_temp, internal_resistance];

% --- Define System Parameters ---
ev_eol_threshold = 80;
second_life_eol_threshold = 60;
nominal_cell_capacity_Ah = 0.740;
nominal_cell_voltage = 3.7;
price_per_kWh_used = 50;
co2_saved_per_kWh = 150;

%% --- Step 2: Current Health Assessment using MLP Model ---
disp('Performing current health assessment with MLP model...');
normalized_data = mapminmax('apply', current_data_point', ps);
predicted_soh_percent = net(normalized_data) * 100;

%% --- Step 3: Generate a Realistic Future Prognosis ---
disp('Generating a realistic future prognosis...');
future_cycles = cycle_number:100:cycle_number+5000;
a = -0.0000003; 
b = -0.002;
c = predicted_soh_percent/100 - (a*cycle_number^2 + b*cycle_number);
soh_trajectory_fractional = a*future_cycles.^2 + b*future_cycles + c;
soh_trajectory = soh_trajectory_fractional * 100;

%% --- Step 4: Calculate RUL and Other Key Metrics ---
disp('Calculating RUL, Economic Value, and Environmental Impact...');
idx_rul = find(soh_trajectory <= second_life_eol_threshold, 1, 'first');
if ~isempty(idx_rul)
    rul_cycles = future_cycles(idx_rul) - cycle_number;
else
    rul_cycles = NaN; 
end
remaining_kWh = (nominal_cell_capacity_Ah * nominal_cell_voltage / 1000) * (predicted_soh_percent / 100);
second_life_value = remaining_kWh * price_per_kWh_used;
co2_saved = remaining_kWh * co2_saved_per_kWh;

%% --- Step 5: Generate and Export Final Report ---
report_text = generate_text_report(current_data_point, predicted_soh_percent, rul_cycles, second_life_value, co2_saved, ev_eol_threshold, second_life_eol_threshold);
disp(report_text);
generate_visual_report(predicted_soh_percent, future_cycles, soh_trajectory, rul_cycles, ev_eol_threshold, second_life_eol_threshold);
disp('Visual report has been generated in a new figure window.');
fileID = fopen('final_battery_report.txt','w');
fprintf(fileID, '%s', report_text);
fclose(fileID);
disp('Report saved to final_battery_report.txt');

%% --- Helper Functions ---
function report_str = generate_text_report(inputs, soh, rul, value, co2, ev_eol, s_eol)
    header = sprintf('\n==================================================\n   *** BATTERY PROGNOSTIC & DECISION SUPPORT REPORT ***\n==================================================\n');
    gen_time = sprintf('Generated on: %s\n', datestr(now));
    input_params = sprintf('\n--- INPUT PARAMETERS ---\n - Cycle Number: %d\n - Average Temperature: %.1f C\n - Internal Resistance: %.4f Ohms\n', inputs(1), inputs(2), inputs(3));
    predict_result = sprintf('\n--- CURRENT HEALTH ASSESSMENT (via MLP Model) ---\n - Estimated State of Health (SOH): %.2f %%\n', soh);
    if soh >= ev_eol
        grade = 'A (First Life)'; status = 'Healthy for EV use.'; rec = 'Continue normal operation.';
    elseif soh >= s_eol
        grade = 'B (Second Life Candidate)'; status = 'Retired from EV use.'; rec = 'Repurpose for "Second Life" to prevent e-waste.';
    else
        grade = 'C (Recycling Candidate)'; status = 'End of usable life.'; rec = 'Prioritize for responsible recycling.';
    end
    recommendation = sprintf('\n--- GRADING & RECOMMENDATION ---\n - GRADE: %s\n - STATUS: %s\n - RECOMMENDATION: %s\n', grade, status, rec);
    rul_section = sprintf('\n--- FUTURE PROGNOSIS (until %.0f%% SOH) ---\n', s_eol);
    if ~isnan(rul)
        rul_data = sprintf(' - Estimated Remaining Useful Life (RUL): ~%d Cycles\n', rul);
    else
        rul_data = sprintf(' - Estimated Remaining Useful Life (RUL): Exceeds simulation window (>%d cycles remaining)\n', 5000);
    end
    impact_section = sprintf('\n--- E-WASTE REDUCTION IMPACT ASSESSMENT ---\n');
    impact_data = sprintf(' - Estimated Second-Life Market Value: $%.2f\n - Estimated Environmental Benefit: %.1f kg of CO2 emissions saved\n', value, co2);
    footer = sprintf('==================================================\n');
    report_str = [header, gen_time, input_params, predict_result, recommendation, rul_section, rul_data, impact_section, impact_data, footer];
end

function generate_visual_report(soh, cycles, trajectory, rul, ev_eol, s_eol)
    figure('Name', 'Definitive Prognostic Report', 'Position', [100, 100, 1200, 600]);
    ax_fontsize = 12; title_fontsize = 14;
    
    subplot(2, 1, 1);
    barh(1, soh, 'FaceColor', [0.1, 0.6, 0.8], 'DisplayName', 'Current SOH'); hold on;
    xline(ev_eol, 'Color', [0.85, 0.33, 0.1], 'LineStyle', '--', 'LineWidth', 2.5, 'DisplayName', 'EV EoL (80%)');
    xline(s_eol, 'Color', [0.93, 0.69, 0.13], 'LineStyle', '-.', 'LineWidth', 2.5, 'DisplayName', 'Recycle Threshold (60%)');
    hold off;
    set(gca, 'YTick', [], 'FontSize', ax_fontsize); 
    xlim([s_eol-5, 105]);
    xlabel('State of Health (%)', 'FontSize', ax_fontsize, 'FontWeight', 'bold');
    title('Current Health Assessment (MLP Model)', 'FontSize', title_fontsize, 'FontWeight', 'bold');
    grid on;
    text(soh - 10, 1, sprintf('%.2f %%', soh), 'FontWeight', 'bold', 'Color', 'white', 'FontSize', 12);
    legend('show', 'Location', 'southeast', 'FontSize', 11);
    
    subplot(2, 1, 2);
    plot(cycles, trajectory, 'Color', [0.1, 0.6, 0.8], 'LineWidth', 2.5, 'DisplayName', 'Predicted Degradation Path'); hold on;
    plot(cycles(1), soh, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r', 'DisplayName', 'Current State');
    yline(s_eol, 'Color', [0.93, 0.69, 0.13], 'LineStyle', '-.', 'LineWidth', 2.5, 'HandleVisibility','off');
    text(cycles(end), s_eol, 'Recycle Threshold (60%)', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 10, 'Color', [0.93, 0.69, 0.13]);
    if ~isnan(rul)
        rul_cycle_point = cycles(1) + rul;
        plot_idx = find(cycles>=rul_cycle_point,1,'first');
        plot([rul_cycle_point, rul_cycle_point], [s_eol, trajectory(plot_idx)], 'Color', [0.5, 0.5, 0.5], 'LineStyle', ':', 'LineWidth', 2, 'HandleVisibility','off');
        text(rul_cycle_point, s_eol + 5, sprintf('RUL: ~%d cycles', rul), 'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'BackgroundColor', 'white', 'FontSize', 11, 'Color', 'k');
    end
    hold off;
    ylim([s_eol-5, 105]); xlim([cycles(1), cycles(end)]);
    xlabel('Cycle Number', 'FontSize', ax_fontsize, 'FontWeight', 'bold');
    ylabel('Predicted SOH (%)', 'FontSize', ax_fontsize, 'FontWeight', 'bold');
    title('Future Prognosis & RUL (Demonstration Model)', 'FontSize', title_fontsize, 'FontWeight', 'bold');
    grid on;
    legend('show', 'Location', 'northeast', 'FontSize', 11);
end