function res = ge(obj1, obj2)
% Overload the ge operator for Table objects.
%
%   RES = ge(TAB1, TAB2);
%
%   Example
%   ge
%
%   See also
%     eq, le, gt, ge
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2, inputname(1), inputname(2));

% error checking
if hasFactors(parent)
    error('Can not compute ge for table with factors');
end

% compute new data
newData = bsxfun(@ge, obj1, obj2);

newColNames = strcat(names1, '>=', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);

