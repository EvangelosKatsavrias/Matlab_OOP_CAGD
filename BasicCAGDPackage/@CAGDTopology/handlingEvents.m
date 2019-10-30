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
    refinementEvents(obj, eventData);

catch Exception
    rethrow(Exception);

end

end


%%  
function refinementEvents(obj, eventData)
    

switch eventData.EventName
    case 'basisFunctionsChangeInduced'
        
end

if ~isempty(obj.parametric2PhysicalJacobians)
     obj.evaluateAllDomainMappings; 
else obj.evaluateOnlyPointsInPhysicalDomain;
end

notify(obj, 'notifyCAGDTopologyChanged');

end