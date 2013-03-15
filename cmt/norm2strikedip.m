function [strike,dip]=norm2strikedip(n,e,u)
%NORM2STRIKEDIP    Returns strike & dip given the normal to a fault plane
%
%    Usage:    sd=norm2strikedip(neu)
%              sd=norm2strikedip(n,e,u)
%              [strike,dip]=norm2strikedip(...)
%
%    Description:
%     SD=NORM2STRIKEDIP(NEU) finds the strike and dip of a fault plane with
%     a normal vector given as [North East Up] in NEU.  SD is returned as
%     [strike dip] in degrees where strike is relative to North and dip is
%     positive downward from the horizontal.  Note that the strike is given
%     so that when you look along the direction of the strike the fault
%     dips to your right.  NEU is Nx3 where N allows for multiple vectors
%     to be converted simultaneously (SD is Nx2).
%
%     SD=NORM2STRIKEDIP(N,E,U) allows North, East & Up to be given
%     separately.
%
%     [STRIKE,DIP]=NORM2STRIKEDIP(...) returns the strike & dip separately.
%
%    Notes:
%     - Strike & Dip are independent of whether the normal vector points
%       toward the hanging wall (default from STRIKEDIP2NORM) or the foot
%       wall.
%
%    Examples:
%     % What are the strikes and dips of the planes for a series of normals
%     % going from North to South through the up axis:
%     norm2strikedip(cosd(0:30:180),0,sind(0:30:180))
%
%     % Strikes & dips for a series of normals circling the up axis:
%     norm2strikedip(cosd(0:30:360),sind(0:30:360),1)
%
%    See also: STRIKEDIP2NORM, SDR2NULL, SDR2SLIP, AUXPLANE, SDR2TPB,
%              TPB2SDR, NORMSLIP2SDR, NODALLINES

%     Version History:
%        Mar.  8, 2010 - initial version
%        Mar. 22, 2010 - added docs
%        June  1, 2011 - improved docs
%        Mar. 14, 2013 - rewrite, rename
%        Mar. 15, 2013 - rename again for clarity
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Mar. 15, 2013 at 15:05 GMT

% todo:

% check nargin
error(nargchk(1,3,nargin));

% single or trip input
switch nargin
    case 1
        if(size(n,2)~=3 || ndims(n)>2)
            error('seizmo:norm2strikedip:badInput',...
                'NEU must be a Nx3 array as [N E U] !');
        elseif(~isnumeric(n) || ~isreal(n))
            error('seizmo:norm2strikedip:badInput',...
                'NEU must be a real-valued Nx3 array!');
        end
        [n,e,u]=deal(n(:,1),n(:,2),n(:,3));
    case 3
        if(~isnumeric(n) || ~isreal(n) || ~isnumeric(e) || ~isreal(e) ...
                || ~isnumeric(u) || ~isreal(u))
            error('seizmo:norm2strikedip:badInput',...
                'N/E/U must be real-valued arrays!');
        end
        [n,e,u]=expandscalars(n,e,u);
    otherwise
        error('seizmo:norm2strikedip:badNumInputs',...
            'Incorrect number of inputs (only 1 or 3)!');
end

% conversion
R2D=180/pi;

% make sure normals are always pointing up at hanging block
% - this is needed to preserve the appropriate strike & dip
%   relationship while keeping the dip in the 0-90deg range
% - also keeps the normal vector & slip vector relationship
%   between the fault & auxiliary planes
j=find(u<0);
n(j)=-n(j);
e(j)=-e(j);
u(j)=-u(j);

% get strike (unfortunately we loose precision b/c of atan2)
strike=mod(atan2(-n,e)*R2D,360);

% get dip
dip=acosd(u./sqrt(n.^2+e.^2+u.^2));
%dip=atan2(sqrt(n.^2+e.^2),u)*R2D;

% combine if only one output
if(nargout<=1); strike=[strike(:) dip(:)]; end

end