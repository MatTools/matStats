function addColumn(this, colData, colName)
%ADDCOLUMN Add a new column to the data table
%
%   addColumn(TAB, DATA, NAME)
%   Add the column with data DATA and name NAME to the table TAB.
%
%   Example
%   addColumn
%
%   See also
%     addRow, horzcat

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-08-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

% current data size
nRows = size(this.Data, 1);
nCols = size(this.Data, 2);

% update column names
if nargin < 3
    colName = '';
end
this.ColNames{nCols + 1} = colName;

% ensure valid values for new column
if nargin == 2
    colData = zeros(nRows, 1);
end

% determine numerical data to add to the inner data
if isnumeric(colData) || islogical(colData)
    % column is numeric
    numData = colData;
    
else
    % column is a factor
    if ischar(colData)
        % Factor are given as a char array
        [levels, pos, indices] = unique(strtrim(colData), 'rows');
        [pos2, inds] = sort(pos); %#ok<ASGLU>
        
        % transform unique strings to cell array of factor levels
        levels = strtrim(cellstr(levels(inds,:)));
        this.Levels{nCols + 1} = levels;
        
        % compute corresponding numeric data (level indices)
        numData = zeros(size(indices));
        for i = 1:length(pos)
            numData(indices == inds(i)) = i;
        end
        
    elseif iscell(colData)
        % Factor are given as a cell array
        [levels, pos, indices] = unique(strtrim(colData));  %#ok<ASGLU>
        numData = indices;
        this.Levels{nCols + 1} = levels;
        
    else
        error(['Column factor have an unknown type: ' class(colData)]);
    end
end

% check lenth of new data
if length(colData) ~= nRows
    error('New column must have same number of rows than table');
end

% concatenate data
this.Data = [this.Data numData(:)];
    