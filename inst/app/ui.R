## ui.R ##

dashboardPage(
  dashboardHeader(title = "Stockradar"),
  dashboardSidebar(
    sidebarSearchForm("searchText","searchButton"),
    selectInput("src","Select Source",
                c("yahoo","google",
                  "FRED","oanda"),
                selected = "yahoo"),
    selectInput("metric","Select Metric",
                c(".Close",".Open"),
                selected = ".Close"),
    dateInput("start_date","Select Start Date",
              "2015-01-01"),
    dateInput("end_date","Select End Date",
              Sys.Date()),
    checkboxInput("idx","Create Index",value = T),
    sliderInput("roll_window","Mov. Avg Window",
                min = 5, max = 50, value = 10)),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet",
                type = "text/css", href = "custom.css")),
    tabItem(tabName = "home",
            fluidRow(
              box(title = "Stock Comparison", 
                  dygraphOutput("stockchart"),
                  width = 12)
            )
    )
  )
)
