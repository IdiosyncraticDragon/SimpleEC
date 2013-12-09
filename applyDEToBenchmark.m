function y = applyDEToBenchmark(x)
global initial_flag;
initial_flag=0;
y = benchmark_func(x,3);
end