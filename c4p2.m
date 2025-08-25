clc; clear; close all;

%% ----------------------  CONSTANTS  ----------------------
line_rate       = 50e9;                       % Fixed line rate: 50 Gbps
Bm_values       = linspace(100e6, 1e9, 10);   % Average offered bandwidth 100 Mbps–1 Gbps
PON             = 1;                          % Number of PONs per split tree
PT              = 0.9;                        % Target availability (90 %)
violation       = 0.10;                       % 10 % violation allowed
NT              = 256;                        % Total users in the system
max_split_ratio = 256;                        % Maximum optical split ratio

% TWDM-PON design parameters
Pport          = 20;        % Power per OLT port (W)
DS             = 4*10e9;    % Aggregate downstream rate per port (bps)
US             = 4*2.5e9;   % Aggregate upstream rate per port (bps)
uplink_power   = 121;       % Uplink power per rack (W)
Nport_per_rack = 60;        % OLT ports that fit in one rack
eta_dc         = 0.8;       % DC/DC efficiency
CO_site_factor = 1.6;       % Central-office site power overhead

%% -----------------  HELPER: Poisson CDF  -----------------
poisson_prob = @(NA,r) (NA.^r .* exp(-NA)) ./ factorial(r);  % PDF
poisson_cdf  = @(NA,rmax) sum(poisson_prob(NA,1:rmax));      % CDF (r ≥ 1)

%% ---------------  PREALLOCATE RESULT VECTORS -------------
P_CO_values = zeros(size(Bm_values));  % Power per user (W)
S_values    = zeros(size(Bm_values));  % Selected split ratio

%% -----------------------  MAIN LOOP  ---------------------
for i = 1:numel(Bm_values)
    Bm = Bm_values(i);

    if Bm >= 400e6                                  % High-bandwidth regime
        selected_S = NaN;

        % Search for the smallest split ratio S that meets the 10 % violation rule
        for S = linspace(max_split_ratio, 2, 500)
            NA    = PON * S;                        % Offered load (Erlangs)
            r_max = max(1, ceil(line_rate / Bm));   % Max simultaneous users
            prob  = poisson_cdf(NA, r_max);         % Availability

            if prob >= (PT - violation)             % Constraint satisfied?
                selected_S = S;
                break
            end
        end

        if isnan(selected_S)
            warning('No valid S found for B_m = %.0f Mbps', Bm/1e6);
            P_CO_values(i) = NaN;
            S_values(i)    = NaN;
            continue
        end
    else                                            % Low-bandwidth regime
        selected_S = max_split_ratio;               % Use highest split
    end

    S_values(i) = selected_S;

    % ------  Central-office power per user (Eq. 6 in paper)  ------
    Nport = ceil(NT / selected_S);                  % Required OLT ports
    Nrack = ceil(Nport / Nport_per_rack);           % Required racks

    P_CO = CO_site_factor * (1/eta_dc) * ...
          (Nport * (Pport + (DS + US)*1e-9) + Nrack * uplink_power);   % (W)

    P_CO_values(i) = P_CO/NT + 8.45;                % Add fixed overhead (W/user)
end

%% -----------------------  PLOTTING  -----------------------
figure, grid on, hold on
plot(Bm_values/1e6, P_CO_values, 'b-o', 'LineWidth', 2)
xlabel('Average Offered Bandwidth per User, B_m (Mbps)')
ylabel('Central Office Power Consumption per User (W)')
title('P_{CO} vs B_m at 10 % Availability Violation (256 users, 50 Gbps)')

figure, grid on, hold on
plot(Bm_values/1e6, S_values, 'b-o', 'LineWidth', 2)
xlabel('Average Offered Bandwidth per User, B_m (Mbps)')
ylabel('Selected Split Ratio, S')
title('S vs B_m at 10 % Availability Violation (256 users, 50 Gbps)')
