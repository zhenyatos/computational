A_inf = readmatrix('data\A_inf.txt');
A_sup = readmatrix('data\A_sup.txt');
b_inf = readmatrix('data\b_inf.txt');
b_sup = readmatrix('data\b_sup.txt');
A(:, :, 1) = A_inf;
A(:, :, 2) = A_sup;
b = zeros(size(A,1), 2);
b(:, 1) = b_inf;
b(:, 2) = b_sup;

% 2D plot
tau_values = 0.5:0.05:1.0;
n = length(tau_values);
ni_values = zeros(1, n);

for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);
hold on;

A(7, 7, 1) = 8;
for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);

A(7, 7, 1) = 10;
for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);

A(7, 7, 1) = 12.8;
for i = 1:n
    [x, ni] = subdiff(A, b, tau_values(i), false);
    ni_values(i) = ni;
end
plot(tau_values, ni_values);
xlabel('$\tau$', 'interpreter', 'latex');
ylabel('iterations');
legend('$\gamma = 6$', ...
    '$\gamma = 8$', ...
    '$\gamma = 10$', ...
    '$\gamma = 12.8$', 'interpreter','latex');
saveas(gcf,'1.png')
hold off;
figure;

% Animation
g = 6:0.05:14;
nr_fr = length(g);
frames = moviein(nr_fr); 
writerObj = VideoWriter('2.avi');
writerObj.FrameRate = 2;
open(writerObj);
for i = 1 : nr_fr
    A(7, 7, 1) = g(i);
    for k = 1:n
        [x, ni] = subdiff(A, b, tau_values(k), false);
        ni_values(k) = ni;
    end
    plot(tau_values, ni_values);
    xlabel('$\tau$', 'interpreter', 'latex');
    ylabel('iterations');
    title(sprintf('$\\gamma = $ %f', g(i)), 'interpreter','latex');
    writeVideo(writerObj, getframe(gcf));
end
close(writerObj);
figure;

% 3D plot
[T, G] = meshgrid(tau_values, g);
N = zeros(size(T));
for i = 1:size(T, 1)
    for j = 1:size(T, 2)
        A(7, 7, 1) = G(i, j);
        [x, ni] = subdiff(A, b, T(i, j), false);
        N(i, j) = ni;
    end
end
surf(T, G, N);
xlabel('$\tau$', 'interpreter', 'latex');
ylabel('$\gamma$', 'interpreter', 'latex');
zlabel('iterations');