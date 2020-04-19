function drift = get_trajectory_drift(location,location_mat)

    x_drift = abs(location(:,1).^2 - location_mat(:,1).^2);
    y_drift = abs(location(:,2).^2 - location_mat(:,2).^2);
    
    drift = sum((x_drift + y_drift).^0.5);
end