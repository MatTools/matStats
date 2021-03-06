function varargout = show(obj)
%SHOW Display the content of the table in a new figure.
%
%   show(TABLE);
%   Displays the content of the data table TABLE in a new figure, using a
%   'uitable' widget.
%
%   hf = show(TABLE);
%   Returns a handle to the created figure. 
%
%   [hf ht] = show(TABLE);
%   Also returns a handle to the uitable object.
%
%
%   Example
%     tab = Table(rand(5, 3), 'colNames', {'v1', 'var2', 'other'});
%     h = show(tab);
%     close(h);
%
%
%   See also
%     display, uitable
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-03-18,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.


% extract table infos
nr = size(obj.Data, 1);
nc = size(obj.Data, 2);

% create figure name
figName = sprintf('%s (%d-by-%d Data Table)', obj.Name, nr, nc);

% Create parent figure
f = figure(...
    'Name', figName, ...
    'NumberTitle', 'off', ...
    'MenuBar', 'none', ...
    'HandleVisibility', 'Callback');

% convert numerical data to cell array
data2 = num2cell(obj.Data);
    
% if data table has factors, need to convert factor levels
% hasLevels = sum(~cellfun(@isnumeric, obj.levels)) > 0;
if hasFactors(obj)
    indLevels = find(~cellfun(@isnumeric, obj.Levels));
    for i = indLevels
        data2(:,i) = obj.Levels{i}(obj.Data(:, i));
    end
    
end

colNames = obj.ColNames;

% manage row names if present
if ~isempty(obj.RowNames)
    data2 = [obj.RowNames(:) data2];
    colNames = [{'Name'} obj.ColNames];
end

ht = uitable(f, ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1], ...
    'Data', data2,...
    'ColumnName', colNames);

% return handle to table if requested
if nargout > 0
    if nargout == 1
        varargout = {f};
    else
        varargout = {f, ht};
    end
end
