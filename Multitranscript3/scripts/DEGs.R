# DEGs (Differentially Expressed Genes)

# Function map1 to create a plot of DEGs
map1 <- function(fcs, cell_type, study, virusgenome, FC, virus_type, sample_group) {
  # Convert FC to numeric and study2 to a factor, relevel it to "Patients"
  FC <- as.numeric(FC)
  study2 <- as.factor(sample_group$Study)
  study2 <- relevel(study2, "Patients")
  
  # Count genes regulated positively (>0) and negatively (<0) in each column.
  genes_positives <- apply(fcs > FC, 2, sum)
  genes_negatives <- apply(fcs < -FC, 2, sum)
  
  # Suppose you have the results in the genes_positives and genes_negatives vectors.
  conditions <- colnames(fcs) # Get the column names
  
  # Create a data frame with the necessary data
  data <- data.frame(
    Conditions = factor(conditions, levels = conditions), # Preserve the original order
    PositiveGenes = genes_positives,
    NegativeGenes = genes_negatives,
    Study = study2
  )
  
  # Call the function with the desired values
  data_filtered <- filter_data_rows(data, study, cell_type, virusgenome, virus_type, sample_group)
  
  # Create a ggplot for visualization
  p <- ggplot(na.omit(data_filtered), aes(x = Conditions)) +
    geom_bar(aes(y = PositiveGenes, fill = "Positive Genes"), stat = "identity") +
    geom_bar(aes(y = -NegativeGenes, fill = "Negative Genes"), stat = "identity") +
    labs(y = "Number of genes",
         fill = "Gene Type") +
    scale_fill_manual(values = c("Positive Genes" = "firebrick3", "Negative Genes" = "navy")) +
    scale_y_continuous(breaks = seq(-4000, 4000, by = 500)) +  # Set breaks at every 500
    theme(axis.text.x = element_text(angle = 90, hjust = 1) ) +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme(axis.text = element_text(color = "black", size = 12), panel.background = element_rect(fill = "white", colour = "black"))+
    theme(axis.title.x = element_blank())+ # Remove the x-axis legend
    facet_grid(.~Study, scales = "free_x")
  
  return(p) # Return the ggplot object
}