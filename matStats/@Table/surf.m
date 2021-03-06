function varargout = surf(obj, varargin)
% Surfacic representation of the data stored in a Table.
%
%   output = surf(input)
%
%   Example
%   surf
%
%   See also
%     plot
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2011-12-06,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2011 INRA - Cepia Software Platform.

h = surf(obj.Data, varargin{:});

if isempty(get(get(gca, 'title'), 'string'))
    title(obj.Name);
end

if nargout > 0
    varargout = {h};
end
