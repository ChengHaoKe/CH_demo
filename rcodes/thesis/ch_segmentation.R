#文本集群分析所需要的擴充功能
install.packages("C:/R/R-3.2.3/library/tm_0.6-2.zip", repos = NULL)
install.packages("C:/R/R-3.2.3/library/slam_0.1-32.zip", repos = NULL)
library(slam)
library(tm)
install.packages("C:/R/R-3.2.3/library/NLP_0.1-8.zip", repos = NULL)
library(NLP)
install.packages("C:/R/R-3.2.3/library/tmcn_0.1-4.zip", repos = NULL)
library(tmcn)
install.packages("C:/R/R-3.2.3/library/proxy_0.4-15.zip", repos = NULL)
library(proxy)

#jiebaR 中文斷詞擴充功能
install.packages("C:/R/R-3.2.3/library/Rcpp_0.12.3.zip", repos = NULL)
library(Rcpp)
install.packages("C:/R/R-3.2.3/library/jiebaRD_0.1.zip", repos = NULL)
library(jiebaRD)
install.packages("C:/R/R-3.2.3/library/jiebaR_0.8.zip", repos = NULL)
library(jiebaR)

#fpc 擴充功能, 用於計算集群內統計
install.packages("C:/R/R-3.2.3/library/cluster_2.0.2.zip", repos = NULL)
library(cluster)
install.packages("C:/R/R-3.2.3/library/mclust_5.2.zip", repos = NULL)
library(mclust)
install.packages("C:/R/R-3.2.3/library/flexmix_2.3-13.zip", repos = NULL)
library(flexmix)
install.packages("C:/R/R-3.2.3/library/prabclus_2.2-6.zip", repos = NULL)
library(prabclus)
install.packages("C:/R/R-3.2.3/library/diptest_0.75-7.zip", repos = NULL)
library(diptest)
install.packages("C:/R/R-3.2.3/library/mvtnorm_1.0-5.zip", repos = NULL)
library(mvtnorm)
install.packages("C:/R/R-3.2.3/library/DEoptimR_1.0-4.zip", repos = NULL)
library(DEoptimR)
install.packages("C:/R/R-3.2.3/library/robustbase_0.92-5.zip", repos = NULL)
library(robustbase)
install.packages("C:/R/R-3.2.3/library/kernlab_0.9-24.zip", repos = NULL)
library(kernlab)
install.packages("C:/R/R-3.2.3/library/trimcluster_0.1-2.zip", repos = NULL)
library(trimcluster)
install.packages("C:/R/R-3.2.3/library/fpc_2.1-10.zip", repos = NULL)
library(fpc)

#進行 SVD 詞彙因素分析的擴充功能
install.packages("C:/R/R-3.2.3/library/lsa_0.73.1.zip", repos = NULL)
library(lsa)

#讀入檔案，並排除網路用語、標點符號、數字與空白空間
d.corpus <- readLines("D:/USBmemetics/textdata/youthrawdata/crWH_N0012.txt")

d.corpus2 <- removeWords(d.corpus, "BR")
d.corpus2 <- removePunctuation(d.corpus2)
d.corpus2 <- removeNumbers(d.corpus2)
d.corpus2 <- stripWhitespace(d.corpus2)

#jieba 斷詞
seg = worker(type = "mix", write = F, bylines = T)
d.corpus.seg <- seg[d.corpus2]

#建立(corpus) 文本集
d.corpus.seg <- Corpus(VectorSource(d.corpus.seg))
d.corpus.seg

#建立文件/詞彙矩陣
dtm2 = DocumentTermMatrix(d.corpus.seg,
                          control = list(wordLengths = c(2, Inf), weighting = function(x)
                            weightTfIdf(x, normalize = TRUE)))
dtm2


#排除高稀疏性的詞彙
dtm3 <- removeSparseTerms(dtm2, 0.9) #刪除頻率低於0.1 的詞彙(出現在少於10%文章的詞彙
dtm3
dtm3 <- as.matrix(dtm3)

#kmeans 組內平方和圖的繪製
wss <- (nrow(dtm3)-1)*sum(apply(dtm3, 2, var))
  for (i in 2:15) wss[i] <- sum(kmeans(dtm3, centers=i)$withinss)
plot(1:15, wss, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")

#文本階層集群分析
cosine.dist <- dist(dtm3, method = "cosine")
hc= hclust(cosine.dist, method = 'ward.D')
plot(hc,xlab= '')
rect.hclust(hc, k=5)
groups <- cutree(hc, k = 3:5)

#集群內與集群之間統計的計算
groups3 <- cutree(hc, k = 3)
groups4 <- cutree(hc, k = 4)
groups5 <- cutree(hc, k = 5)
groups6 <- cutree(hc, k = 6)
groups7 <- cutree(hc, k = 7)
groups8 <- cutree(hc, k = 8)
stats <- cluster.stats(cosine.dist, groups3)
stats <- cluster.stats(cosine.dist, groups4)
stats <- cluster.stats(cosine.dist, groups5)
stats <- cluster.stats(cosine.dist, groups6)
stats <- cluster.stats(cosine.dist, groups7)
stats <- cluster.stats(cosine.dist, groups8)
stats$cluster.size
stats$average.distance #within cluster average distances
stats$median.distance
stats$separation #minimum distances of a point in the cluster to a point of another cluster.
stats$average.toother #average distances ''
stats$ave.between.matrix #mean dissimilarities between points of every pair of clusters

#詞彙集群分析---------------------------------------------------------------------
#同樣先從建立文章/詞彙矩陣開始
dtm.freq = DocumentTermMatrix(d.corpus.seg,
                              control = list(wordLengths = c(2, Inf)))
dtm.freq

dtm.fre <- removeSparseTerms(dtm.freq, 0.9) #刪除頻率低於0.1 的詞彙

#詞彙集群分析，kmeans與階層集群
tdm <- t(dtm3)
wss.t <- (nrow(tdm)-1)*sum(apply(tdm, 2, var))
  for (i in 2:15) wss.t[i] <- sum(kmeans(tdm, centers=i)$withinss)
plot(1:15, wss.t, type = "b", xlab = "Number of Clusters", ylab = "Within groups sum of squares")

tcosine.dist <- dist(tdm, method = "cosine")
hc.t= hclust(tcosine.dist, method = 'ward.D')
plot(hc.t,xlab= '')
rect.hclust(hc.t, k=10)
tgroups <- cutree(hc.t, k = 3:10)

#-----------------------------------------------------
#詞彙因素分析，建構 svd 矩陣

svd.test <- lsa(tdm)
tk <- svd.test$tk
newmatrix <- dtm3 %*% tk
