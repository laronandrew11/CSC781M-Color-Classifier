I=imread('sample.png');
[L,a,b]=RGB2Lab(I);
plot3(L,a,b,'r.');
xlabel('L');
ylabel('a');
zlabel('b');