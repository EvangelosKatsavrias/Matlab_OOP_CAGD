%%  OODCAGD Framework
%
%   Copyright 2014-2015 Evangelos D. Katsavrias, Athens, Greece
%
%   This file is part of the OOCAGD Framework.
%
%   OOCAGD Framework is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License version 3 as published by
%   the Free Software Foundation.
%
%   OOCAGD Framework is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with OOCAGD Framework.  If not, see <https://www.gnu.org/licenses/>.
%
%   Contact Info:
%   Evangelos D. Katsavrias
%   email/skype: vageng@gmail.com
% -----------------------------------------------------------------------

function plotBiParametricBasisFunctions(obj, varargin)

plotPreprocessor(obj, varargin{:});

plotFunctions(obj, varargin{:});


end

function plotFunctions(obj, varargin)

figure(obj.figureHandles(1)); clf; hold(obj.PlotSettings.holdFlag);

plotMonoParametricBasisFunctions(obj);

if strcmp(obj.basisFunctionsType, 'NURBS')||strcmp(obj.basisFunctionsType, 'BSpline')
    plotBSplineBiparametricBasisFunctions(obj, varargin{:});
end

plotLabelsTitlesAxesSettings(obj);

end

function plotPreprocessor(obj, varargin)

if isempty(obj.tensorBasisFunctions); obj.evaluateTensorProducts; end

if isempty(obj.findprop('figureHandles'))
    obj.addprop('figureHandles');
    obj.addprop('plotHandles');
    obj.addprop('PlotSettings');
    obj.figureHandles                       = figure;
    obj.PlotSettings.fontSize               = 16;
    obj.PlotSettings.labelsSwitch           = 1;
    obj.PlotSettings.titleType              = 'Full';
    obj.PlotSettings.plotDerivativesFlag    = 0;
    obj.PlotSettings.holdFlag               = 'on';
end

if nargin > 1
    [holdFlag, holdPosition]    = searchArguments(varargin, 'HoldPlots', 'char');
    [fontFlag, fontPosition]    = searchArguments(varargin, 'FontSize', 'numeric');
    labelsFlag                  = searchArguments(varargin, 'Labels');
    [titleFlag, titlePosition]  = searchArguments(varargin, 'TitleType', 'char');
    
    if holdFlag; obj.PlotSettings.holdFlag = varargin{holdPosition}; end
    if fontFlag; obj.PlotSettings.fontSize = varargin{fontPosition}; end
    if labelsFlag; obj.PlotSettings.labelsSwitch = 1; end
    if titleFlag; obj.PlotSettings.titleType = varargin{titlePosition}; end
end

end

function plotLabelsTitlesAxesSettings(obj)

dir1 = obj.Connectivities.controlPointsCountingSequence(1);
dir2 = obj.Connectivities.controlPointsCountingSequence(2);
if dir1 == 1; l1 = 'v'; l2 = 'u'; else l1 = 'u'; l2 = 'v'; end
xlabel(l1, 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
ylabel(l2, 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
zlabel('N(u, v)', 'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize);
switch obj.PlotSettings.titleType
    case 'Short'
        if strcmp(obj.basisFunctionsType, 'NURBS')||strcmp(obj.basisFunctionsType, 'BSpline')
            basisFunctionsTypeobj.title(['\makebox[4in][c]{B-Spline functions of degree ' num2str(obj.MonoParametricBasisFunctions(1).degree) ' and ' num2str(obj.MonoParametricBasisFunctions(2).degree) '}'], ...
              'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize, 'HorizontalAlignment', 'center');
        end
    case 'Full'
        if strcmp(obj.basisFunctionsType, 'NURBS')||strcmp(obj.basisFunctionsType, 'BSpline')
            title({['\makebox[4in][c]{B-Spline functions of degree ' num2str(obj.MonoParametricBasisFunctions(1).degree) ' and ' num2str(obj.MonoParametricBasisFunctions(2).degree) '}'], ...
                ['\makebox[4in][c]{U = [ ' num2str(obj.MonoParametricBasisFunctions(1).KnotVector.knots) ' ]}'], ...
                ['\makebox[4in][c]{V = [ ' num2str(obj.MonoParametricBasisFunctions(2).KnotVector.knots) ' ]}']}, ...
                'Interpreter', 'latex', 'FontSize', obj.PlotSettings.fontSize, 'HorizontalAlignment', 'center');
        end
end

grid on
view(135,30)
axis equal
axesHandle = gca;
if strcmp(obj.basisFunctionsType, 'NURBS')||strcmp(obj.basisFunctionsType, 'BSpline')
    set(axesHandle, 'XTickMode', 'manual', 'Xtick', obj.MonoParametricBasisFunctions(dir2).KnotVector.knotsWithoutMultiplicities, ...
        'YTickMode', 'manual', 'Ytick', obj.MonoParametricBasisFunctions(dir1).KnotVector.knotsWithoutMultiplicities, ...
        'LineWidth', 2, 'LineStyleOrder', '-');
    xlim([obj.MonoParametricBasisFunctions(dir2).KnotVector.knotsWithoutMultiplicities(1) obj.MonoParametricBasisFunctions(dir2).KnotVector.knotsWithoutMultiplicities(end)]);
    ylim([obj.MonoParametricBasisFunctions(dir1).KnotVector.knotsWithoutMultiplicities(1) obj.MonoParametricBasisFunctions(dir1).KnotVector.knotsWithoutMultiplicities(end)]);
end

end

function plotMonoParametricBasisFunctions(obj)

dir1 = obj.Connectivities.controlPointsCountingSequence(1);
dir2 = obj.Connectivities.controlPointsCountingSequence(2);

if isempty(obj.MonoParametricBasisFunctions(dir1).evaluationsPerFunction); obj.MonoParametricBasisFunctions(dir1).evaluatePerFunction('reshape'); end
obj.MonoParametricBasisFunctions(dir1).passFigureHandle(gcf);
obj.MonoParametricBasisFunctions(dir1).plotBasisFunctions('PlotPlane', '2-3', 'LineWidth', 2, 'LineColor', 'r', 'ClearPlot', 0)

if isempty(obj.MonoParametricBasisFunctions(dir2).evaluationsPerFunction); obj.MonoParametricBasisFunctions(dir2).evaluatePerFunction('reshape'); end
obj.MonoParametricBasisFunctions(dir2).passFigureHandle(gcf);
obj.MonoParametricBasisFunctions(dir2).plotBasisFunctions('PlotPlane', '1-3', 'LineWidth', 2, 'LineColor', 'r', 'ClearPlot', 0)

end

function plotBSplineBiparametricBasisFunctions(obj, varargin)

dir1                    = obj.Connectivities.controlPointsCountingSequence(1);
dir2                    = obj.Connectivities.controlPointsCountingSequence(2);
numberOfEvalPoints_dir1 = obj.MonoParametricBasisFunctions(dir1).numberOfEvaluationPointsPerKnotPatch;
numberOfEvalPoints_dir2 = obj.MonoParametricBasisFunctions(dir2).numberOfEvaluationPointsPerKnotPatch;

if ~isempty(varargin); spans1 = varargin{1}(dir1); spans2 = varargin{1}(dir2);
else spans1 = 1:obj.MonoParametricBasisFunctions(dir1).KnotVector.numberOfKnotPatches; 
     spans2 = 1:obj.MonoParametricBasisFunctions(dir2).KnotVector.numberOfKnotPatches;
end
if length(varargin) > 1; functions1 = varargin{2}(dir1); functions2 = varargin{2}(dir2);
else functions1  = 1:obj.Connectivities.order(dir1); 
     functions2  = 1:obj.Connectivities.order(dir2);
end


if dir1 < dir2
    for spanIndex2 = spans2
        for spanIndex1 = spans1
            xPoints         = obj.MonoParametricBasisFunctions(dir2).evaluationPoints(:, spanIndex2);
            yPoints         = obj.MonoParametricBasisFunctions(dir1).evaluationPoints(:, spanIndex1);
            functionsInSpan = permute(reshape(obj.tensorBasisFunctions(:, :, 1, (spanIndex2-1)*obj.MonoParametricBasisFunctions(dir1).KnotVector.numberOfKnotPatches+spanIndex1), [obj.Connectivities.order, numberOfEvalPoints_dir1, numberOfEvalPoints_dir2]), [3 4 1 2]);
            for functionIndex2 = functions2
                for functionIndex1 = functions1
                    obj.plotHandles = surf(xPoints, yPoints, functionsInSpan(:, :, functionIndex1, functionIndex2));
                end
            end
        end
    end
else
    for spanIndex2 = spans2
        for spanIndex1 = spans1
            yPoints         = obj.MonoParametricBasisFunctions(dir1).evaluationPoints(:, spanIndex1);
            xPoints         = obj.MonoParametricBasisFunctions(dir2).evaluationPoints(:, spanIndex2);
            functionsInSpan = permute(reshape(obj.tensorBasisFunctions(:, :, 1, (spanIndex2-1)*obj.MonoParametricBasisFunctions(dir1).KnotVector.numberOfKnotPatches+spanIndex1), [obj.Connectivities.order, numberOfEvalPoints_dir2, numberOfEvalPoints_dir1]), [3 4 1 2]);
            for functionIndex2 = functions2
                for functionIndex1 = functions1
                    obj.plotHandles = surf(xPoints, yPoints, functionsInSpan(:, :, functionIndex1, functionIndex2));
                end
            end
        end
    end
end

end