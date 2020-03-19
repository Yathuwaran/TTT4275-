tic
NN(trainv,trainlab,testv,10,1000);
toc

%% Calculate Confusion Matrix and Error Rate
confusion_matrix = zeros(10);
for i = 1:num_test
    confusion_matrix(NN_tags(i)+1,testlab(i)+1) = confusion_matrix(NN_tags(i)+1,testlab(i)+1)+1;
end
error_rate = 1 - trace(confusion_matrix)/num_test;
plt_confusion;
NN_plotting;