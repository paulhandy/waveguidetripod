

## Copyright (c) 2012 Juan Pablo Carbajal

##

## This program is free software: you can redistribute it and/or modify

## it under the terms of the GNU General Public License as published by

## the Free Software Foundation, either version 3 of the License, or

## any later version.

##

## This program is distributed in the hope that it will be useful,

## but WITHOUT ANY WARRANTY; without even the implied warranty of

## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the

## GNU General Public License for more details.

##

## You should have received a copy of the GNU General Public License

## along with this program. If not, see <http://www.gnu.org/licenses/>.

 

## -*- texinfo -*-

## @deftypefn {Function File} {@var{h} =} srl_plot ()

## @deftypefnx {Function File} {@var{h} =} srl_plot (@var{property},@var{value})

## Plots data read from the serial port.

##

## @strong{Properties}

## @table @asis

## @item "Figure"

## Default @code{gcf()}

## @item "QeueSize"

## Default 1e3.

## @item "BufferSize"

## Default 1e2.

## @item "Baudrate"

## Default 9600

## @item "Timeout"

## Default 1e3 ms.

## @item "Axis"

## Default @code{[0 1e3 0 255]}.

## @item "PlotMethod"

## Default @asis{"data"};

## @end table

##

## @seealso{srl_read, srl_write}

## @end deftypefn

 

## Author: Juan Pablo Carbajal <ajuanpi+dev@gmail.com>

 

function h = srl_plot (varargin)

 

% Parse argumnets %%%%%%%%%%%%

parser = inputParser ();

parser.FunctionName = "srl_plot";

 

parser = addParamValue (parser, "Figure", gcf (), @isindex);

parser = addParamValue (parser, "QeueSize", 1e3, @(x) x > 0 );

parser = addParamValue (parser, "BufferSize", 1e2, @(x) x > 0 );

parser = addParamValue (parser, "Baudrate", 9600, @isbaud);

parser = addParamValue (parser, "Timeout", 1e3, @(x) x > 0 ); % in ms

parser = addParamValue (parser, "Axis", [0 1e3 0 255]);

parser = addParamValue (parser, "PlotMethod", "data");

 

parser = parse (parser, varargin{:});

 

fig = parser.Results.Figure;

qsize = parser.Results.QeueSize;

bsize = parser.Results.BufferSize;

baud = parser.Results.Baudrate;

timeo = parser.Results.Timeout/1e3*10; %to ds

axistyp = parser.Results.Axis;

plotmet = parser.Results.PlotMethod;

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

% Open serial port

s = serial ();

srl_baudrate (s,baud);

srl_timeout (s,timeo);

srl_flush (s);

 

% Prepare plot

% Change graphics toolkit

figure(fig);

graphics_toolkit (fig, "fltk");

 

x = (1:qsize)';

y = nan (qsize,1);

h = plot (x,y,'-');

axis (axistyp);

 

% Initate transmission

srl_write (s, "\r");

 

% Get data

idx = 0;

switch plotmet

   

case "source"

  set (h,"ydatasource","y");

   

  while true

     

    [data n] = srl_read (s, bsize);

    [y idx] = updatedata (y,data,idx,n,qsize);

    refreshdata (fig, "caller");

    sleep (0.008);

     

  endwhile

   

case "data"

   

  while (true)

     

    [data n] = srl_read (s, bsize);

    [y idx] = updatedata (y,data,idx,n,qsize);

    set (h, "ydata", y);

    drawnow ();

    sleep (0.008)

     

  endwhile

   

endswitch

 

 

% Close serial port

srl_close (s);

 

endfunction

 

function [y idxnew scrap] = updatedata (y, data, idx, n, qsize)

persistent qeue_full

 

if isempty(qeue_full)

  % While queue not full, increase the position in the queue

  idxnew = idx + n;

else

  % Once is full just return how much data was pushed in.

  idxnew = n;

end

 

if qeue_full

  % The qeue is full push the n entries

  scrap = y(1:n);

  y(1:qsize-n) = y(n+1:qsize);

  y(qsize-n+1:qsize) = double (data);

   

elseif idxnew > qsize

  % The qeue will be full next iteration

  % insert the elements that fit, push the rest.

  in = n - (qsize - idx);

  out = idx - in;

   

  scrap = y(1:out);

  y(1:out) = y(in+1:idx);

  y(out+1:qsize) = double (data);

   

  qeue_full = true;

   

else

  % The qeue is still not full, insert elements.

  y(idx+1:idxnew) = double (data);

  scrap = [];

   

endif

 

endfunction

% Validator functions

function v = isbaud (x)

v = any(x == [0, 50, 75, 110, 134, 150, 200, 300, 600, ...

1200, 1800, 2400, 4800, 9600 19200, 38400, ...

57600, 115200, 230400]);

endfunction

