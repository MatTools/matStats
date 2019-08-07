function res = vertcat(this, varargin)
%VERTCAT Concatenate tables vertically
%
%   RES = vertcat(TAB1, TAB2)
%   RES = [TAB1 ; TAB2];
%   Concatenate vertically two data tables.
%
%   RES = vertcat(TAB1, TAB2, TAB3,...)
%   RES = [TAB1 ; TAB2 ; TAB3 ... ];
%   Concatenate vertically multiple data tables.
%
%   Example
%   vertcat
%
%   See also
%     horzcat, cat, interleave, aggregate
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2010-08-05,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

% detect which argument is table object
if isa(this, 'Table')
    data = this.Data;
    rowNames = this.RowNames;
    name = this.Name;
    nCols = size(this.Data, 2);
    
else
    data = this;
    nCols = size(data, 2);
    rowNames = strtrim(cellstr(num2str((1:size(data, 1))')));
    name = 'NoName';
    
end

% init levels array
colNames = cell(1, nCols);
levels = cell(1, nCols);
if isa(this, 'Table')
    colNames = this.ColNames;
    levels = this.Levels;
end

% iterate over
for i = 1:length(varargin)
    var = varargin{i};
    
    if isa(var, 'Table')
        if size(var.Data, 2) ~= nCols
            error('Table:vertcat:wrongsize', ...
                'Input tables must have the same number of columns');
        end
        
        data2 = var.Data;
        % in case of factor columns, merge the existing factor levels
        indFactCol = find(isFactor(this, 1:nCols) | isFactor(var, 1:nCols));
        for j = 1:length(indFactCol)
            indCol = indFactCol(j);

            % get list of levels in first table
            levels0 = this.Levels{indCol};
            if isempty(levels0)
                levels0 = {};
            end
            
            % get list of levels in second table
            levels2 = var.Levels{indCol};
            if isempty(levels2)
                levels2 = {};
            end

            % update level indices
            count = 0;
            for k = 1:length(levels2)
                indL = find(strcmp(levels2{k}, levels0));
                inds = var.Data(:, indCol) == k;
                if isempty(indL)
                    count = count + 1;
                    data2(inds, indCol) = length(levels0) + count;
                else
                    data2(inds, indCol) = indL;
                end
            end
           
            % find which levels do not exist in current level
            indLevels = ~ismember(levels2, levels0);
            levels{indCol} = [levels0 ; levels2(indLevels)];
        end
        
        % if some levels are more numerous, keep the most numerous ones
        inds = find(cellfun(@length, var.Levels) > cellfun(@length, levels));
        for j = 1:length(inds)
            levels{inds(j)} = var.Levels{inds(j)};
        end
        
        
        data = [data ; data2]; %#ok<AGROW>
        rowNames = [rowNames(:) ; var.RowNames(:)];
        name = strcat(name, '+', var.Name);
        
    else
        if size(var, 2) ~= nCols
            error('Table:vertcat:wrongsize', ...
                'Input data must have the same number of columns');
        end
        
        data = [data ; var]; %#ok<AGROW>
        newRows = strtrim(cellstr(num2str((1:size(var, 1))')));
        rowNames = [rowNames(:) ; newRows(:)];
        name = strcat(name, '+', 'NoName');
        
    end
    
end

% create the result table
res = Table.create(data, ...
    'rowNames', rowNames, ...
    'colNames', colNames, ...
    'levels',   levels, ...
    'name', name);

