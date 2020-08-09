function [struct_name] = infocheck(filename) % simply loads a filename into a struct file for easy accessing/comparison 
load(filename);
w = whos; 

for a = 1:length(w)
    struct_name.(w(a).name) = eval(w(a).name);
end
% disp(struct_name.lat(1))
% disp(struct_name.lon(1))
end