function res = and(obj1, obj2)
% Overload the and operator for Table objects.
%
%   output = and(input)
%
%   Example
%   and
%
%   See also
%     or, xor

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

[obj1, obj2, parent, names1, names2] = parseInputCouple(obj1, obj2);

% error checking
if hasFactors(parent)
    error('Can not compute AND for table with factors');
end

% compute new data
newData = bsxfun(@and, obj1, obj2);

newColNames = strcat(names1, '&', names2);

% create result array
res = Table.create(newData, ...
    'parent', parent, ...
    'colNames', newColNames);
