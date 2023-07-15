%----------------------------Section 1---------------------------------- 
    %before running the code determine the value of β for further results
beta = 0; 

        %%Raised Cosine Pulses Plotting
       
[p1,t1] = RCP(0,beta);
[p2,t2] = RCP(0.1,beta);
[p3,t3] = RCP(0.2,beta);

figure(1);
plot(t1,p1);
xlabel('t');
ylabel('error = 0');
title('Raised Cosine Pulse');
figure(2);
plot(t2,p2);
xlabel('t');
ylabel('error = 0.1T');
title('Raised Cosine Pulse');
figure(3);
plot(t3,p3);
xlabel('t');
ylabel('error = 0.2T');
title('Raised Cosine Pulse');
