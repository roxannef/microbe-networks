##16S####################
#Import data
ps.16S <- readRDS(file = "rds/16S_crn.ps.deseq-new.Rds")

#What kind of metadata can we look at to see if there is a significant difference in the community structure
ps.16S_dis <- phyloseq::distance(ps.16S, method = "bray")
ps.16S_ord<- ordinate(ps.16S, method ="NMDS", ps.16S_dis)

#look into using vegan-adonis to determine statistical significance
ps.16S_df <- as(sample_data(ps.16S),"data.frame")

type_16S <- adonis(ps.16S_dis~type, ps.16S_df)
results_16S <- as.data.frame(type_16S$aov.tab)[1:3,]
rownames(results_16S)[2] = paste(rownames(results_16S)[1],'.',rownames(results_16S)[2], sep= "")
rownames(results_16S)[3] = paste(rownames(results_16S)[1],'.',rownames(results_16S)[3], sep="")

for (i in c("year","grower_ID","fum_presence")){
    form <- formula(paste("ps.16S_dis~",i))
    z <- adonis(form, ps.16S_df)
    x <- as.data.frame(z$aov.tab)[1:3,]
    rownames(x)[2] = paste(rownames(x)[1],'.',rownames(x)[2], sep="")
    rownames(x)[3] = paste(rownames(x)[1],'.',rownames(x)[3], sep="")
    results_16S <- rbind(results_16S, x)
}
print(results_16S)
write.csv(results_16S, "images/ordination_16S.csv")

col.pal <- wes_palette(n = 6, name = "Darjeeling2", type = "continuous")
palette(col.pal)
plot_ordination(ps.16S, ps.16S_ord, color = "type")

##ITS###########
#Import data
ps.ITS <- readRDS(file = "rds/ITS_crn.ps.deseq-new.Rds")

#What kind of metadata can we look at to see if there is a significant difference in the community structure
names(sample_data(ps.ITS))

ps.ITS_dis <- phyloseq::distance(ps.ITS, method = "bray")
ps.ITS_ord1<- ordinate(ps.ITS, method ="NMDS", ps.ITS_dis)

#look into using vegan-adonis to determine statistical significance
ps.ITS_df <- as(sample_data(ps.ITS),"data.frame")

type_grower.ITS <- as.data.frame(adonis(ps.ITS_dis ~type+grower_ID, ps.ITS_df)$aov.tab)
write.csv(type_grower.ITS, "images/ordination_type+growerITS.csv")

grower_type.ITS <- as.data.frame(adonis(ps.ITS_dis ~grower_ID+type, ps.ITS_df)$aov.tab)
write.csv(grower_type.ITS, "images/ordination_grower+typeITS.csv")

type_ITS <- adonis(ps.ITS_dis~type, ps.ITS_df)
results_ITS <- as.data.frame(type_ITS$aov.tab)[1:3,]
rownames(results_ITS)[2] = paste(rownames(results_ITS)[1],'.',rownames(results_ITS)[2], sep="")
rownames(results_ITS)[3] = paste(rownames(results_ITS)[1],'.',rownames(results_ITS)[3], sep="")
for (i in c(ps.ITS_dis ~year,ps.ITS_dis ~grower_ID,ps.ITS_dis ~fum_presence)){
  z <- adonis(i, ps.ITS_df)
  x <- as.data.frame(z$aov.tab)[1:3,]
  rownames(x)[2] = paste(rownames(x)[1],'.',rownames(x)[2], sep="")
  rownames(x)[3] = paste(rownames(x)[1],'.',rownames(x)[3], sep="")
  results_ITS <- rbind(results_ITS, x)
}
print(results_ITS)
write.csv(results_ITS, "images/ordination_ITS.csv")

col.pal <- wes_palette(n = 6, name = "Darjeeling2", type = "continuous")
palette(col.pal)
plot_ordination(ps.ITS, ps.ITS_ord1, color = "type")
