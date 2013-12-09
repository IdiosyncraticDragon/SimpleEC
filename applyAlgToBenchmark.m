function y = applyAlgToBenchmark(x,benchmarkNum)
global initial_flag;
initial_flag=0;
y = benchmark_func(x,benchmarkNum);
end