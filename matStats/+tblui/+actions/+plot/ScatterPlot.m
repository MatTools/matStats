classdef ScatterPlot < tblui.TableGuiAction
% Scatter plot of two columns
%
%   Class ScatterPlot
%
%   Example
%   ScatterPlot
%
%   See also
%     tblui.TableGuiAction
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2012-03-26,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2012 INRA - Cepia Software Platform.


%% Properties
properties
    Handles;
    
    IndX = 1;
    IndY = 2;
    
end % end properties


%% Constructor
methods
    function obj = ScatterPlot(viewer)
    % Constructor for ScatterPlot class
        obj = obj@tblui.TableGuiAction(viewer, 'scatterPlot');
    end

end % end constructors


%% Methods
methods
    function actionPerformed(obj, varargin)
        createFigure(obj);
        updateWidgets(obj);
        obj.Handles.PlotFigure = -1;
    end
    
    function hf = createFigure(obj)
        
        tab = obj.Viewer.Doc.Table;
        gui = obj.Viewer.Gui;
        varNames = tab.ColNames;
        
        % creates the figure
        hf = figure(...
            'Name', 'Scatter Plot Options', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'CloseRequestFcn', @obj.closeFigure);
        set(hf, 'units', 'pixels');
        pos = get(hf, 'Position');
        pos(3:4) = [250 230];
        set(hf, 'Position', pos);
        
        % get the current table
        
        
        obj.Handles.Figure = hf;
        
        % vertical layout
        vb  = uix.VBox('Parent', hf, 'Spacing', 5, 'Padding', 5);
        mainPanel = uix.VButtonBox('Parent', vb);
        set(mainPanel, 'ButtonSize', [230 35], 'VerticalAlignment', 'top');
        
        % combo box for the variables to use
        obj.Handles.XAxisCombo = addComboBoxLine(gui, mainPanel, ...
            'X-Axis:', varNames, @obj.onComboBoxChanged);
        
        % combo box for the variables to use
        obj.Handles.YAxisCombo = addComboBoxLine(gui, mainPanel, ...
            'Y-Axis:', varNames, @obj.onComboBoxChanged);
        
        % button for control panel
        buttonsPanel = uix.HButtonBox('Parent', vb, 'Padding', 5);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Apply', ...
            'Callback', @obj.onButtonOK);
        uicontrol( 'Parent', buttonsPanel, ...
            'String', 'Close', ...
            'Callback', @obj.onButtonCancel);
        
        set(vb, 'Heights', [-1 40] );
    end
    
    function closeFigure(obj, varargin)       
        % close the current fig
        if ishandle(obj.Handles.Figure)
            delete(obj.Handles.Figure);
        end
    end
    
    function onComboBoxChanged(obj, varargin)
        obj.IndX = get(obj.Handles.XAxisCombo, 'value');
        obj.IndY = get(obj.Handles.YAxisCombo, 'value');
    end
    
    function updateWidgets(obj)
        set(obj.Handles.XAxisCombo, 'value', obj.IndX);
        set(obj.Handles.YAxisCombo, 'value', obj.IndY);
    end
    
end % end methods

%% Control buttons Callback
methods
    function onButtonOK(obj, varargin)

        tab = obj.Viewer.Doc.Table;
        gui = obj.Viewer.Gui;
        
        if ~ishandle(obj.Handles.PlotFigure)
            obj.Handles.PlotFigure = createPlotFigure(gui);
        end
        figure(obj.Handles.PlotFigure); cla;
        
        scatter(tab, obj.IndX, obj.IndY);
        
    end
    
    function onButtonCancel(obj, varargin)
        disp('cancel');
        closeFigure(obj);
    end
end

end % end classdef

