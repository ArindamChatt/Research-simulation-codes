% Case 1 Data
line_rate_1 = 25e9;
Bm_values_1 = linspace(100e6, 1e9, 20);
NT_1 = 128;
max_split_ratio_1 = 128;
Pport_1 = 20;
DS_1 = 25e9;
US_1 = 25e9;
uplink_power_1 = 121;
Nport_per_rack_1 = 60;
eta_dc_1 = 0.8;
CO_site_factor_1 = 1.6;
PON_1 = 1;
PT_1 = 0.9;
violation_1 = 0.10;
P_CO_values_1 = zeros(size(Bm_values_1));
poisson_prob_1 = @(NA, r) (NA.^r .* exp(-NA)) ./ factorial(r);

for i = 1:length(Bm_values_1)
    Bm = Bm_values_1(i);
    if Bm >= 200e6
        selected_S = NaN;
        for S = linspace(max_split_ratio_1, 2, 500)
            NA = PON_1 * S;
            r_max = ceil(line_rate_1 / Bm);
            r_max = max(r_max, 1);
            prob = sum(poisson_prob_1(NA, 1:r_max));
            if prob >= (PT_1 - violation_1)
                selected_S = S;
                break;
            end
        end
        if isnan(selected_S)
            P_CO_values_1(i) = NaN;
            continue;
        end
        Nport = ceil(NT_1 / selected_S);
        Nrack = ceil(Nport / Nport_per_rack_1);
        P_CO = CO_site_factor_1 * (1 / eta_dc_1) * ...
               (Nport * (Pport_1 + (DS_1 + US_1) * 1e-9) + Nrack * uplink_power_1);
        P_CO_values_1(i) = P_CO/NT_1 + 8.45;
    else
        selected_S = 128;
        Nport = ceil(NT_1 / selected_S);
        Nrack = ceil(Nport / Nport_per_rack_1);
        P_CO = CO_site_factor_1 * (1 / eta_dc_1) * ...
               (Nport * (Pport_1 + (DS_1 + US_1) * 1e-9) + Nrack * uplink_power_1);
        P_CO_values_1(i) = P_CO/NT_1 + 8.45;
    end
end

% Case 2 Data
line_rate_2 = 50e9;
Bm_values_2 = linspace(100e6, 1e9, 20);
NT_2 = 128;
max_split_ratio_2 = 128;
Pport_2 = 20;
DS_2 = 5*10e9;
US_2 = 50e9;
uplink_power_2 = 121;
Nport_per_rack_2 = 60;
eta_dc_2 = 0.8;
CO_site_factor_2 = 1.6;
PON_2 = 1;
PT_2 = 0.9;
violation_2 = 0.10;
P_CO_values_2 = zeros(size(Bm_values_2));
poisson_prob_2 = @(NA, r) (NA.^r .* exp(-NA)) ./ factorial(r);

for i = 1:length(Bm_values_2)
    Bm = Bm_values_2(i);
    if Bm >= 300e6
        selected_S = NaN;
        for S = linspace(max_split_ratio_2, 2, 500)
            NA = PON_2 * S;
            r_max = ceil(line_rate_2 / Bm);
            r_max = max(r_max, 1);
            prob = sum(poisson_prob_2(NA, 1:r_max));
            if prob >= (PT_2 - violation_2)
                selected_S = S;
                break;
            end
        end
        if isnan(selected_S)
            P_CO_values_2(i) = NaN;
            continue;
        end
        Nport = ceil(NT_2 / selected_S);
        Nrack = ceil(Nport / Nport_per_rack_2);
        P_CO = CO_site_factor_2 * (1 / eta_dc_2) * ...
            (Nport * (Pport_2 + (DS_2 + US_2) * 1e-9) + Nrack * uplink_power_2);
        P_CO_values_2(i) = P_CO/NT_2 + 8.45;
    else
        selected_S = 128;
        Nport = ceil(NT_2 / selected_S);
        Nrack = ceil(Nport / Nport_per_rack_2);
        P_CO = CO_site_factor_2 * (1 / eta_dc_2) * ...
            (Nport * (Pport_2 + (DS_2 + US_2) * 1e-9) + Nrack * uplink_power_2);
        P_CO_values_2(i) = P_CO/NT_2 + 8.45;
    end
end

% Case 3 Data
line_rate_3 = 25e9;
Bm_values_3 = linspace(100e6, 1e9, 10);
NT_3 = 256;
max_split_ratio_3 = 256;
Pport_3 = 20;
DS_3 = 25e9;
US_3 = 25e9;
uplink_power_3 = 121;
Nport_per_rack_3 = 60;
eta_dc_3 = 0.8;
CO_site_factor_3 = 1.6;
PON_3 = 1;
PT_3 = 0.9;
violation_3 = 0.10;
P_CO_values_3 = zeros(size(Bm_values_3));
poisson_prob_3 = @(NA, r) (NA.^r .* exp(-NA)) ./ factorial(r);

for i = 1:length(Bm_values_3)
    Bm = Bm_values_3(i);
    if Bm >= 200e6
        selected_S = NaN;
        for S = linspace(max_split_ratio_3, 2, 500)
            NA = PON_3 * S;
            r_max = ceil(line_rate_3 / Bm);
            r_max = max(r_max, 1);
            prob = sum(poisson_prob_3(NA, 1:r_max));
            if prob >= (PT_3 - violation_3)
                selected_S = S;
                break;
            end
        end
        if isnan(selected_S)
            P_CO_values_3(i) = NaN;
            continue;
        end
        Nport = ceil(NT_3 / selected_S);
        Nrack = ceil(Nport / Nport_per_rack_3);
        P_CO = CO_site_factor_3 * (1 / eta_dc_3) * ...
            (Nport * (Pport_3 + (DS_3 + US_3) * 1e-9) + Nrack * uplink_power_3);
        P_CO_values_3(i) = P_CO / NT_3 + 8.45;
    else
        selected_S = 256;
        Nport = ceil(NT_3 / selected_S);
        Nrack = ceil(Nport / Nport_per_rack_3);
        P_CO = CO_site_factor_3 * (1 / eta_dc_3) * ...
            (Nport * (Pport_3 + (DS_3 + US_3) * 1e-9) + Nrack * uplink_power_3);
        P_CO_values_3(i) = P_CO / NT_3 + 8.45;
    end
end

% Case 4 Data
line_rate_4 = 50e9;
Bm_values_4 = linspace(100e6, 1e9, 10);
NT_4 = 256;
max_split_ratio_4 = 256;
Pport_4 = 20;
DS_4 = 4*10e9;
US_4 = 4*2.5e9;
uplink_power_4 = 121;
Nport_per_rack_4 = 60;
eta_dc_4 = 0.8;
CO_site_factor_4 = 1.6;
PON_4 = 1;
PT_4 = 0.9;
violation_4 = 0.10;
P_CO_values_4 = zeros(size(Bm_values_4));
poisson_prob_4 = @(NA,r) (NA.^r .* exp(-NA)) ./ factorial(r);
poisson_cdf_4  = @(NA,rmax) sum(poisson_prob_4(NA,1:rmax));

for i = 1:numel(Bm_values_4)
    Bm = Bm_values_4(i);
    if Bm >= 400e6
        selected_S = NaN;
        for S = linspace(max_split_ratio_4, 2, 500)
            NA    = PON_4 * S;
            r_max = max(1, ceil(line_rate_4 / Bm));
            prob  = poisson_cdf_4(NA, r_max);
            if prob >= (PT_4 - violation_4)
                selected_S = S;
                break
            end
        end
        if isnan(selected_S)
            P_CO_values_4(i) = NaN;
            continue
        end
    else
        selected_S = max_split_ratio_4;
    end
    Nport = ceil(NT_4 / selected_S);
    Nrack = ceil(Nport / Nport_per_rack_4);
    P_CO = CO_site_factor_4 * (1/eta_dc_4) * ...
          (Nport * (Pport_4 + (DS_4 + US_4)*1e-9) + Nrack * uplink_power_4);
    P_CO_values_4(i) = P_CO/NT_4 + 8.45;
end
% =========================================================================
% FINAL MAXIMUM-VISIBILITY COMBINED PLOT SECTION
% This section creates an extremely magnified and bold plot.
% =========================================================================

figure('Name', 'Final Maximum-Visibility CO Power Plot'); 
grid on; 
hold on;

% --- Plot each case with highly magnified styles ---
% We are increasing LineWidth to 4 and MarkerSize to 12.

% Case 1: 25Gbps, 128 Users (Blue with Circles)
plot(Bm_values_1 / 1e6, P_CO_values_1, 'b-o', 'LineWidth', 4, ...
    'MarkerSize', 12, 'MarkerFaceColor', 'b', 'DisplayName', '25Gbps Line Rate, 128 Users');

% Case 2: 50Gbps, 128 Users (Red with Squares)
plot(Bm_values_2 / 1e6, P_CO_values_2, 'r-s', 'LineWidth', 4, ...
    'MarkerSize', 12, 'MarkerFaceColor', 'r', 'DisplayName', '50Gbps Line Rate, 128 Users');

% Case 3: 25Gbps, 256 Users (Green with Triangles)
plot(Bm_values_3 / 1e6, P_CO_values_3, 'g-^', 'LineWidth', 4, ...
    'MarkerSize', 12, 'MarkerFaceColor', 'g', 'DisplayName', '25Gbps Line Rate, 256 Users');
    
% Case 4: 50Gbps, 256 Users (Magenta with Diamonds)
plot(Bm_values_4 / 1e6, P_CO_values_4, 'm-d', 'LineWidth', 4, ...
    'MarkerSize', 12, 'MarkerFaceColor', 'm', 'DisplayName', '50Gbps Line Rate, 256 Users');

% --- Labels, Title, and Legend with Maximized Fonts ---
% We are using even larger, bold fonts for all text elements.

xlabel('Average Offered Bandwidth per User, B_m (Mbps)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Central Office Power Consumption per User (W)', 'FontSize', 16, 'FontWeight', 'bold');
title('Central Office Power Consumption vs. User Bandwidth Demand', 'FontSize', 18, 'FontWeight', 'bold');

% --- Maximize the Legend ---
lgd = legend('show', 'Location', 'best', 'FontSize', 16);
set(lgd, 'FontWeight', 'bold'); 

% --- Maximize the Axes Tick Marks ---
set(gca, 'FontSize', 16, 'FontWeight', 'bold');

hold off;
