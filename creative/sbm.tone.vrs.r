sbm.tone.vrs = function (base = NULL, frontier = NULL, noutput = 1) 
{
    require(lpSolve)
    if (is.null(frontier)) 
        frontier <- base
    if (!is.null(base) & !is.null(frontier)) {
        base <- as.matrix(base)
        frontier <- as.matrix(frontier)
    }
    if (ncol(base) != ncol(frontier)) 
        stop("Number of columns in base matrix and frontier matrix should be the same!")
    s <- noutput
    m <- ncol(base) - s
    n <- nrow(base)
    nf <- nrow(frontier)
    front.Y <- t(frontier[, 1:s])
    front.X <- t(frontier[, (s + 1):(s + m)])
    base.Y <- t(base[, 1:s])
    base.X <- t(base[, (s + 1):(s + m)])
    
    max_y_positive = apply(base[,1:s], MARGIN = 2, function(x) max(x[x>0]))
    min_y_positive = apply(base[,1:s], MARGIN = 2, function(x) min(x[x>0]))
    re <- data.frame(matrix(0, nrow = n, ncol = 1 + nf + m + 
                                s))
    names(re) <- c("eff", paste("lambda", 1:nf, sep = ""), 
                   paste("slack.x",  1:m, sep = ""), 
                   paste("slack.y", 1:s, sep = ""))
    f.dir <- rep("==", 1 + m + s + 1)
    f.rhs <- c(1, rep(0, m + s + 1))
    for (i in 1:n) {
        x0 <- base.X[, i]
        y0 <- base.Y[, i]
        x0[x0 == 0] <- Inf
        #y0[y0 == 0] <- Inf
        coef_constraint1_s = y0
        for(r in 1:s)
        {    if(y0[r]<0)
            coef_constraint1_s[r]=min_y_positive[r]*(max_y_positive[r]-min_y_positive[r])/
                (max_y_positive[r]-y0[r])
        }
        f.obj <- c(1, rep(0, nf), -1/m * (1/x0), rep(0, s))
        f.con1 <- c(1, rep(0, nf), rep(0, m), 1/s * (1/coef_constraint1_s))
        f.con2 <- cbind(-x0, front.X, diag(m), matrix(0, m, s))
        f.con3 <- cbind(-y0, front.Y, matrix(0, s, m), -diag(s))
        f.con4 <- c(-1, rep(1, nf), rep(0, m + s))
        f.con <- rbind(f.con1, f.con2, f.con3, f.con4)
        re.tmp <- lp("min", f.obj, f.con, f.dir, f.rhs)
        re[i, 1] <- re.tmp$objval
        re.t <- re.tmp$solution[1]
        re[i, 2:(1 + nf + m + s)] <- re.tmp$solution[-1]/re.t
    }
    return(re)
}