clear; 
clc;
%% Initial variables
D = 4;  % Dimension of the input vectors
C = 3;  % Number of classes

data_size_c = 50;
data_size = data_size_c * C;
train_size_c = 30;
train_size = train_size_c * C;
test_size_c = 20;
test_size = test_size_c * C;

W_0 = zeros(C, D);
w_0 = zeros(C, 1);
W = [W_0 w_0];

M = 3000;                       % Number of iterations
alpha = 0.0092;                 % Step factor. Tuned to the yield the smallest MSE after training
 
MSEs = zeros(1, M);             % Training variable
MSE_grads = zeros(1, M);        % Training variable

%% Load data
x1 = load('class_1','-ascii');
%x1 = [x1(:,1) x1(:, 3:4)];     % Uncomment for sepal w, petal w, petal h
x2 = load('class_2','-ascii');
%x2 = [x2(:,1) x2(:, 3:4)];     % Uncomment for sepal w, petal w, petal h
x3 = load('class_3','-ascii');
%x3 = [x3(:,1) x3(:, 3:4)];     % Uncomment for sepal w, petal w, petal h
x = [x1; x2; x3];

% TRAIN ON THE FIRST 30 DATA POINTS

% x1_train = x1(1:train_size_c,:);
% x2_train = x2(1:train_size_c,:);
% x3_train = x3(1:train_size_c,:);
% x_train = [x1_train; x2_train; x3_train]; 
% 
% x1_test = x1(train_size_c+1:end,:);
% x2_test = x2(train_size_c+1:end,:);
% x3_test = x3(train_size_c+1:end,:);
% x_test = [x1_test; x2_test; x3_test];

% TRAIN ON THE LAST 30 DATA POINTS

x1_test = x1(1:test_size_c,:);
x2_test = x2(1:test_size_c,:);
x3_test = x3(1:test_size_c,:);
x_test = [x1_test; x2_test; x3_test];

x1_train = x1(test_size_c+1:end,:);
x2_train = x2(test_size_c+1:end,:);
x3_train = x3(test_size_c+1:end,:);
x_train = [x1_train; x2_train; x3_train]; 




%% Training the linear classifier
for m = 1:M  
    MSE_grad = 0;
    MSE = 0;
    for k = 1:train_size
        c = floor((k-1)/train_size * C) + 1; % c increses once per train_size iterations
        t_k = zeros(C, 1);
        t_k(c) = 1;
        
        x_k = [x_train(k,:)'; 1];       % x = [x' 1]'
        z_k = W*x_k + w_0;
        g_k = sigmoid(z_k);
        MSE_grad = MSE_grad + ((g_k - t_k).*(g_k).*(1-g_k))*x_k';
        MSE = MSE + 0.5 * (g_k - t_k)'*(g_k - t_k);
    end
    W = W - alpha*MSE_grad;
    MSEs(m) = MSE;
    MSE_grads(m) = norm(MSE_grad);
end

%% Analysis

conf_matrix_train = zeros(C);
for k = 1:train_size
    c = floor((k-1)/train_size * C) + 1;
    t_k = zeros(C, 1);
    t_k(c) = 1;

    x_k = [x_train(k,:)'; 1];
    z_k = W*x_k + w_0;
    g_k = sigmoid(z_k);
    [g_max, c_max] = max(g_k);
    conf_matrix_train(c, c_max) = conf_matrix_train(c, c_max) + 1;
end
error_rate_train = 1 - trace(conf_matrix_train)/train_size;


conf_matrix_test = zeros(C);
for k = 1:test_size
    c = floor((k-1)/test_size * C) + 1;
    t_k = zeros(C, 1);
    t_k(c) = 1;

    x_k = [x_test(k,:)'; 1];
    z_k = W*x_k + w_0;
    g_k = sigmoid(z_k);
    [g_max, c_max] = max(g_k);
    conf_matrix_test(c, c_max) = conf_matrix_test(c, c_max) + 1;
end
error_rate_test = 1 - trace(conf_matrix_test)/test_size;


disp('Training error rate: ');
disp(error_rate_train);
disp('Training confusion matrix: ');
disp(conf_matrix_train);

disp('Testing error rate: ');
disp(error_rate_test);
disp('Testing confusion matrix: ');
disp(conf_matrix_test);
% 
% 
% %% Plot results
% figure(1);
% plot(MSEs), grid;
% title('Minimum square error');
% xlabel('Iteration');
% ylabel('MSE magnitude');
% 
% figure(2);
% plot(MSE_grads), grid;
% title('MSE gradient');
% 
% %run data_histograms;
% 
% figure(4);
% hold on;
% grid on;
% for i = 1:(data_size_c)
%     plot(x1(i,1), x1(i,2), 'Color', 'm', 'Marker', 'o');
%     plot(x2(i,1), x2(i,2), 'Color', 'r', 'Marker', 'x');
%     plot(x3(i,1), x3(i,2), 'Color', 'b', 'Marker', '*');
% end
% xlabel('Sepal length');
% ylabel('Sepal width');
% title('Iris data');
% legend('I. setosa', 'I. versicolor', 'I. virginica');