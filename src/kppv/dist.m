function distance = dist( A, B )
    distance = 0;
    sizeFeature = size(A, 2);
    
    for i = 1:sizeFeature
        distance = distance + ((B(1,i) - A(1,i)) * (B(1,i) - A(1,i)));
    end
    
    distance = sqrt(distance);
end

