# Load required libraries
library(shiny)
library(shinyjs)
library(DT)

# Include shinyjs
useShinyjs()
source("scripts/Main.R")
# Assume you have these data and functions defined somewhere in your code
# virus, Pathways, data_annotation, sample_group, map1, map2, map3, map4, map5, map6

# Define UI for the Shiny application
ui <- navbarPage(
  theme = "css/bootstrap.css",
  title = span("Imuno-R", title = "Welcome to Inmuno-R"),
  tabPanel(
    title = span("Viral-R", title = "Are you ready to enjoy gene regulation by viruses?"),
    icon = tags$img(src = "virus.webp", height = 16, width = 16),
    fluidPage(
      sidebarLayout(
        sidebarPanel(width = 2,
                     selectInput("study", "Select Type of Study", choices = c("All", "Patients", "In Vitro"), selected = "All"),
                     selectInput("cell_type", "Select Cell Type", choices = c("All", "PBMCs", "Monocytes", "MDM"), selected = "All"),
                     selectInput("virus_genome", "Select Virus Genome", choices = c("All", "(+)RNA", "(-)RNA", "RT-RNA","DNA"), selected = "All"),
                     selectInput("virus_type", "Select Virus Type", choices = c("All", "SARS-CoV2","Arbovirus","AIV","OTHERS"), selected = "All"),
                     selectInput("Pathway", "Signaling Pathway:", choices = colnames(Pathways), selected = "CD44"),
                     conditionalPanel(
                       condition = "input.myTabs === 'Bipartite network analysis'",
                       sliderInput("fc", "Select Fold Change:", min = 0, max = 6, value = 0, step = 0.5)
                     ),
                     tags$div(style = "margin-bottom: 50px;"),
                     actionButton("generate", "RUN"),
                     HTML(rep('<br>', 30)),
                     style = "height: 700px;"
        ),
        mainPanel(
          tabsetPanel(id = "myTabs",  # Make sure to add an id attribute to tabsetPanel
                      tabPanel(title = span("Viral-R", title = "The homepage for Viral-R"),
                               icon = icon("house"),
                               div(h1(p(HTML("<span style='color:#4582ec;'><b>Welcome to Viral-R!</b></span>"))),
                                   hr(),
                                   div(
                                     class = "logoWrapper-home",
                                     p(HTML(
                                       " <ul style='font-size: 24px;'>
                             At Viral-R, you can track, detail, and download the results of transcriptome studies. 
                             The app now has over 30 unique transcriptomes that provide great resources 
                             for searching and analyzing gene expression data." )))),
                               p(HTML(
                                 "<ul style='font-size: 24px;'>
                       You can begin your exploration by selecting one of the tabs at the top of the page. Details on each tab are described below:
                       <ul style='font-size: 20px;'>
                       <li><em>Data base</em> provides information on transcriptome data information including status, study, cell type, virus characteristics, and accession number</li>
                       
                       <li><em>Differentially expressed genes</em> shows gene expression levels as a function of fold change, as well as a cluster dendrogram that can be adjusted using various filters</li>
                       
                       <li><em>Heatmap</em> this feature allows users to selectively examine gene expression across a variety of filters by targeting specific signaling pathways. It also includes a cluster tree diagram that can be customized using filters</li>
                       
                       <li><em>Box plot</em> show a box plot with the weighted expression of the genes under different filters</li>
                       
                       <li><em>Bipartite network analysis</em> show the common and uncommon genes regulated under 
                       different conditions. Also, it shows the upregulated and downregulated genes</li>
                       
                       </ul>"
                               )),
                               
                               p(HTML(
                                 "Viral-R was created by Yordi Tamayo & Juan Felipe Valdez 
                       from the <a href='https://bit.ly/3S0Sxk8'> GIV </a> at the University of Antioquia  & <a href='https://umcgresearch.org/w/experimental-virology'> EGV </a>
                       at the University of Groningen."
                               )),),
                      tabPanel(title = span("Data Base", title = "Browse and search the entire database of viral-R"),
                               icon = icon("database"),
                               DT::dataTableOutput("mytable")),
                      tabPanel(title = span("Differentially expressed genes", title = "Number of the DEGs and clustering them by conditions"),
                               icon = icon("chart-bar"),
                               column(4, plotOutput(outputId = "barplots", height = "500px", width = "1200px")),
                               column(12, plotOutput(outputId = "tree", height = "500px", width = "1200px"))),
                      tabPanel(title = span("Heatmap", title = "Find the DEGs by signaling pathways"),
                               icon = icon("table"),
                               plotOutput(outputId = "heatmap", height = "800px", width = "1200px")),
                      tabPanel(title = span("Box plot", title = "Quantify the level of activation by signaling pathway"),
                               icon = icon("box"),
                               plotOutput(outputId = "scatterplots", height = "800px", width = "1200px")),
                      tabPanel(title = span("Bipartite network analysis", title = "Find the common and uncommon genes by conditions"),
                               icon = icon("network-wired"),
                               fluidRow(column(4, plotOutput(outputId = "network1", height = "600px", width = "1200px")),
                                        column(12, plotOutput(outputId = "network2", height = "600px", width = "1200px")))
                      ),
                      tabPanel(title = span("Information", title = ""),
                               icon = icon("house"),
                               div(h1(p(HTML("<span style='color:#4582ec;'><b>Welcome to Viral-R!</b></span>"))),
                                   hr(),
                                   div(
                                     class = "logoWrapper-home",
                                     p(HTML(
                                       " <ul style='font-size: 24px;'>
                             At Viral-R, you can track, detail, and download the results of transcriptome studies. 
                             The app now has over 30 unique transcriptomes that provide great resources 
                             for searching and analyzing gene expression data." )))),
                               p(HTML(
                                 "<ul style='font-size: 24px;'>
                       You can begin your exploration by selecting one of the tabs at the top of the page. Details on each tab are described below:
                       <ul style='font-size: 20px;'>
                       <li><em>Data base</em> provides information on transcriptome data information including status, study, cell type, virus characteristics, and accession number</li>
                       
                       <li><em>Differentially expressed genes</em> shows gene expression levels as a function of fold change, as well as a cluster dendrogram that can be adjusted using various filters</li>
                       
                       <li><em>Heatmap</em> allows users to select specific signaling pathways to observe the expression 
                       of genes under different filters</li>
                       
                       <li><em>Box plot</em> show a box plot with the weighted expression of the genes under different filters</li>
                       
                       <li><em>Bipartite network analysis</em> show the common and uncommon genes regulated under 
                       different conditions. Also, it shows the upregulated and downregulated genes</li>
                       
                       </ul>"
                               )),
                               
                               p(HTML(
                                 "Viral-R was created by Yordi Tamayo & Juan Felipe Valdez 
                       from the <a href='https://bit.ly/3S0Sxk8'> GIV </a> at the University of Antioquia  & <a href='https://umcgresearch.org/w/experimental-virology'> EGV </a>
                       at the University of Groningen."
                               )),)
          )
        )
      ),
      fluidRow(
        column(3, img(src = "university_logo4.png", width = 150, height = 100)),
        column(3, img(src = "university_logo3.png", width = 220, height = 100)),
        column(3, img(src = "university_logo1.png", width = 220, height = 100)),
        column(3, img(src = "university_logo2.png", width = 220, height = 100))
      )
    )
  )
)


# Define server logic required for the Shiny application
server <- function(input, output) {
  source("scripts/Filter_row_virus.R")
  source("scripts/Filter_col_virus.R")
  
  observe({
    # Update the shinyjs variable when the tab is changed
    shinyjs::jsCode("shinyjs('myTabs', $($('.navbar-nav li.active a').attr('href')).attr('id'))")
  })
  
  # Generate the heatmap and other plots when the "RUN" button is clicked
  observeEvent(input$generate, {
    output$mytable <- DT::renderDataTable(data_annotation, rownames = FALSE, options = list(pageLength = -1))
    source("scripts/DEGs.R")
    output$barplots <- renderPlot({
      map1(virus, input$cell_type, input$study, input$virus_genome, input$fc, input$virus_type, sample_group)
    })
    source("scripts/Cluster.R")
    output$tree <- renderPlot({
      map2(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, sample_group)
    })
    source("scripts/Heatmap.R")
    output$heatmap <- renderPlot({
      map3(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, sample_group)
    })
    source("scripts/Boxplot.R")
    output$scatterplots <- renderPlot({
      map4(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, sample_group)
    })
    source("scripts/Sankey.R")
    output$network1 <- renderPlot({
      map5(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, input$fc, sample_group)
    })
    source("scripts/GeneRegulation.R")
    output$network2 <- renderPlot({
      map6(virus, Pathways[, input$Pathway], input$cell_type, input$study, input$virus_genome, input$virus_type, input$fc, sample_group)
    })
  })
}

# Run the Shiny application
shinyApp(ui = ui, server = server)
