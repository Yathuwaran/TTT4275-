tic 
NN_tags = NN(C,cluster_tags,testv);
toc
%% Calculate Confusion Matrix and Error Rate
confusion_matrix = zeros(classes);
for i = 1:num_test
    confusion_matrix(NN_tags(i)+1,testlab(i)+1) = confusion_matrix(NN_tags(i)+1,testlab(i)+1)+1;
end

error_rate = 1 - trace(confusion_matrix)/num_test;
plt_confusion;
