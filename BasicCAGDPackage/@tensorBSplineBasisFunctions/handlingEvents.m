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

function handlingEvents(obj, eventData)

try
    
    if strcmp(eventData.EventName, 'localKnotRefinementTensorBSplinesNotification') ...
    || strcmp(eventData.EventName, 'notifyAllControlPointsWeightsChanged') ...
    || strcmp(eventData.EventName, 'notifyPartOfControlPointsWeightsChanged') ...
    || strcmp(eventData.EventName, 'notifyAllControlPointsResetted') ...
    || strcmp(eventData.EventName, 'notifyPartOfControlPointsResetted')
        obj.evaluateTensorProducts;
    elseif strcmp(eventData.EventName, 'globalKnotRefinementTensorBSplinesNotification')
        obj.evaluateTensorProducts;
    end
    obj.notify('basisFunctionsChangeInduced');
    
    if ~isempty(obj.findprop('figureHandles'))
        obj.plotBiParametricBasisFunctions;
    end
    
catch Exception
    rethrow(Exception);
end

end