true_height = 50;                      % True building height (meters)
measurement_std_dev = 5;                % alimeter measurement error (standard deviation) (meters)
measurements = [49.03, 48.44, 55.21, 49.98, 50.6, 52.61, 45.87, 42.64, 48.26, 55.84];

% Kalman Filter initialization with given initial guess
num_measurements = length(measurements);
x_est = 60;                             % Initial estimate of the building height
p_est = 225;                            % Initial uncertainty in the estimate

% Measurement noise (variance) from standard deviation
r = measurement_std_dev^2;

% Initialize arrays to store estimates
x_estimates = zeros(1, num_measurements);
uncertainties = zeros(1, num_measurements);

% Kalman Filter loop
for n = 1:num_measurements
    % Measurement updat
    Kn = p_est / (p_est + r);                   % Calculate Kalman Gain
    x_est = x_est + Kn * (measurements(n) - x_est); % Update estimate with measurement
    p_est = (1 - Kn) * p_est;                   % Update uncertainty

    % results
    x_estimates(n) = x_est;
    uncertainties(n) = p_est;
end

% Display the results
disp('State estimates and uncertainties after each measurement:');
disp(table((1:num_measurements)', measurements', x_estimates', uncertainties', ...
    'VariableNames', {'Measurement_No', 'Measurement', 'Estimate', 'Uncertainty'}));
