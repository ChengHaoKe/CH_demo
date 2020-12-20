#安裝時間序列擴充功能
install.packages("C:/R/R-3.2.3/library/zoo_1.7-12.zip", repos = NULL)
library(zoo)
install.packages("C:/R/R-3.2.3/library/xts_0.9-7.zip", repos = NULL)
library(xts)

#因為forecast 擴充功能需要的套件很多，因此直接以連線的方式安裝所有需要的套件
install.packages("forecast", repos = "http://cran.csie.ntu.edu.tw/", dependencies = TRUE)
library(forecast)

#如果在線性模型中要計算標準化BETA值，則需要安裝這個擴充功能
install.packages("C:/R/R-3.2.3/library/lm.beta_1.5-1.zip", repos = NULL)
library(lm.beta)

#讀入資料
tstable <- read.table(file="D:/USBmemetics/textdata/youthrawdata/forTS/tsWH_N0012.csv",sep=",",header=T)
names(tstable)
head(tstable, 5)
dim(tstable)


#建立時間序列物件
#模因類種原始序列與log(x+1)序列的轉化
clu7.ts <- ts(tstable$allWH_N0012, freq = 7)

clu71.ts <- ts(tstable$clu7_1, freq = 7)
clu72.ts <- ts(tstable$clu7_2, freq = 7)
clu73.ts <- ts(tstable$clu7_3, freq = 7)
clu74.ts <- ts(tstable$clu7_4, freq = 7)
clu75.ts <- ts(tstable$clu7_5, freq = 7)
clu76.ts <- ts(tstable$clu7_6, freq = 7)
clu77.ts <- ts(tstable$clu7_7, freq = 7)

logall.ts <- ts(tstable$logall, freq = 7)
log1.ts <- ts(tstable$log1, freq = 7)
log2.ts <- ts(tstable$log2, freq = 7)
log3.ts <- ts(tstable$log3, freq = 7)
log4.ts <- ts(tstable$log4, freq = 7)
log5.ts <- ts(tstable$log5, freq = 7)
log6.ts <- ts(tstable$log6, freq = 7)
log7.ts <- ts(tstable$log7, freq = 7)

#詞彙組時間序列轉化
tdm3.ts <- ts(tstable$tdm3w, freq = 7)
tdm9.ts <- ts(tstable$tdm9w, freq = 7)
tdm10.ts <- ts(tstable$tdm10w, freq = 7)
tdm11.ts <- ts(tstable$tdm11w, freq = 7)

v1.ts <- ts(tstable$v1ts, freq = 7)
v2.ts <- ts(tstable$v2ts, freq = 7)
v3.ts <- ts(tstable$v3ts, freq = 7)
v4.ts <- ts(tstable$v4ts, freq = 7)
v5.ts <- ts(tstable$v5ts, freq = 7)
v6.ts <- ts(tstable$v6ts, freq = 7)
v7.ts <- ts(tstable$v7ts, freq = 7)
v8.ts <- ts(tstable$v8ts, freq = 7)
v9.ts <- ts(tstable$v9ts, freq = 7)
v10.ts <- ts(tstable$v10ts, freq = 7)
v11.ts <- ts(tstable$v11ts, freq = 7)
v12.ts <- ts(tstable$v12ts, freq = 7)
v13.ts <- ts(tstable$v13ts, freq = 7)
v14.ts <- ts(tstable$v14ts, freq = 7)
v15.ts <- ts(tstable$v15ts, freq = 7)
v16.ts <- ts(tstable$v16ts, freq = 7)
v17.ts <- ts(tstable$v17ts, freq = 7)
v18.ts <- ts(tstable$v18ts, freq = 7)
v19.ts <- ts(tstable$v19ts, freq = 7)
v20.ts <- ts(tstable$v20ts, freq = 7)
v21.ts <- ts(tstable$v21ts, freq = 7)
v22.ts <- ts(tstable$v22ts, freq = 7)
v23.ts <- ts(tstable$v23ts, freq = 7)
v24.ts <- ts(tstable$v24ts, freq = 7)
v25.ts <- ts(tstable$v25ts, freq = 7)
v26.ts <- ts(tstable$v26ts, freq = 7)
v27.ts <- ts(tstable$v27ts, freq = 7)
v28.ts <- ts(tstable$v28ts, freq = 7)
v29.ts <- ts(tstable$v29ts, freq = 7)
v30.ts <- ts(tstable$v30ts, freq = 7)
v31.ts <- ts(tstable$v31ts, freq = 7)
v32.ts <- ts(tstable$v32ts, freq = 7)
v33.ts <- ts(tstable$v33ts, freq = 7)
v34.ts <- ts(tstable$v34ts, freq = 7)
v35.ts <- ts(tstable$v35ts, freq = 7)
v36.ts <- ts(tstable$v36ts, freq = 7)
v37.ts <- ts(tstable$v37ts, freq = 7)
v38.ts <- ts(tstable$v38ts, freq = 7)
v39.ts <- ts(tstable$v39ts, freq = 7)
v40.ts <- ts(tstable$v40ts, freq = 7)
v41.ts <- ts(tstable$v41ts, freq = 7)

#透過標準差探討趨勢與季節性強度
plot(decompose(len1.ts, "additive")) #multiplicative gives too many NA values
tsdecomp <- decompose(len7.ts, "additive")

sd(clu7.ts[3:231])
sd(clu7.ts[3:231] - clu7.tsd$trend[3:231])
sd(clu7.tsd$random[3:231])

sd(log7.ts[4:272])
sd(log7.ts[4:272] - log7.tsd$trend[4:272])
sd(log7.tsd$random[4:272])


#透過線性模型排除趨勢與季節性
clu7.tsd <- decompose(clu7.ts, "additive")
plot.ts(clu7.tsd$random[3:231])

clu71.tsd <- decompose(clu71.ts, "additive")
plot.ts(clu71.tsd$random[4:272])
clu72.tsd <- decompose(clu72.ts, "additive")
plot.ts(clu72.tsd$random[4:272])
clu73.tsd <- decompose(clu73.ts, "additive")
plot.ts(clu73.tsd$random[4:272])
clu74.tsd <- decompose(clu74.ts, "additive")
plot.ts(clu74.tsd$random[4:272])
clu75.tsd <- decompose(clu75.ts, "additive")
plot.ts(clu75.tsd$random[4:272])
clu76.tsd <- decompose(clu76.ts, "additive")
plot.ts(clu76.tsd$random[4:272])
clu77.tsd <- decompose(clu77.ts, "additive")
plot.ts(clu77.tsd$random[4:272])

log1.tsd <- decompose(log1.ts, "additive")
plot.ts(log1.tsd$random[4:272])
log2.tsd <- decompose(log2.ts, "additive")
plot.ts(log2.tsd$random[4:272])
log3.tsd <- decompose(log3.ts, "additive")
plot.ts(log3.tsd$random[4:272])
log4.tsd <- decompose(log4.ts, "additive")
plot.ts(log4.tsd$random[4:272])
log5.tsd <- decompose(log5.ts, "additive")
plot.ts(log5.tsd$random[4:272])
log6.tsd <- decompose(log6.ts, "additive")
plot.ts(log6.tsd$random[4:272])
log7.tsd <- decompose(log7.ts, "additive")
plot.ts(log7.tsd$random[4:272])
logall.tsd <- decompose(logall.ts, "additive")

#透過一階差分排除趨勢與季節性
log1.diff <- diff(log1.ts)
log2.diff <- diff(log2.ts)
log3.diff <- diff(log3.ts)
log4.diff <- diff(log4.ts)
log5.diff <- diff(log5.ts)
log6.diff <- diff(log6.ts)
log7.diff <- diff(log7.ts)
logall.diff <- diff(logall.ts)

diff1.ts <- ts(log1.diff, freq = 7)
diff.ts

#模因類種自我相關圖與偏自我相關圖
print(acf(clu7.tsd$random[3:231]))

print(acf(clu71.ts[1:275]))
print(acf(log1.tsd$random[4:272]))
print(acf(log1.diff[1:274]))
print(pacf(clu71.ts[1:275]))
print(pacf(log1.tsd$random[4:272]))
print(pacf(log1.diff[1:274]))

#模因類種ARIMA模型計算
Arima(log1.ts, order = c(1,1,0))
Arima(log1.ts, order = c(3,1,0))
Arima(log1.ts, order = c(0,1,3))
Arima(log1.ts, order = c(0,1,2))
Arima(log1.ts, order = c(0,1,1))
auto.arima(log1.ts)

a1 <- Arima(log1.ts, order = c(1,1,0))
a2 <- Arima(log1.ts, order = c(3,1,0))
a3 <- Arima(log1.ts, order = c(0,1,3))
a4 <- Arima(log1.ts, order = c(0,1,2))
a5 <- Arima(log1.ts, order = c(0,1,1))
a6 <- auto.arima(log1.ts)
acf(a1$residuals[1:275])
pacf(a1$residuals[1:275])
hist(a1$residuals[1:275])

acf(a2$residuals[1:275])
pacf(a2$residuals[1:275])
hist(a2$residuals[1:275])

acf(a3$residuals[1:275])
pacf(a3$residuals[1:275])
hist(a3$residuals[1:275])
qqnorm(a3$residuals[1:275]); qqline(a3$residuals[1:275], col = "red")

acf(a4$residuals[1:275])
pacf(a4$residuals[1:275])
hist(a4$residuals[1:275])
qqnorm(a4$residuals[1:275]); qqline(a4$residuals[1:275], col = "red")

acf(a5$residuals[1:275])
pacf(a5$residuals[1:275])
hist(a5$residuals[1:275])

acf(a6$residuals[1:275])
pacf(a6$residuals[1:275])
hist(a6$residuals[1:275])
qqnorm(a6$residuals[1:275]); qqline(a6$residuals[1:275], col = "red")

print(acf(clu74.ts[1:275]))
print(acf(log4.tsd$random[4:272]))
print(acf(log4.diff[1:274]))
print(pacf(clu74.ts[1:275]))
print(pacf(log4.tsd$random[4:272]))
print(pacf(log4.diff[1:274]))

Arima(log4.ts, order = c(1,1,0))
Arima(log4.ts, order = c(4,1,0))
Arima(log4.ts, order = c(0,1,3))
Arima(log4.ts, order = c(0,1,1))
Arima(log4.ts, order = c(3,1,1))
auto.arima(log4.ts)

b1 <- Arima(log4.ts, order = c(1,1,0))
b2 <- Arima(log4.ts, order = c(4,1,0))
b3 <- Arima(log4.ts, order = c(0,1,3))
b4 <- Arima(log4.ts, order = c(0,1,1))
b5 <- Arima(log4.ts, order = c(3,1,1))
acf(b3$residuals[1:275])
pacf(b3$residuals[1:275])
hist(b3$residuals[1:275])

acf(b4$residuals[1:275])
pacf(b4$residuals[1:275])
hist(b4$residuals[1:275])

acf(b5$residuals[1:275])
pacf(b5$residuals[1:275])
hist(b5$residuals[1:275])

#模因類種自我相關顯著性檢定
Box.test(clu7.tsd$random[3:231], lag = 20, type = "Ljung-Box") #evidence of non-zero autocorrelations at lags 1-20

Box.test(clu71.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(clu72.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(clu73.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(clu74.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(clu75.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(clu76.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(clu77.tsd$random[4:272], lag = 20, type = "Ljung-Box")

Box.test(log1.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(log2.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(log3.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(log4.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(log5.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(log6.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(log7.tsd$random[4:272], lag = 20, type = "Ljung-Box")

Box.test(log1.diff, lag = 20, type = "Ljung-Box")
Box.test(log2.diff, lag = 20, type = "Ljung-Box")
Box.test(log3.diff, lag = 20, type = "Ljung-Box")
Box.test(log4.diff, lag = 20, type = "Ljung-Box")
Box.test(log5.diff, lag = 20, type = "Ljung-Box")
Box.test(log6.diff, lag = 20, type = "Ljung-Box")
Box.test(log7.diff, lag = 20, type = "Ljung-Box")


#詞彙組透過線性模型排除季節與趨勢
tdm3.tsd <- decompose(tdm3.ts, "additive")
tdm9.tsd <- decompose(tdm9.ts, "additive")
tdm10.tsd <- decompose(tdm10.ts, "additive")
tdm11.tsd <- decompose(tdm11.ts, "additive")

v1.tsd <- decompose(v1.ts, "additive")
v2.tsd <- decompose(v2.ts, "additive")
v3.tsd <- decompose(v3.ts, "additive")
v4.tsd <- decompose(v4.ts, "additive")
v5.tsd <- decompose(v5.ts, "additive")
v6.tsd <- decompose(v6.ts, "additive")
v7.tsd <- decompose(v7.ts, "additive")
v8.tsd <- decompose(v8.ts, "additive")
v9.tsd <- decompose(v9.ts, "additive")
v10.tsd <- decompose(v10.ts, "additive")
v11.tsd <- decompose(v11.ts, "additive")
v12.tsd <- decompose(v12.ts, "additive")
v13.tsd <- decompose(v13.ts, "additive")
v14.tsd <- decompose(v14.ts, "additive")
v15.tsd <- decompose(v15.ts, "additive")
v16.tsd <- decompose(v16.ts, "additive")
v17.tsd <- decompose(v17.ts, "additive")
v18.tsd <- decompose(v18.ts, "additive")
v19.tsd <- decompose(v19.ts, "additive")
v20.tsd <- decompose(v20.ts, "additive")
v21.tsd <- decompose(v21.ts, "additive")
v22.tsd <- decompose(v22.ts, "additive")
v23.tsd <- decompose(v23.ts, "additive")
v24.tsd <- decompose(v24.ts, "additive")
v25.tsd <- decompose(v25.ts, "additive")
v26.tsd <- decompose(v26.ts, "additive")
v27.tsd <- decompose(v27.ts, "additive")
v28.tsd <- decompose(v28.ts, "additive")
v29.tsd <- decompose(v29.ts, "additive")
v30.tsd <- decompose(v30.ts, "additive")
v31.tsd <- decompose(v31.ts, "additive")
v32.tsd <- decompose(v32.ts, "additive")
v33.tsd <- decompose(v33.ts, "additive")
v34.tsd <- decompose(v34.ts, "additive")
v35.tsd <- decompose(v35.ts, "additive")
v36.tsd <- decompose(v36.ts, "additive")
v37.tsd <- decompose(v37.ts, "additive")
v38.tsd <- decompose(v38.ts, "additive")
v39.tsd <- decompose(v39.ts, "additive")
v40.tsd <- decompose(v40.ts, "additive")
v41.tsd <- decompose(v41.ts, "additive")

#詞彙組自我相關顯著性檢定
Box.test(tdm3.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(tdm9.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(tdm10.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(tdm11.tsd$random[4:272], lag = 20, type = "Ljung-Box")

Box.test(v1.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v2.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v3.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v4.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v5.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v6.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v7.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v8.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v9.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v10.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v11.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v12.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v13.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v14.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v15.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v16.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v17.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v18.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v19.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v20.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v21.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v22.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v23.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v24.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v25.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v26.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v27.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v28.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v29.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v30.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v31.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v32.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v33.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v34.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v35.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v36.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v37.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v38.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v39.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v40.tsd$random[4:272], lag = 20, type = "Ljung-Box")
Box.test(v41.tsd$random[4:272], lag = 20, type = "Ljung-Box")

#交叉相關檢定
cor.test(clu71.tsd$random[3:231], clu72.tsd$random[3:231])

cor.test(log1.tsd$random[4:272], log2.tsd$random[4:272])
cor.test(log1.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(log1.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(log1.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(log1.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(log1.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(log2.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(log2.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(log2.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(log2.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(log2.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(log3.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(log3.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(log3.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(log3.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(log4.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(log4.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(log4.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(log5.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(log5.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(log6.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(log1.diff[1:274], log2.diff[1:274])
cor.test(log1.diff[1:274], log3.diff[1:274])
cor.test(log1.diff[1:274], log4.diff[1:274])
cor.test(log1.diff[1:274], log5.diff[1:274])
cor.test(log1.diff[1:274], log6.diff[1:274])
cor.test(log1.diff[1:274], log7.diff[1:274])

cor.test(log2.diff[1:274], log3.diff[1:274])
cor.test(log2.diff[1:274], log4.diff[1:274])
cor.test(log2.diff[1:274], log5.diff[1:274])
cor.test(log2.diff[1:274], log6.diff[1:274])
cor.test(log2.diff[1:274], log7.diff[1:274])

cor.test(log3.diff[1:274], log4.diff[1:274])
cor.test(log3.diff[1:274], log5.diff[1:274])
cor.test(log3.diff[1:274], log6.diff[1:274])
cor.test(log3.diff[1:274], log7.diff[1:274])

cor.test(log4.diff[1:274], log5.diff[1:274])
cor.test(log4.diff[1:274], log6.diff[1:274])
cor.test(log4.diff[1:274], log7.diff[1:274])

cor.test(log5.diff[1:274], log6.diff[1:274])
cor.test(log5.diff[1:274], log7.diff[1:274])

cor.test(log6.diff[1:274], log7.diff[1:274])


#詞彙組的交叉相關檢定
cor.test(tdm3.tsd$random[4:272], log1.tsd$random[4:272])
cor.test(tdm3.tsd$random[4:272], log2.tsd$random[4:272])
cor.test(tdm3.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(tdm3.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(tdm3.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(tdm3.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(tdm3.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(tdm9.tsd$random[4:272], log1.tsd$random[4:272])
cor.test(tdm9.tsd$random[4:272], log2.tsd$random[4:272])
cor.test(tdm9.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(tdm9.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(tdm9.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(tdm9.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(tdm9.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(v20.tsd$random[4:272], log1.tsd$random[4:272])
cor.test(v20.tsd$random[4:272], log2.tsd$random[4:272])
cor.test(v20.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(v20.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(v20.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(v20.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(v20.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(v6.tsd$random[4:272], log1.tsd$random[4:272])
cor.test(v6.tsd$random[4:272], log2.tsd$random[4:272])
cor.test(v6.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(v6.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(v6.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(v6.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(v6.tsd$random[4:272], log7.tsd$random[4:272])

cor.test(v31.tsd$random[4:272], log1.tsd$random[4:272])
cor.test(v31.tsd$random[4:272], log2.tsd$random[4:272])
cor.test(v31.tsd$random[4:272], log3.tsd$random[4:272])
cor.test(v31.tsd$random[4:272], log4.tsd$random[4:272])
cor.test(v31.tsd$random[4:272], log5.tsd$random[4:272])
cor.test(v31.tsd$random[4:272], log6.tsd$random[4:272])
cor.test(v31.tsd$random[4:272], log7.tsd$random[4:272])

#Bulmer's 檢定計算----------------------------------------------------
log1.r <- log1.tsd$random[4:272]
log2.r <- log2.tsd$random[4:272]
log3.r <- log3.tsd$random[4:272]
log4.r <- log4.tsd$random[4:272]
log5.r <- log5.tsd$random[4:272]
log6.r <- log6.tsd$random[4:272]
log7.r <- log7.tsd$random[4:272]

log1.r <- log1.tsd$random[4:272]
log2.r <- log2.tsd$random[4:272]
log3.r <- log3.tsd$random[4:272]
log4.r <- log4.tsd$random[4:272]
log5.r <- log5.tsd$random[4:272]
log6.r <- log6.tsd$random[4:272]
log7.r <- log7.tsd$random[4:272]

tdm3.r <- tdm3.tsd$random[4:272]
tdm9.r <- tdm9.tsd$random[4:272]
tdm10.r <- tdm10.tsd$random[4:272]
tdm11.r <- tdm11.tsd$random[4:272]

v.r <- v41.tsd$random[4:272]

obs <- length(v.r)
#calculate mean
data.mean <- mean(v.r)
#calculate square of n(t+1)-n(t)
U <- 0
for (n in 1:trunc(obs-1))
{U <- U+(v.r[n+1]-v.r[n])^2}

V <- 0
for (n in 1:trunc(obs))
{V <- V+(v.r[n]-mean(v.r))^2}

#calculate test statistic
test.stat <- V/U
cat("Bulmer's test statistic R =", test.stat)

#significance
RI <- 0.25+(obs-2)*0.0366
cat("For density dependence to be significant at 5% level R must be smaller than", RI)

#calculation on Bulmer's R*
W <- 0
for (n in 1:trunc(obs-2))
{W <- W+(v.r[n+2]-v.r[n+1])*(v.r[n]-mean(v.r))}
R.star <- W/V
cat("Bulmer's test statistic R* (used when measurement error is appreciable) = ", R.star)

#significance
R.star.05 <- (-13.7/obs)+(139/(obs^2))-(613/(obs^3))
cat("For density dependence to be significant at 5% level R* must be smaller than", R.star.05)
    

#-----------------------------------------------------------------
#計算沒有模因類種沒有主文產生的天數
days <- ifelse(clu77.ts>=11.74, 1, 0)
sum(days)
