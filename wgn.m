function y = wgn (m, n, p, varargin)
% ## Copyright (C) 2002 David Bateman
% ##
% ## This program is free software; you can redistribute it and/or modify it under
% ## the terms of the GNU General Public License as published by the Free Software
% ## Foundation; either version 3 of the License, or (at your option) any later
% ## version.
% ##
% ## This program is distributed in the hope that it will be useful, but WITHOUT
% ## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% ## FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
% ## details.
% ##
% ## You should have received a copy of the GNU General Public License along with
% ## this program; if not, see <http://www.gnu.org/licenses/>.
% 
% ## -*- texinfo -*-
% ## @deftypefn  {Function File} {@var{y} =} wgn (@var{m}, @var{n}, @var{p})
% ## @deftypefnx {Function File} {@var{y} =} wgn (@var{m}, @var{n}, @var{p}, @var{imp})
% ## @deftypefnx {Function File} {@var{y} =} wgn (@var{m}, @var{n}, @var{p}, @var{imp}, @var{seed})
% ## @deftypefnx {Function File} {@var{y} =} wgn (@dots{}, @var{type})
% ## @deftypefnx {Function File} {@var{y} =} wgn (@dots{}, @var{output})
% ##
% ## Returns a M-by-N matrix @var{y} of white Gaussian noise. @var{p} specifies
% ## the power of the output noise, which is assumed to be referenced to an
% ## impedance of 1 Ohm, unless @var{imp} explicitly defines the impedance.
% ##
% ## If @var{seed} is defined then the randn function is seeded with this
% ## value.
% ##
% ## The arguments @var{type} and @var{output} must follow the above numerical
% ## arguments, but can be specified in any order. @var{type} specifies the
% ## units of @var{p}, and can be 'dB', 'dBW', 'dBm' or 'linear'. 'dB' is
% ## in fact the same as 'dBW' and is keep as a misnomer of Matlab. The
% ## units of 'linear' are in Watts.
% ##
% ## The @var{output} variable should be either 'real' or 'complex'. If the
% ## output is complex then the power @var{p} is divided equally between the
% ## real and imaginary parts.
% ##
% ## @seealso{randn, awgn}
% ## @end deftypefn


  if (nargin < 3 || nargin > 7)
    help('wgn');
  end

  if (~isscalar (m) || ~isreal (m) || m < 0 || ~isscalar (n) || ...
      ~isreal (n) || n < 0)
    error ('wgn: M and N must be positive integers');
  end

  type = 'dBW';
  out = 'real';
  imp = 1;
  seed = [];
  narg = 0;

  for i = 1:length (varargin)
    arg = varargin{i};
    if (ischar (arg))
      if (strcmp (arg, 'real'))
        out = 'real';
      elseif (strcmp (arg, 'complex'))
        out = 'complex';
      elseif (strcmp (arg, 'dB'))
        type = 'dBW';
      elseif (strcmp (arg, 'dBW'))
        type = 'dBW';
      elseif (strcmp (arg, 'dBm'))
        type = 'dBm';
      elseif (strcmp (arg, 'linear'))
        type = 'linear';
      else
        error ('wgn: invalid argument ''%s''', arg);
      end
    else
      narg = narg + 1 ;
      switch (narg)
        case 1
          imp = arg;
        case 2
          seed = arg;
        otherwise
          error ('wgn: too many arguments');
      end
      end
    end

  if (isempty (imp))
    imp = 1;
  elseif (~isscalar (imp) || ~isreal (imp) || imp < 0)
    error ('wgn: IMP must be a non-negative scalar');
  end

  if (~isempty (seed))
    if (~ (isscalar (seed) && isreal (seed) && seed == fix (seed) && seed >= 0))
      error ('wgn: random SEED must be integer');
    end
  end

  if (~isscalar (p) || ~isreal (p))
    error ('wgn: P must be a scalar');
  end
  if (strcmp (type, 'linear') && p < 0)
    error ('wgn: P must be a non-negative scalar for TYPE ''linear''');
  end
  
  if (strcmp (type, 'dBW'))
    np = 10^(p/10);
  elseif (strcmp (type, 'dBm'))
    np = 10^((p - 30)/10);
  elseif (strcmp (type, 'linear'))
    np = p;
  end

  if (~isempty (seed))
    randn ('state', seed);
  end

  if (strcmp (out, 'complex'))
    y = (sqrt (imp*np/2)) * (randn (m, n) + 1i*randn (m, n));
  else
    y = (sqrt (imp*np)) * randn (m, n);
  end

  end

%## Allow 30% error in standard deviation, due to randomness
%!assert (isreal (wgn (10, 10, 30, 1, 'dBm', 'real')));
%!assert (iscomplex (wgn (10, 10, 30, 1, 'dBm', 'complex')));
%!assert (abs (std (wgn (10000, 1, 30, 1, 'dBm')) - 1) < 0.3);
%!assert (abs (std (wgn (10000, 1, 0, 1, 'dBW')) - 1) < 0.3);
%!assert (abs (std (wgn (10000, 1, 1, 1, 'linear')) - 1) < 0.3);

%% Test input validation
%!error wgn ();
%!error wgn (1);
%!error wgn (1, 1);
%!error wgn (1, 1, 1, 1, 1, 1);
