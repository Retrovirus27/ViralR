# Function map4 to create a boxplot with ggplot

map4 <- function(fcs, gene, cell_type, study, virusgenome, virus_type, sample_group) {
  SP_m <- fcs[row.names(fcs) %in% gene,]
  
  # Filter the columns of SP_m using the provided criteria
  data_filtered <- filter_data_columns(SP_m, study, cell_type, virusgenome, virus_type, sample_group)
  
  # Reshape the data using the melt function from the reshape2 package
  data_melted <- reshape2::melt(data_filtered)
  
  # Create a ggplot boxplot with additional settings
  p <- ggplot(data_melted, aes(y = variable, x = value)) +
    geom_boxplot(outlier.shape = NA) +  # Remove outlier points from the boxplot
    geom_point(position = position_jitter(width = 0.5), size = 1) +
    labs(x = "Log2 FC", y = "") +
    theme(axis.text = element_text(color = "black", size = 12), panel.background = element_rect(fill = "white", colour = "black"))
  
  print(p)  # Print the ggplot boxplot
}