xi = 1:6;
p = ones(1,6)/6;
stem(xi,p), xlabel("x"),ylabel("p(x)");
g = p;
for i=1:7
  if(i==1) g(i)= 0;
  else g(i) = g(i-1)+p(i-1);
  end
end
g(8) = 1;
g(9) = 1;
stairs(xaxis,g)
xlim([0,8]);
ylim([0,1.2]);


