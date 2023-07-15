function [p,t] = RCP(sampling_error,beta)
              %%Raised Cosine Pulses
    T=1;
    Fs=10;
    dt=T/Fs;
        %% epsilon=0
    if sampling_error == 0
        t=(-6*T:dt:6*T)-sampling_error;
        ind1 = find(t==T/(2*beta));
        ind2 = find(t==-T/(2*beta));
    end
        %% epsilon=0.1T
    if sampling_error == 0.1*T
        t=(-6*T:dt:6*T)-sampling_error;
        ind1 = find(abs(t-T/(2*beta))<0.0001);
        ind2 = find(abs(t+T/(2*beta))<0.0001);
    end
        %% epsilon=0.2T
    if sampling_error == 0.2*T
        t=(-6*T:dt:6*T)-sampling_error;
        ind1 = find(abs(t-T/(2*beta))<0.0001);
        ind2 = find(abs(t+T/(2*beta))<0.0001);
    end
    
    p=zeros(1,length(t));
    for i=1:length(t)
        if i==ind1
              p(i) = pi/4 * sinc(1/(2*beta));
        elseif i==ind2
              p(i) = pi/4 * sinc(1/(2*beta));
        else
              p(i) = sinc(t(i)/T).*(cos(pi*beta*t(i)/T)/(1-(2*beta*t(i)/T).^2));
        end
    end
end