message(paste0("\n\n=========== InmunoR Start ============\n"))
source("scripts/Main.R")

# Define UI for the Shiny application
ui <- navbarPage(
  # Select the Bootswatch3 theme "Readable": https://bootswatch.com/3/readable
  theme = "css/bootstrap.css",
  
  title = "Inmuno-R",
  tabPanel(
    "Viral-R", icon = tags$img(src = "virus.webp", height = 16, width = 16),
    fluidPage(
      sidebarLayout(
        sidebarPanel(width = 2,
          # Select input elements for study, cell type, virus genome, virus type, pathway, fold change, and action button
          selectInput("study", "Select Type of Study", choices = c("All", "Patients", "In Vitro"), selected = "All"),
          selectInput("cell_type", "Select Cell Type", choices = c("All", "PBMCs", "Monocytes", "MDM"), selected = "All"),
          selectInput("virus_genome", "Select Virus Genome", choices = c("All", "(+)RNA", "(-)RNA", "RT-RNA","DNA"), selected = "All"),
          selectInput("virus_type", "Select Virus Type", choices = c("All", "SARS-CoV2","DENV","ZIKV","AIV","CHIKV","OTHERS"), selected = "All"),
          selectInput("Pathway", "Signaling Pathway:", choices = colnames(Pathways), selected = "CD44"),
          sliderInput("fc", "Select Fold Change:", min = 0, max = 6, value = 0, step = 0.5),
          tags$div(style = "margin-bottom: 50px;"),  # Add bottom margin
          actionButton("generate", "RUN"),
          HTML(rep('<br>', 30)),  # Add line breaks
          style = "height: 700px;"  # Set sidebar height
        ),
        mainPanel(tabsetPanel(tabPanel("Data Base", DT::dataTableOutput("mytable")),
                              tabPanel("Differentially expressed genes", 
                                       column(4, plotOutput(outputId = "barplots", height = "500px", width = "1200px")),
                                       column(12, plotOutput(outputId = "tree", height = "500px", width = "1200px"))),
                              tabPanel("Heatmap", plotOutput(outputId = "heatmap", height = "800px", width = "1200px")),
                              tabPanel("Box Plot", plotOutput(outputId = "scatterplots", height = "800px", width = "1200px")),
                              tabPanel("Bipartite network analysis", 
                                       fluidRow(column(4, plotOutput(outputId = "network1", height = "600px", width = "1200px")),
                                                column(12, plotOutput(outputId = "network2", height = "600px", width = "1200px")))
            )
          )
        )
      ),
      fluidRow(column(3, img(src = "university_logo4.png", width = 150, height = 100)),
               column(3, img(src = "university_logo3.png", width = 220, height = 100)),
               column(3, img(src = "university_logo1.png", width = 220, height = 100)),
               column(3, img(src = "university_logo2.png", width = 220, height = 100)))
    )
  )
)


# Define server logic required for the Shiny application
server <- function(input, output) {
  source("scripts/Filter_row_virus.R")
  source("scripts/Filter_col_virus.R")
  # Generate the heatmap and other plots when the "RUN" button is clicked
  observeEvent(input$generate, {
    # Render the data table based on the "data_annotation" data frame
    output$mytable <- DT::renderDataTable(data_annotation, rownames = FALSE, options = list(pageLength = -1))
    # Render a barplot using the map1 function
    source("scripts/DEGs.R")
    output$barplots <- renderPlot({
      map1(virus, input$cell_type, input$study, input$virus_genome, input$fc, input$virus_type, sample_group)
    })
    # Render a tree plot using the map2 function
    source("scripts/Cluster.R")
    output$tree <- renderPlot({
      map2(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, sample_group)
    })
    # Render a heatmap plot using the map3 function
    source("scripts/Heatmap.R")
    output$heatmap <- renderPlot({
      map3(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, sample_group)
    })
    # Render a box plot using the map4 function
    source("scripts/Boxplot.R")
    output$scatterplots <- renderPlot({
      map4(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, sample_group)
    })
    # Render the first network plot using the map5 function
    source("scripts/Sankey.R")
    output$network1 <- renderPlot({
      map5(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, input$fc, sample_group)
    })
    # Render the second network plot using the map6 function
    source("scripts/GeneRegulation.R")
    output$network2 <- renderPlot({
      map6(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, input$fc, sample_group)
    })
  })
}

# Run the Shiny application
shinyApp(ui = ui, server = server)