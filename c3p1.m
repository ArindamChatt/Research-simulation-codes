clc; clear; close all;

% Case 3: 256 Users – 25 Gbps
Bm_values = [400, 600, 800];
LR = 25 * 1e3;                 % Line rate = 25 Gbps
PT = 0.9;                      % ask ma’am about this
PON = 1;
max_split_ratio = 256;         % 256 users
violation_percentages = linspace(0.001, 100, 15) / 100;

% Poisson probability function
poisson_prob = @(NA, r) (NA.^r .* exp(-NA)) ./ factorial(r);

% Compute NA function (Fixed Syntax)
compute_NA = @(Bm) arrayfun(@(violation) ...
    max([arrayfun(@(S) ...
    S * (sum(poisson_prob(PON*S, 1:ceil(LR / Bm))) >= (PT - violation)), ...
    linspace(max_split_ratio, 2, 500)) 0]), ...
    violation_percentages);

% Compute NA for different Bm values
NA_1 = compute_NA(Bm_values(1));
NA_2 = compute_NA(Bm_values(2));
NA_3 = compute_NA(Bm_values(3));

% Example for additional values
% NA_100 = compute_NA(100);
% NA_200 = compute_NA(200);
% NA_300 = compute_NA(300);

% Plot results
figure; hold on; grid on;
plot(violation_percentages * 100, NA_1, 'o-', 'DisplayName', 'B_m = 400 Mbps');
plot(violation_percentages * 100, NA_2, 's-', 'DisplayName', 'B_m = 600 Mbps');
plot(violation_percentages * 100, NA_3, '^-', 'DisplayName', 'B_m = 800 Mbps');
% plot(violation_percentages * 100, NA_300, 'd-', 'DisplayName', 'B_m = 300 Mbps');

% Labels and title
xlabel('Violation of Promised Availability (%)');
ylabel('Number of Active Users (N_A)');
title('Number of Users vs Violation of Promised Availability (256 Users – 25 Gbps)');
legend('Location', 'best');
hold off;
