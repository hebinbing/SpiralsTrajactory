% f �Ǻ�����������Ƿ��ź�����ֻ����һ�� N ά��ʸ����Ϊ��������� ������һ������ֵ
% x0 �� N ά��ʸ���� xerr ��һ������
% �������뺯�������飬�󷽳������Сֵ
% ���ĸ�����Ϊ���ֺ���������int��������finΪ������ͨ����������ȡ����ֵ
% �����Ĳ���Ϊ���ֺ���������int���������������
function [xmin, fmin] = NelderMead(fin, x0, xerr,varargin)
N = numel(x0); % f �� N Ԫ����
x = zeros(N+1,N); % Ԥ��ֵ
fN=0;
if isa(fin, 'function_handle')    %f�Ǻ���������Ƿ��ź���
    % f is a handle
    fN = 1;
    fvar = fin;
else
    % f is not a handle
    fN = numel(formula(fin));   %�ж��ж��ٸ�����
    fvar = matlabFunction(fin,'vars',{argnames(fin)}); %��������Ϊ������ʽ���룬תΪ�������
end
argN=0;
f = fvar;
if nargin > 3 
    argN = nargin-4;
    f = varargin{1};
    varargin{1} = fvar;
end
% fint(varargin{2:end});

varin={x0,varargin{:}};

y = zeros(N+1,fN);
% ���� N+1 ����ʼ��
x(1,:) = x0;
for ii = 1:N
    x(ii+1,:) = x(1,:);
    if x(1,ii) == 0
        x(ii+1,ii) = 0.00025;
    else
        x(ii+1,ii) = 1.05 * x(1,ii);
    end
end
% ��ѭ��
for kk = 1:10000
    y_order=zeros(1,size(y,1));
    % ��ֵ������
    for ii = 1 : N + 1
        varin{1} = x(ii,:);
        y(ii,:) = f(varin{:});
        y_order(ii) = norm(y(ii,:));
    end
    [~, order] = sort(y_order); %���շ�����С��������
    y=y(order,:);
    x = x(order,:);
    err = norm(x(N+1,:) - x(1,:));
%     err = norm(f(x(1,:)));
    fprintf('����������%d,��%f\n',kk,err);
    if err < xerr % �ж����
        break;
    end
    m = mean(x(1:N,:)); % ƽ��λ��
    r = 2*m - x(N+1,:); % �����
    f_r = f(r);
    if norm(y(1,:)) <= norm(f_r) && norm(f_r) < norm(y(N,:)) % �� 4 ��
        x(N+1,:) = r; continue;
    elseif norm(f_r) < norm(y(1,:)) % �� 5 ��
        s = m + 2*(m - x(N+1,:));
        if norm(f(s)) < norm(f_r)
            x(N+1,:) = s;
        else
            x(N+1,:) = r;
        end
        continue;
    elseif norm(f_r) < norm(y(N+1,:)) % �� 6 ��
        c1 = m + (r - m)*0.5;
        if norm(f(c1)) < norm(f_r)
            x(N+1,:) = c1; continue;
        end
    else % �� 7 ��
        c2 = m + (x(N+1,:) - m)*0.5;
        if norm(f(c2)) < norm(y(N+1,:))
            x(N+1,:) = c2; continue;
        end
    end
    for jj = 2:N+1 % �� 8 ��
        x(jj,:) = x(1,:) + (x(jj,:) - x(1,:))*0.5;
    end
end
% �������
xmin = x(1,:);
fmin = f(xmin);
end
