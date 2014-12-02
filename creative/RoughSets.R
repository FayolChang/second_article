#第一步，reduct
#第二步，看选择不平衡分类还是平衡分类。

library(RoughSets)

decisionTable = AddST_permanent %>%
                mutate(ST = as.factor(ST),efficiency = efficiency) %>%
                select(-Stkcd,-Accper,-Year)
decisionTable = SF.asDecisionTable(decisionTable,decision.attr=22,indx.nominal=22)

reduct.quick = FS.greedy.heuristic.reduct.RST(decisionTable,decisionIdx=22,qualityF=X.entropy)


newDecTable2 = SF.applyDecTable(decisionTable,reduct.quick)


