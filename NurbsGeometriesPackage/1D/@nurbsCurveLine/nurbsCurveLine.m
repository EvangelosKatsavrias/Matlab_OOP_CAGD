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

% NURBS circular domain
classdef nurbsCurveLine < nurbsGeometry

    methods
        function obj = nurbsCurveLine(varargin) %(origin, radius, arcAngle, arcOrientationAngleInPlane)
            constructorData = constructorPreprocessor(varargin{:});
            obj@nurbsGeometry(constructorData{1:2});
            constructorPostprocessor(obj, varargin{:});
        end
        
    end

end


%%
function constructorData = constructorPreprocessor(varargin)

if nargin == 0; points = [0 0 0; 1 0 0]; weights = [1 1 1]'; degree = 1;
else points = varargin{1}; weights = varargin{2}; degree = varargin{3};
end

uKnotVector = knotVector([zeros(1, degree), linspace(0, 1, length(weights)-degree+1), ones(1, degree)]);

controlPoints   = rationalControlPointsStructure('Cartesian', points, weights);
constructorData = [{uKnotVector, controlPoints} varargin];

end

function constructorPostprocessor(obj, varargin)


end



% Create arbitrary NURBS circular arc
% Input: O, X, Y, radius, thetaStart, thetaEnd
% Output: n, U, Pw

% if (thetaEnd < thetaStart); thetaEnd = 360.0 + thetaEnd; end
% 
% arcAngle = thetaEnd-thetaStart;
% 
% if (arcAngle <= 90.0); numOfArcs = 1; % get number of arc
% elseif (arcAngle <= 180.0); numOfArcs = 2;
% elseif (arcAngle <= 270.0); numOfArcs = 3;
% else numOfArcs = 4;
% end
% 
% dtheta = arcAngle/numOfArcs;
% 
% n = 2*narcs; % n+1 control points
% w1 = cos(dtheta/2.0); % dtheta/2 is base angle
% 
% PO = [radius*cos(thetaStart)
%       radius*sin(thetaStart)];
% 
% TO = [-sin(thetaStart)
%        cos(thetaStart)]; % Initialize start values
% 
% Pw(1) = PO; index = 1; angle = thetaStart;
% 
% for i = 1:narcs % create numOfArcs segments
%     
%     angle = angle + dtheta;
%     
%     P2 = [radius*cos(angle)
%           radius*sin(angle)];
%     
%     Pw(index+2) = P2;
%     
%     T2 = [-sin(angle)
%            cos(angle)];
%     
%     Intersect3DLines(PO,TO,P2,T2,dummy,dummy,P1);
%     
%     Pw(index+1) = w1*P1;
%     
%     index = index + 2;
%     
%     if (i < numOfArcs); PO = P2; TO = T2; end
% 
% end
% 
% 
% j = 2*narcs+1; % load the knot vector
% 
% for i=1:3
%     U(i) = 0.0;
%     U(i+j) = 1.0;
% end
% 
% switch (numOfArcs)
%     case 1
%     case 2
%         U(3) = 0.5;
%         U(4) = 0.5;
%     case 3
%         U(3) = 1.0/3.0;
%         U(4) = 1.0/3.0;
%         U(5) = 2.0/3.0;
%         U(6) = 2.0/3.0;
% 
%     case 4
%         U(3) = 0.25;
%         U(4) = 0.25;
%         U(5) = 0.5;
%         U(6) = 0.5;
%         U(7) = 0.75;
%         U(8) = 0.75;
% 
% end
