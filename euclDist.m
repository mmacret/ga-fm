function y = euclDist( A,B )
%EUCLDIST Computes the sum of the euclidian distance between the column of matrix A and B. B is the target.
%
%y = euclDist( A,B )

   

if size(A,1) ~= size(B,1) || size(A,2) ~= size(B,2)
    err = MException('euclDistSpec','A and B does not have the same size');
    throw(err)
end

[m,n]= size(A);

y=0;
for k=1:n
    dist=0;
    %norm=0;
    for l=1:m
        dist = dist + (A(l,k)-B(l,k))^2;
    end
    dist = sqrt(dist);
    dist(isnan(dist)) = 0 ;
    y = y+ dist;
    
end

end

