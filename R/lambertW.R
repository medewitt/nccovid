#' Lambert W function
#' 
#' Computes the Lambert W function, giving efficient solutions to the equation x*exp(x)==x
#' lambertW(z, b = 0, maxiter = 10, eps = .Machine$double.eps, min.imag = 1e-09)
#' 
#' @param z (complex) vector of values for which to compute the function
#' @param b integer, defaults to 0. vector of branches: b=0 specifies the principal
#'     branch, 0 and -1 are the ones that can take non-complex values
#' @param maxiter maximum numbers of iterations for convergence
#' @param eps convergence tolerance
#' @param min.imag maximum magnitude of imaginary part to chop when returning solutions
#' 
#' @details Compute the Lambert W function of z.  This function satisfies
#' W(z)*exp(W(z)) = z, and can thus be used to express solutions
#' of transcendental equations involving exponentials or logarithms.
#' The Lambert W function is also available in
#' Mathematica (as the ProductLog function), and in Maple and Wolfram.
#' @references Corless, Gonnet, Hare, Jeffrey, and Knuth (1996), "On the Lambert
#' W Function", Advances in Computational Mathematics 5(4):329-359
#' @author Nici Schraudolph <schraudo at inf.ethz.ch> (original
#'   version (c) 1998), Ben Bolker (R translation)
#'   See <https://stat.ethz.ch/pipermail/r-help/2003-November/042793.html>
#' @export
lambertW = function(z,b=0,maxiter=10,eps=.Machine$double.eps,
										min.imag=1e-9) {
	if (any(round(Re(b)) != b))
		stop("branch number for W must be an integer")
	if (!is.complex(z) && any(z<0)) z=as.complex(z)
	## series expansion about -1/e
	##
	## p = (1 - 2*abs(b)).*sqrt(2*e*z + 2);
	## w = (11/72)*p;
	## w = (w - 1/3).*p;
	## w = (w + 1).*p - 1
	##
	## first-order version suffices:
	##
	w = (1 - 2*abs(b))*sqrt(2*exp(1)*z + 2) - 1
	## asymptotic expansion at 0 and Inf
	##
	v = log(z + as.numeric(z==0 & b==0)) + 2*pi*b*1i;
	v = v - log(v + as.numeric(v==0))
	## choose strategy for initial guess
	##
	c = abs(z + exp(-1));
	c = (c > 1.45 - 1.1*abs(b));
	c = c | (b*Im(z) > 0) | (!Im(z) & (b == 1))
	w = (1 - c)*w + c*v
	## Halley iteration
	##
	for (n in 1:maxiter) {
		p = exp(w)
		t = w*p - z
		f = (w != -1)
		t = f*t/(p*(w + f) - 0.5*(w + 2.0)*t/(w + f))
		w = w - t
		if (abs(Re(t)) < (2.48*eps)*(1.0 + abs(Re(w)))
				&& abs(Im(t)) < (2.48*eps)*(1.0 + abs(Im(w))))
			break
	}
	if (n==maxiter) warning(paste("iteration limit (",maxiter,
																") reached, result of W may be inaccurate",sep=""))
	if (all(Im(w)<min.imag)) w = as.numeric(w)
	return(w)
}