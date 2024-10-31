true_height = 50;                      % True building height (meters)
measurement_std_dev = 5;                % alimeter measurement error (standard deviation) (meters)
measurements = [49.03, 48.44, 55.21, 49.98, 50.6, 52.61, 45.87, 42.64, 48.26, 55.84];

% Kalman Filter initialization with given initial guess
num_measurements = length(measurements);
x_est = 60;                             % Initial estimate of the building height
p_est = 225;                            % Initial uncertainty (variance) in the estimate

% Measurement noise (variance) from standard deviation
r = measurement_std_dev^2;

% Initialize arrays to store estimates
x_estimates = zeros(1, num_measurements);
uncertainties = zeros(1, num_measurements);
confidence_interval = zeros(1, num_measurements);

% Kalman Filter loop
for n = 1:num_measurements
    % Measurement update
    Kn = p_est / (p_est + r);                   % Calculate Kalman Gain
    x_est = x_est + Kn * (measurements(n) - x_est); % Update estimate with measurement
    p_est = (1 - Kn) * p_est;                   % Update uncertainty

    % results
    x_estimates(n) = x_est;
    uncertainties(n) = p_est;
    confidence_interval(n) = 1.96 * sqrt(p_est);         % 95% confidence interval
end

% Display the results
disp('State estimates and uncertainties after each measurement:');
disp(table((1:num_measurements)', measurements', x_estimates', uncertainties', ...
    'VariableNames', {'Measurement_No', 'Measurement', 'Estimate', 'Uncertainty'}));

% Plot the results
figure;
hold on;
plot(1:num_measurements, measurements, 'x', 'DisplayName', 'Measured Values'); % Measured values
plot(1:num_measurements, x_estimates, '-o', 'DisplayName', 'Estimated Height'); % Estimates
plot(1:num_measurements, true_height * ones(1, num_measurements), '--r', 'DisplayName', 'True Height'); % True height

% Plot 95% confidence intervals
fill([1:num_measurements, num_measurements:-1:1], ...
     [x_estimates + confidence_interval, fliplr(x_estimates - confidence_interval)], ...
     'blue', 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', '95% Confidence Interval');

xlabel('Measurement Number');
ylabel('Height (m)');
title('Kalman Filter Estimated Height with 95% Confidence Intervals');
legend;
hold off;
