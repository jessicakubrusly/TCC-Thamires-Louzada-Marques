#### Packages ####
library(ggplot2)
library(openxlsx)




#### Data ####
# Loading data
setwd("C:\\Users\\Thamires.Marques\\Documents\\TCC")
load("ValidationMetrics.RData")

# Models names object
model_names <- c("CART", "CART_b", "RF", "RF_b", "GBM", "GBM_b", "XGBOOST", "XGBOOST_b")

# Times comparison data frame
time_diff <- data.frame(Model = model_names, 
                        TimeDiff = c(as.numeric(t_cart), #min
                                     as.numeric(t_cart_balanced), #min
                                     as.numeric(t_rf)*60, #hour to min
                                     as.numeric(t_rf_balanced)*60, #hour to min
                                     as.numeric(t_gbm)/60, #sec to min
                                     as.numeric(t_gbm_balanced)/60, #sec to min
                                     as.numeric(t_xgboost)/60, #sec to min
                                     as.numeric(t_xgboost_balanced)/60)) #sec to min

# Ordering
time_diff <- time_diff %>% 
  arrange(-TimeDiff) %>% 
  mutate(Model = factor(Model, levels=unique(Model)))


# Table with metrics
metrics <- data.frame(Model = model_names)
metrics$Accuracy <- sapply(ls(pattern="cm_"), function(x) get(x)$overall[1])
metrics$Sensitivity <- sapply(ls(pattern="cm_"), function(x) get(x)$byClass[1])
metrics$Specificity <- sapply(ls(pattern="cm_"), function(x) get(x)$byClass[2])

# Exporting
write.xlsx(metrics, file="ModelMetrics.xlsx")




#### TimeDiff Graph ####
bp_time <- ggplot(time_diff, aes(x=Model, y=TimeDiff, label=round(TimeDiff,2))) + 
  geom_col(width=0.5, fill="dodgerblue4") + 
  coord_flip() + 
  labs(x = "Modelo", 
       y = "Tempo gasto (em minutos)") + 
  geom_text(position = position_dodge(width = .9),    # move to center of bars
            hjust = -0.1,    # nudge above top of bar
            size = 6, 
            color = "gray30") + 
  theme_minimal() + 
  theme(text=element_text(family="serif", face="bold", size=20, color="gray30"), 
        axis.text.x=element_blank()) + 
  scale_y_continuous(breaks=seq(0,140,20), limits=c(0,140))

# Saving
ggsave("barplot_time.png", plot=bp_time, width=12, height=7)

