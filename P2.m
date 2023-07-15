    %before running the code determine the value of β for further results
beta = 0;

%%-------------------------Section 2-------------------------------------
T = 1;
Fs = 10;
L = T*Fs;
N = 100000;
bits = randi([0 1],1,N);
modulated_symbols = bits;
modulated_symbols(modulated_symbols==0) = -1;
modulated_symbols(modulated_symbols==1) = 1;
signal = upsample(modulated_symbols,L);
signal = signal(1:end-(L-1));
                %% Transmitted Signal Generation
[p1,~] = RCP(0,beta);
[p2,~] = RCP(0.1,beta);
[p3,~] = RCP(0.2,beta);
transmitted_signal_1 = conv(signal,p1);
transmitted_signal_2 = conv(signal,p2);
transmitted_signal_3 = conv(signal,p3);

%%-----------------------------Section 3--------------------------------

snr_db = 0:10;
eta = zeros(1,11);
for i=1:11
   snr = 10^(snr_db(i)/10);
   eta(i) = 1/snr;
end

n=zeros(11,length(transmitted_signal_1));
for i=1:11
    noise = randn(1,length(transmitted_signal_1));
    noise = sqrt(eta(i)/2) * noise;
    n(i,:)= noise;
end

                %%Generation of Received Signals
received_signal_1 = zeros(11,length(transmitted_signal_1));
received_signal_2 = zeros(11,length(transmitted_signal_2));
received_signal_3 = zeros(11,length(transmitted_signal_3));
for i=1:11
    received_signal_1(i,:) = transmitted_signal_1 + n(i,:);
    received_signal_2(i,:) = transmitted_signal_2 + n(i,:);
    received_signal_3(i,:) = transmitted_signal_3 + n(i,:);
end


%%------------------------Section 4-------------------------------------
    
        %%Sampling
        
T_sampling = 6*L+1:L:(N+6-1)*L+1;
samples_1 = zeros(11,N);        %epsilon = 0
samples_2 = zeros(11,N);        %epsilon = 0.1
samples_3 = zeros(11,N);        %epsilon = 0.2
for i=1:11
   for j=1:N
       ts = T_sampling(j);
       samples_1(i,j) = received_signal_1(i,ts);
       samples_2(i,j) = received_signal_2(i,ts);
       samples_3(i,j) = received_signal_3(i,ts);
   end
end

       %%Decision

detected_symbols_1 = zeros(11,N);
detected_symbols_2 = zeros(11,N);
detected_symbols_3 = zeros(11,N);
for i=1:11
   for j=1:N
      s1 = samples_1(i,j);
      s2 = samples_2(i,j);
      s3 = samples_3(i,j);
      if s1>0
          detected_symbols_1(i,j) = 1;
      else
          detected_symbols_1(i,j) = -1;
      end
      if s2>0
          detected_symbols_2(i,j) = 1;
      else
          detected_symbols_2(i,j) = -1;
      end
      if s3>0
          detected_symbols_3(i,j) = 1;
      else
          detected_symbols_3(i,j) = -1;
      end
   end
end

%%-------------------------------Section 5-------------------------------

%Finding number of errors

error_1 = zeros(1,11);  %epsilon=0
error_2 = zeros(1,11);  %epsilon=0.1T
error_3 = zeros(1,11);  %epsilon=0.2T
for i=1:11
   for j=1:N
      if detected_symbols_1(i,j) ~= modulated_symbols(j)
          error_1(i) = error_1(i) + 1;
      end
      if detected_symbols_2(i,j) ~= modulated_symbols(j)
          error_2(i) = error_2(i) + 1;
      end
      if detected_symbols_3(i,j) ~= modulated_symbols(j)
          error_3(i) = error_3(i) + 1;
      end
   end
end
Pe1 = error_1/N;
Pe2 = error_2/N;
Pe3 = error_3/N;
semilogy(snr_db,Pe1,'ro-');hold on;grid on;
semilogy(snr_db,Pe2,'bx-');
semilogy(snr_db,Pe3,'gsquare-');
legend('Ideal Sampling','Sampling Error = 0.1T','Sampling Error = 0.2T');
xlabel('E_b/η in db');
ylabel('Bit Error Rate');
title('The BER Performance of Binary PAM for β=1');
