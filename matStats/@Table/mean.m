function res = mean(obj, varargin)
% Compute the mean of table columns.
%
%   M = mean(TAB)
%   Computes the mean of each column in the table. The result is a new
%   Table with one row, named 'mean'.
%
%   M = mean(TAB, DIM)
%   Specifies the dimension to operate. DIM can be either 1 (the default)
%   or 2. In the latter case, mean is computed fo each row of the table,
%   and the result is a table with one column, called 'mean'.
%
%   Example
%     iris = Table.read('fisherIris.txt');
%     mean(iris(:,1:4))
%     ans =
%                 SepalLength    SepalWidth    PetalLength    PetalWidth
%         mean         5.8433         3.054         3.7587        1.1987
%
%   See also
%     median, std, var, sum
%

% ------
% Author: David Legland
% e-mail: david.legland@inrae.fr
% Created: 2011-06-17,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% check conditions
if hasFactors(obj)
    error('Can not compute mean for table with factors');
end

% parse dimension to process
dim = 1;
if ~isempty(varargin)
    var1 = varargin{1};
    if isnumeric(var1) && isscalar(var1)
       dim = var1;
    else
        error('Can not interpret optional argument');
    end
end

newName = '';
if ~isempty(obj.Name)
    newName = ['Mean of ' obj.Name];
end

if dim == 1
    res = Table.create(mean(obj.Data, 1), ...
        'Parent', obj, ...
        'RowNames', {'mean'}, ...
        'Name', newName);
    
else
    res = Table.create(mean(obj.Data, 2), ...
        'Parent', obj, ...
        'ColNames', {'mean'}, ...
        'Name', newName);
    
end
