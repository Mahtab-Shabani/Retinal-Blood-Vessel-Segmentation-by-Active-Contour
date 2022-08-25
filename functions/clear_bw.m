function result = clear_bw(bw, min_obj, min_hole)
% remove small objects and fill small holes
%
% remove small objects
if min_obj > 0
    result = bwareaopen(bw, ceil(min_obj));
else
    result = bw;
end
% fill small holes
if min_hole > 0
    result = ~bwareaopen(~result, floor(min_hole));
end