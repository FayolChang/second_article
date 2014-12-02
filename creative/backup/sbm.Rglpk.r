# Lo, S.-F., & Lu, W.-M. (2009). An integrated performance evaluation of financial holding companies in Taiwan.
# European Journal of Operational Research, 198(1), 341–350. doi:10.1016/j.ejor.2008.09.006

# 选取模型3,按照模型8，9修改
sbm.Rglpk = function(X,Y)
{
    library(Rglpk)
#     require(lpSolve)
    #这里的sbm可以处理输出为负数的情形
    #要求矩阵每一行为一个公司
    N = nrow(X)
    m = ncol(X)
    s = ncol(Y)
    
#     变量分别为 
#     t
#     gamma_j,j=1..N
#     s_i^(-),i=1..m
#     s_r^(+),r=1..s

    efficiency = numeric(N)
    
    max_positive_y = apply(Y[,1:s], MARGIN = 2, function(x) max(x[x>0]))
    min_positive_y = apply(Y[,1:s], MARGIN = 2, function(x) min(x[x>0]))
    
    
    dir = rep("==",1+m+s+1)
    rhs = c(1,rep(0,m),rep(0,s),0)
    for(i in 1:N)
    {
        x = X[i,]
        y = Y[i,]
        
        #变量顺序按照t,gammaj,s_i,s_r 来修改
        coef_t = 1
        coef_gamma = rep(0,N)
        coef_s_i = -1/(m * x)
        coef_s_r = rep(0,s)

        obj = c(coef_t,coef_gamma,coef_s_i,coef_s_r)
        
        coef_constraint1_s=y
        for(r in 1:s)
        {
            if(y[r]<0){
                coef_constraint1_s[r] = 
                min_positive_y[r] * (max_positive_y[r] - min_positive_y[r])/
                (max_positive_y[r] - y[r])
            }
        }
        
        constraint1 =     c(1,  rep(0,N), rep(0,m) ,     1/(s*coef_constraint1_s))
        constraint2 = cbind(-x, t(X),     diag(m),       matrix(0,m,s))
        constraint3 = cbind(-y, t(Y),     matrix(0,s,m), -diag(s))
        constraint4 =     c(-1, rep(1,N), rep(0,m),      rep(0,s))
        
        mat = rbind(constraint1,constraint2,constraint3,constraint4)
        
        results = Rglpk_solve_LP(obj = obj,mat = mat,dir = dir,rhs = rhs,max = FALSE)
        efficiency[i] = results$optimum
#         results <- lp("min", obj, mat, dir, rhs)
#         efficiency[i] = results$objval
        
    }
    efficiency
}