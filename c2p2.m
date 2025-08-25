clc; clear; close all;
% Constants
line_rate = 50e9; % Fixed Line Rate: 50 Gbps
Bm_values = linspace(100e6, 1e9, 20); % Vary Bm from 100 Mbps to 1 Gbps
PON = 1;
PT = 0.9;
violation = 0.10; % 10% violation allowed
NT = 128; % Max users in the system (fixed)
max_split_ratio = 128;

% XG-PON or similar parameters cahnged to TWDM
Pport = 20; % Power per OLT port (W)
DS = 5*10e9; % Downstream rate (bps)
US = 50e9; % Upstream rate (bps) TWDM
uplink_power = 121; % Uplink power per rack (W)
Nport_per_rack = 60; % Number of ports per rack
eta_dc = 0.8; % DC/DC conversion efficiency
CO_site_factor = 1.6; % Site power factor

% Poisson function
poisson_prob = @(NA, r) (NA.^r .* exp(-NA)) ./ factorial(r);

% Storage for power values
P_CO_values = zeros(size(Bm_values));
S_values = zeros(size(Bm_values));

% Loop through each Bm value
for i = 1:length(Bm_values)
    Bm = Bm_values(i);
    if Bm >= 300e6
        % Find optimal S satisfying the 10% violation condition
        selected_S = NaN;
        for S = linspace(max_split_ratio, 2, 500)
            NA = PON * S;
            r_max = ceil(line_rate / Bm);
            r_max = max(r_max, 1); % avoid empty sum
            prob = sum(poisson_prob(NA, 1:r_max));
            if prob >= (PT - violation)
                selected_S = S;
                S_values(i) = selected_S;
                break;
            end
        end
        if isnan(selected_S)
            warning('No valid S found for Bm = %.0f Mbps', Bm / 1e6);
            P_CO_values(i) = NaN;
            continue;
        end
        % Compute P_CO using Equation (6)
        Nport = ceil(NT / selected_S);
        Nrack = ceil(Nport / Nport_per_rack);
        P_CO = CO_site_factor * (1 / eta_dc) * ...
            (Nport * (Pport + (DS + US) * 1e-9) + Nrack * uplink_power);
        P_CO_values(i) = P_CO/NT + 8.45;
    else
        selected_S = 128;
        S_values(i) = selected_S;
        Nport = ceil(NT / selected_S);
        Nrack = ceil(Nport / Nport_per_rack);
        P_CO = CO_site_factor * (1 / eta_dc) * ...
            (Nport * (Pport + (DS + US) * 1e-9) + Nrack * uplink_power);
        P_CO_values(i) = P_CO/NT + 8.45;
    end
end

% Plot the result
figure; grid on; hold on;
plot(Bm_values / 1e6, P_CO_values, 'b-o', 'LineWidth', 2);
xlabel('Average Offered Bandwidth per User, B_m (Mbps)');
ylabel('Central Office Power Consumption (W)');
title('P_{CO} vs B_m at 10% Availability Violation (Line Rate = 50 Gbps)');

figure; grid on; hold on;
plot(Bm_values / 1e6, S_values, 'b-o', 'LineWidth', 2);
xlabel('Average Offered Bandwidth per User, B_m (Mbps)');
ylabel('Split ratio (S)');
title('S vs B_m at 10% Availability Violation (Line Rate = 50 Gbps)');


