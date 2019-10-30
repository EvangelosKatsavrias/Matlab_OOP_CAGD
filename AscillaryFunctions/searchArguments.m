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

function [flag, varargout] = searchArguments(groupOfArguments, string, varargin)
% input args: {string flags, and other input data}, 'typeOfOtherDataToPass:'numeric', 'char''

flag = 0;
if nargout > 1; varargout{1} = 0; end

pos = find(strcmp(groupOfArguments, string));

if pos
    flag = 1;    
    if nargout > 1
        if length(groupOfArguments) > pos
            if isa(groupOfArguments{pos+1}, varargin{1})
                varargout{1} = pos+1;
            else
                throw(MException('searchArguments:InputArguments', ['The input argument in position ' num2str(pos+1) ' is not valid, must be of type ' varargin{1} '.']));
            end
        else
            throw(MException('searchArguments:InsufficientInputArguments', ['The flag input argument in position ' num2str(pos) ', requires subsequent definition values of type ' varargin{1} '.']));
        end
    end
end

end


% function [flag, varargout] = searchArguments(groupOfArguments, string, varargin)
% 
% flag = 0;
% if nargout > 1
%     varargout{1} = 0;
% end
% 
% argListLength = length(groupOfArguments);
% for index = 1:argListLength
% 
%     if strcmp(groupOfArguments{index}, string)
%         flag = 1;
%         
%         if nargout > 1
%             if argListLength > index
%                 if isa(groupOfArguments{index+1}, varargin{1})
%                     varargout{1} = index+1;
%                 else
%                     msgID = 'General:InputArguments';
%                     msg = ['The input argument in position ' num2str(index+1) ' is not valid, must be of type ' varargin{1} '.'];
%                     Exception = MException(msgID, msg);
%                     throw(Exception);
%                 end
%             else
%                 msgID = 'General:InsufficientInputArguments';
%                 msg = ['The flag input argument in position ' num2str(index) ', requires subsequent definition values of type ' varargin{1} '.'];
%                 Exception = MException(msgID, msg);
%                 throw(Exception);
%             end
%         end
%             
%         break
%         
%     end
%     
% end
% 
% end