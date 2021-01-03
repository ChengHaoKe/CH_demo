library(shiny)
library(shinyjs)
library(DBI)
library(rJava)
library(RJDBC)
library(car)
library(lubridate)
library(scales)
library(ggplot2)
library(plotly)
library(DT)
library(data.table)
library(tidyverse)
# Settings
options("scipen"=100, "digits"=4)
options(shiny.trace=TRUE, shiny.error = TRUE)

# ui.R ------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  shinyjs::useShinyjs(),
  titlePanel(title = 
               div(img(src = "https://avatars0.githubusercontent.com/u/41141849?s=460&u=608357d2be147131b28f4e3ce8dbd8433e878c65&v=4", 
                             height='5%',width='5%'))),
  navbarPage("CH's R Shiny Demo",
             tabPanel('Visualizations',
                      pageWithSidebar(
                        headerPanel("Data Visualization Tool"),
                        sidebarPanel(
                          helpText("Choose a dataset, then click the button to start!"),
                          h5("Choose a dataset:"),
                          radioButtons('select1', label = h5("Please select a dataset"),
                                       c(Titanic = 'Titanic', `NYS schools` = 'NYS schools'), 'Titanic'),
                          br(),
                          actionButton("sub1", "Submit", icon("refresh"), style = "color: #00FFFF; background-color:
                                       #337ab7; border-color: #2e6da4"),
                          br(), br(),
                          wellPanel(
                            helpText("If the application is stuck, please refresh the page.")
                          )
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Inbuilt datasets",
                                     verticalLayout(h5("Data Set Selection"),
                                                    verbatimTextOutput("ds1", placeholder = TRUE),
                                                    br(),
                                                    h5("Interactive Plot"),
                                                    selectInput("ptype1", label = h5("Select Plot Type"),
                                                                choices = list("Bar Plot", 'Pie Chart')),
                                                    br(),
                                                    plotlyOutput("oplot1", width = "100%", height = "500px"),
                                                    br(),
                                                    DT::dataTableOutput("plotdata"),
                                                    br()
                                     )),
                            tabPanel("Custom datasets",
                                     verticalLayout(h5("Under Construction!"),
                                                    verbatimTextOutput("ds2", placeholder = TRUE),
                                                    br(),
                                                    helpText("Under Construction!")
                                     ))
                          )
                          
                        )
                        
                      )
             ),
             tabPanel('Analysis',
                      pageWithSidebar(
                        headerPanel("Statistical Analysis Tool"),
                        sidebarPanel(
                          helpText("Choose a dataset, then click the button to start!"),
                          h5("Choose a dataset:"),
                          radioButtons('select2', label = h5("Please select a dataset"),
                                       c(Titanic = 'Titanic', `NYS schools` = 'NYS schools'), 'Titanic'),
                          br(),
                          actionButton("sub2", "Submit", icon("refresh"), style = "color: #00FFFF; background-color:
                                       #337ab7; border-color: #2e6da4"),
                          br(), br(),
                          wellPanel(
                            helpText("If the application is stuck, please refresh the page.")
                          )
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Bivariate Analysis",
                                     verticalLayout(h5("Data Set Selection"),
                                                    verbatimTextOutput("ds11", placeholder = TRUE),
                                                    br(),
                                                    selectInput("biv1", label = "Select tests to run",
                                                                choices = list("Tests")),
                                                    br(),
                                                    tableOutput('ttest')
                                     )),
                            tabPanel("Multivariate Analysis",
                                     verticalLayout(h5("Under Construction!"),
                                                    verbatimTextOutput("ds21", placeholder = TRUE),
                                                    br(),
                                                    helpText("Under Construction!")
                                     ))
                          )
                        )
                      )
             )
  )
)

# server.R ------------------------------------------------------------------------------------------------------------
server <- function(input, output, session) {
  #-----------------------------------------Outputs--------------------------------------------------------------------
  # Query choice ----------------------------------------------------------
  
  output$ds1 <- renderText({
    if (input$select1 == 'Titanic') {
      paste('Titanic')
    } else if (input$select1 == 'NYS schools') {
      paste('NYS schools')
    }
  })
  
  output$ds11 <- renderText({
    if (input$select2 == 'Titanic') {
      paste('Titanic')
    } else if (input$select2 == 'NYS schools') {
      paste('NYS schools')
    }
  })
  
  # ---------- Selection dynamic updates ---------------------------------
  # https://shiny.rstudio.com/reference/shiny/latest/updateSelectInput.html
  observe({
    if (input$select2 == 'Titanic') {
      choice0 <- c('Independent t-test', 'One-way analysis of variance (ANOVA)')
      updateSelectInput(session, "biv1",
                        label = "Select tests to run",
                        choices = choice0,
                        selected = head(choice0, 1)
      )
    } else if (input$select2 == 'NYS schools') {
      choice0 <- c('One-way analysis of variance (ANOVA)', 'Pearson correlation test')
      updateSelectInput(session, "biv1",
                        label = "Select tests to run",
                        choices = choice0,
                        selected = head(choice0, 1)
      )
    }
  })
  
  #--------------data functions ---------------------------------------------
  data0 <- eventReactive(input$sub1, {
    if (input$select1 == 'Titanic') {
      df0 <- read_csv("train.csv")
    } else if (input$select1 == 'NYS schools') {
      # replace -99 with NA
      school1 <- read_csv("nys_schools.csv")
      school1[school1 == -99 |school1 == '-99'] <- NA
      # remove rows that have wrong lunch data (percentage should be lower than 1)
      school1 <- school1[(school1$per_free_lunch < 1) & (school1$per_reduced_lunch < 1),]
      county1 <- read_csv("nys_acs.csv")
      county1[county1 == -99 |county1 == '-99'] <- NA
      
      school2 <- school1 %>% group_by(year) %>% 
        mutate(zmath = scale(mean_math_score), zeng = scale(mean_ela_score)) %>%
        ungroup(year)
      
      # group by county
      county2 <- county1 %>% group_by(county_name) %>% 
        summarize(county_per_poverty = mean(county_per_poverty, na.rm = TRUE),
                  median_household_income = mean(median_household_income, na.rm = TRUE),
                  county_per_bach = mean(county_per_bach, na.rm = TRUE))
      
      q3 <- quantile(county2$county_per_poverty, probs = c(0, 1/3, 2/3))
      q3 <- append(q3, 1)
      county2$povlvl <- cut(county2$county_per_poverty, breaks = q3, 
                            labels = c('low', 'medium', 'high'),
                            include.lowest = TRUE, right = FALSE)
      county2 <- as.data.table(county2)
      county3 <- merge(county1, county2[, c('county_name', 'povlvl')], 
                       by.x = 'county_name', all.x = TRUE)
      
      school3 <- school2 %>% group_by(county_name, year) %>%
        summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
      
      
      # inner join both data
      df0 <- merge(county3, school3, by = c("county_name", 'year'), 
                   all = FALSE, all.x = FALSE, all.y = FALSE)
    }
    df0
  })
  
  # data 1
  data1 <- eventReactive(input$sub2, {
    if (input$select2 == 'Titanic') {
      df0 <- read_csv("train.csv")
    } else if (input$select2 == 'NYS schools') {
      # replace -99 with NA
      school1 <- read_csv("nys_schools.csv")
      school1[school1 == -99 |school1 == '-99'] <- NA
      # remove rows that have wrong lunch data (percentage should be lower than 1)
      school1 <- school1[(school1$per_free_lunch < 1) & (school1$per_reduced_lunch < 1),]
      county1 <- read_csv("nys_acs.csv")
      county1[county1 == -99 |county1 == '-99'] <- NA
      
      school2 <- school1 %>% group_by(year) %>% 
        mutate(zmath = scale(mean_math_score), zeng = scale(mean_ela_score)) %>%
        ungroup(year)
      
      # group by county
      county2 <- county1 %>% group_by(county_name) %>% 
        summarize(county_per_poverty = mean(county_per_poverty, na.rm = TRUE),
                  median_household_income = mean(median_household_income, na.rm = TRUE),
                  county_per_bach = mean(county_per_bach, na.rm = TRUE))
      
      q3 <- quantile(county2$county_per_poverty, probs = c(0, 1/3, 2/3))
      q3 <- append(q3, 1)
      county2$povlvl <- cut(county2$county_per_poverty, breaks = q3, 
                            labels = c('low', 'medium', 'high'),
                            include.lowest = TRUE, right = FALSE)
      county2 <- as.data.table(county2)
      county3 <- merge(county1, county2[, c('county_name', 'povlvl')], 
                       by.x = 'county_name', all.x = TRUE)
      
      school3 <- school2 %>% group_by(county_name, year) %>%
        summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
      
      
      # inner join both data
      df0 <- merge(county3, school3, by = c("county_name", 'year'), 
                   all = FALSE, all.x = FALSE, all.y = FALSE)
    }
    df0
  })
  
  #--------------------------------Barchart-------------------------------------------------
  bardata <- reactive({
    df1 <- data0()
    
    if (input$select1 == 'Titanic') {
      df2 <- df1 %>% group_by(Pclass, Survived) %>% summarize(Passengers = n())
      df2 <- as.data.table(df2)
      df3 <- dcast.data.table(df2, Pclass ~ Survived, value.var = 'Passengers', 
                              fun.aggregate = sum)
      colnames(df3) <- c('Pclass', 'Died', 'Survived')
      
    } else if (input$select1 == 'NYS schools') {
      df2 <- as.data.table(df1)
      df3 <- dcast.data.table(df2, county_name ~ year, value.var = 'total_enroll', 
                              fun.aggregate = sum)
      colnames(df3) <- c(c('county_name'), 
                         paste("y", colnames(df3)[2:ncol(df3)], sep = "_"))
    }
    df3
  })
  
  fbar1 <- reactive({
    df3 <- as.data.table(bardata())
    
    if (input$select1 == 'Titanic') {
      # df2 <- df1 %>% group_by(Pclass, Survived) %>% summarize(Passengers = n())
      # df2 <- as.data.table(df2)
      # df3 <- dcast.data.table(df2, Pclass ~ Survived, value.var = 'Passengers', 
      #                         fun.aggregate = sum)
      # colnames(df3) <- c('Pclass', 'Died', 'Survived')
      
      bar1 <- plot_ly()
      for (t in colnames(df3[,2:ncol(df3)])){
        bar1 <- bar1 %>% 
          add_trace(data = df3, x = ~Pclass, y = as.formula(paste0("~", t)),
                    name = t, type = "bar")
      }
      bar1 %>% 
        plotly::layout(title = list(text = "Survival by class", size = 22),
               xaxis = list(title = "Passenger Class", 
                            titlefont = list(size = 16)),
               yaxis = list(title = "Number of passengers", 
                            titlefont = list(size = 16)),
               margin = list(l = 100, r = 100, b = 100, t = 100),
               legend = list(orientation = "v", x = 1, xanchor = "left", y = 1),
               barmode = 'group')
      
    } else if (input$select1 == 'NYS schools') {
      # df2 <- as.data.table(df1)
      # df3 <- dcast.data.table(df2, county_name ~ year, value.var = 'total_enroll', 
      #                         fun.aggregate = sum)
      # colnames(df3) <- c(c('county_name'), 
      #                    paste("y", colnames(df3)[2:ncol(df3)], sep = "_"))
      
      bar1 <- plot_ly()
      for (t in colnames(df3[,2:ncol(df3)])){
        bar1 <- bar1 %>% 
          add_trace(data = df3, x = ~county_name, y = as.formula(paste0("~", t)),
                    name = t, type = "bar")
      }
      bar1 %>% 
        plotly::layout(title = list(text = "Total Enrollment by year by county", size = 22),
               xaxis = list(title = "County", 
                            titlefont = list(size = 16)),
               yaxis = list(title = "Total Enrollment", 
                            titlefont = list(size = 16)),
               margin = list(l = 100, r = 100, b = 100, t = 100),
               legend = list(orientation = "v", x = 1, xanchor = "left", y = 1),
               barmode = 'stack')
    }
    #bar1
  })
  
  #------------------------------Pie Chart----------------------------------------------
  piedata <- reactive({
    df1 <- data0()
    
    if (input$select1 == 'Titanic') {
      df2 <- df1 %>% group_by(Pclass, Survived) %>% summarize(Passengers = n())
      df2 <- as.data.table(df2)
      df3 <- dcast.data.table(df2, Pclass ~ Survived, value.var = 'Passengers', 
                              fun.aggregate = sum)
      colnames(df3) <- c('Pclass', 'Died', 'Survived')
      
    } else if (input$select1 == 'NYS schools') {
      df2 <- df1 %>% group_by(povlvl) %>% summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
      df2 <- as.data.table(df2)
      df4 <- df1 %>% group_by(year) %>% summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
      df4 <- as.data.table(df4)
      df2$group <- 'povlvl'
      df4$group <- 'year'
      
      df3 <- rbind(df2, df4, fill=TRUE)
    }
    df3
  })
  
  
  fpie1 <- reactive({
    df3 <- as.data.table(piedata())
    
    if (input$select1 == 'Titanic') {
      # df2 <- df1 %>% group_by(Pclass, Survived) %>% summarize(Passengers = n())
      # df2 <- as.data.table(df2)
      # df3 <- dcast.data.table(df2, Pclass ~ Survived, value.var = 'Passengers', 
      #                         fun.aggregate = sum)
      # colnames(df3) <- c('Pclass', 'Died', 'Survived')
      
      # pie1 <- plot_ly(df3, labels = ~Pclass, values = ~Died, type = 'pie',
      #                 textposition = 'inside',
      #                 textinfo = 'label+percent',
      #                 insidetextfont = list(color = '#FFFFFF'),
      #                 hoverinfo = 'text',
      #                 text = ~paste(Pclass, ':', Died, '(Passengers)'),
      #                 marker = list(line = list(color = '#FFFFFF', width = 1)),
      #                 showlegend = FALSE) %>%
      #   plotly::layout(title = 'Died passengers by class',
      #          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          margin = list(l = 100, r = 100, b = 100, t = 100))
      # 
      # pie2 <- plot_ly(df3, labels = ~Pclass, values = ~Survived, type = 'pie',
      #                 textposition = 'inside',
      #                 textinfo = 'label+percent',
      #                 insidetextfont = list(color = '#FFFFFF'),
      #                 hoverinfo = 'text',
      #                 text = ~paste(Pclass, ':', Survived, '(Passengers)'),
      #                 marker = list(line = list(color = '#FFFFFF', width = 1)),
      #                 showlegend = FALSE) %>%
      #   plotly::layout(title = 'Survived passengers by class',
      #          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          margin = list(l = 100, r = 100, b = 100, t = 100))
      # pies <- plotly::subplot(list(pie1, pie2), nrows = 1)
      pie0 <- plot_ly()
      pie0 <- pie0 %>% add_pie(data = df3, labels = ~Pclass, values = ~Died,
                               name = "Passengers", domain = list(row = 0, column = 0),
                               title = list(text = 'Died passengers by class', size = 22))
      pie0 <- pie0 %>% add_pie(data = df3, labels = ~Pclass, values = ~Survived,
                               name = "Passengers", domain = list(row = 0, column = 1),
                               title = list(text = 'Survived passengers by class', size = 22))
      pie0 <- pie0 %>% layout(title = 'Pie charts of passenger status by class', showlegend = F,
                              grid=list(rows=1, columns=2),
                              xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                              margin = list(l = 100, r = 100, b = 100, t = 100))
      
    } else if (input$select1 == 'NYS schools') {
      # df2 <- df1 %>% group_by(povlvl) %>% summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
      # df2 <- as.data.table(df2)
      # df3 <- df1 %>% group_by(year) %>% summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
      # df3 <- as.data.table(df3)
      df2 <- df3[df3$group == 'povlvl']
      df4 <- df3[df3$group == 'year']
      
      # pie1 <- plot_ly(df2, labels = ~povlvl, values = ~total_enroll, type = 'pie',
      #                 textposition = 'inside',
      #                 textinfo = 'label+percent',
      #                 insidetextfont = list(color = '#FFFFFF'),
      #                 hoverinfo = 'text',
      #                 text = ~paste(povlvl, ':', total_enroll, '(Enrollment)'),
      #                 marker = list(line = list(color = '#FFFFFF', width = 1)),
      #                 showlegend = FALSE) %>%
      #   plotly::layout(title = 'Enrollment by county poverty level',
      #          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          margin = list(l = 100, r = 100, b = 100, t = 100))
      # 
      # pie2 <- plot_ly(df3, labels = ~year, values = ~total_enroll, type = 'pie',
      #                 textposition = 'inside',
      #                 textinfo = 'label+percent',
      #                 insidetextfont = list(color = '#FFFFFF'),
      #                 hoverinfo = 'text',
      #                 text = ~paste(year, ':', total_enroll, '(Enrollment)'),
      #                 marker = list(line = list(color = '#FFFFFF', width = 1)),
      #                 showlegend = FALSE) %>%
      #   plotly::layout(title = 'Enrollment by year',
      #          xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
      #          margin = list(l = 100, r = 100, b = 100, t = 100))
      
      pie0 <- plot_ly()
      pie0 <- pie0 %>% add_pie(data = df2, labels = ~povlvl, values = ~total_enroll,
                             name = "Enrollment", domain = list(row = 0, column = 0),
                             title = list(text = 'Enrollment by county poverty level', size = 22))
      pie0 <- pie0 %>% add_pie(data = df4, labels = ~year, values = ~total_enroll,
                             name = "Enrollment", domain = list(row = 0, column = 1),
                             title = list(text = 'Enrollment by year', size = 22))
      pie0 <- pie0 %>% layout(title = 'Pie charts of enrollment numbers', showlegend = F,
                            grid=list(rows=1, columns=2),
                            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            margin = list(l = 100, r = 100, b = 100, t = 100))
    }
    
    # pies <- plotly::subplot(list(pie1, pie2), nrows = 1)
  })
  
  #output according to select input-----------------------------------------------------
    fplot1 <- reactive({
      tryCatch({
      if ("Bar Plot" %in% input$ptype1) return(fbar1())
      if ("Pie Chart" %in% input$ptype1) return(fpie1())
      }, error = function(e){
        placeh <- plotly_empty(type = "scatter", mode = "markers") %>%
          config(displayModeBar = FALSE) %>%
          plotly::layout(title = 
                   list(text = paste("Whenever you select a different dataset,",
                                     "please click the submit button again to", 
                                     "render the results!"), 
                        yref = "paper", y = 0.5))
        return(placeh)
      })
    })
  
  output$oplot1 <- renderPlotly(withProgress(message = 'Rendering Plot', 
                                              value = 0.5, {df4 = fplot1()
                                              }))
  
  output$plotdata <- DT::renderDataTable(
    tryCatch({
      if ("Bar Plot" %in% input$ptype1) {
        datatable(bardata(), options = list(pageLength = 5), extensions = 'Responsive')
        } else if ("Pie Chart" %in% input$ptype1) {
        datatable(piedata(), options = list(pageLength = 5), extensions = 'Responsive')
      }
    }, error = function(e){
      stat1 <- data.frame(message = paste("Whenever you select a different dataset,",
                                          "please click the submit button again to", 
                                          "render the results!"))
      datatable(stat1, options = list(pageLength = 5), extensions = 'Responsive')
    })
  )
  
  
  
  # ====================== Statistical analysis ========================================
  fbiv <- reactive({
    tryCatch({
      df1 <- as.data.table(data1())
      
      if (input$select2 == 'Titanic') {
        if (input$biv1 == 'Independent t-test') {
          df1 <- na.omit(df1[, c('Survived', 'Age')])
          lv0 <- leveneTest(df1$Age, factor(df1$Survived))
          if (lv0$`Pr(>F)`[1] < 0.05) {
            t.test(df1$Age ~ factor(df1$Survived), var.equal = FALSE)
          } else {
            tt0 <- t.test(df1$Age ~ factor(df1$Survived), var.equal = TRUE)
          }
          lvdf <- data.frame(variables = "Survival and Age",
                             test = "Levene's test for homogeneity of variance", 
                             statistic = lv0$`F value`[1], pvalue = lv0$`Pr(>F)`[1])
          ttdf <- data.frame(variables = "",
                             test = "Independent t-test",
                             statistic = tt0$statistic, 
                             pvalue = tt0$p.value)
          stat1 <- rbind(lvdf, ttdf)
          
        } else if (input$biv1 == 'One-way analysis of variance (ANOVA)') {
          df1 <- na.omit(df1[, c('Pclass', 'Age')])
          an0 <- aov(Age ~ Pclass, data = df1)
          an1 <- summary(an0)
          stat1 <- data.frame(an1[[1]])
          befcol <- colnames(stat1)
          stat1$variables <- c('Passenger class and age', '')
          stat1 <- stat1[, c('variables', befcol)]
        }
        
      } else if (input$select2 == 'NYS schools') {
        if (input$biv1 == 'One-way analysis of variance (ANOVA)') {
          df2 <- df1 %>% group_by(county_name, povlvl) %>% 
            summarize(total_enroll = sum(total_enroll, na.rm = TRUE))
          df2 <- as.data.table(df2)
          an0 <- aov(total_enroll ~ povlvl, data = df2)
          an1 <- summary(an0)
          stat1 <- data.frame(an1[[1]])
          befcol <- colnames(stat1)
          stat1$variables <- c('Total enrollment and county poverty level', '')
          stat1 <- stat1[, c('variables', befcol)]
          
        } else if (input$biv1 == 'Pearson correlation test') {
          df2 <- df1 %>% group_by(county_name) %>% 
            summarize(total_enroll = sum(total_enroll, na.rm = TRUE),
                      median_household_income = mean(median_household_income, na.rm = TRUE))
          df2 <- as.data.table(df2)
          cor0 <- cor.test(df2$total_enroll, df2$median_household_income, method = "pearson")
          stat1 <- data.frame(variables = "Total enrollment and average median household income across years",
                              statistic = cor0$estimate, pvalue = cor0$p.value)
        }
        
      }
      
      return(stat1)
      
    }, error = function(e){
      stat1 <- data.frame(message = paste("Whenever you select a different dataset,",
                                          "please click the submit button again to", 
                                          "render the results!"))
      return(stat1)
    })
  })
  
  output$ttest <- renderTable({
    withProgress(message = 'Rendering Plot', 
                 value = 0.5, {stat1 <- fbiv()})
  })
  
}

# run ------------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)