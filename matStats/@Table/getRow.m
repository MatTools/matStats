function row = getRow(obj, rowName)
% Extract row data of the table.
%
%   output = getRow(input)
%
%   Example
%   getRow
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2011-03-23,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% Parse index of row
ind = rowIndex(obj, rowName);

% extract data
row = obj.Data(ind, :);
