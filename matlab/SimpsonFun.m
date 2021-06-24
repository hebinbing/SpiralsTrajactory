%% ����simpon��ʽ��n�Ǽ��ȷ֣�f�Ǳ���������[a,b]�ǻ�������
% �ɱ���� �����������ֵ��������ֹ���
function varargout = SimpsonFun(fin,a,b,n,varargin)
    format long
    fN = 1;
    if isa(fin, 'function_handle')    %f�Ǻ���������Ƿ��ź���
        % f is a handle
        f = fin;
    else
        % f is not a handle
        
        fN = numel(formula(fin));   %�ж��ж��ٸ�����
        f = matlabFunction(fin,'vars',{argnames(fin)}); %��������Ϊ������ʽ���룬תΪ�������
    end
    
    fa = f(a);
    fb = f(b);
    S = b-a;
    h = S/(2*n);    %����
    Sn = {};
    simpath=zeros(n+1,fN);    
    if nargin == 4      %�����ֽ��
        sum1=0;
        sum2=0;
        for i=0:n-1
            sum1=sum1 + f(a+(2*i+1).*h);
        end
        for j = 1:n-1
            sum2=sum2 + f(a+2*j.*h);
        end
        Sn = h.*( fa + 4*sum1 + 2*sum2 + fb )/3;
        if isa(Sn,'double') == 0
           Sn = eval(Sn); 
        end
       
    elseif nargin == 5  %�����ֹ���
        
        simpath(1,:) = fa;
        for i = 1:n
            simpath(i+1,:) = f(a+2*(i-1).*h)+4*f(a+(2*i-1).*h)+f(a+2*i.*h);
            simpath(i+1,:) = simpath(i+1,:)+simpath(i,:);
        end
        for j=1:fN
            simpath(:,j) = h(j).*simpath(:,j)/3;
        end
    end 
    
    
    if nargin == 5
       varargout{1} = simpath;
    elseif nargin == 4
        varargout{1} = Sn;
    end
end