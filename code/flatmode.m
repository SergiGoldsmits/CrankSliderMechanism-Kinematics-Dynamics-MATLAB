% Flat mode
crank_dynamics_analysis('flat', 0.005, 0.0005, 0, 1400, 200, 0.001, 10);

% Relief mode (200 parts/min)
crank_dynamics_analysis('relief', 0.005, 0.0005, 0.0005, 1400, 200, 0.001, 10);
