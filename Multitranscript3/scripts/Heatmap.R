# Function map3 to create a heatmap with annotations

map3 <- function(fcs, gene, cell_type, study, virusgenome, virus_type, sample_group) {
  SP_m <- fcs[row.names(fcs) %in% gene,]
  
  # Set row names of sample_group to match column names of SP_m
  row.names(sample_group) <- colnames(SP_m)
  
  # Filter the columns of SP_m using the provided criteria
  data_filtered <- filter_data_columns(SP_m, study, cell_type, virusgenome, virus_type, sample_group)
  
  # Calculate the maximum absolute value for color scaling
  rg <- max(abs(data_filtered))
  
  # Create a heatmap using pheatmap with additional settings
  pheatmap(na.omit(data_filtered),
           annotation_col = sample_group,
           color = colorRampPalette(c("navy", "white", "firebrick3"))(100),
           breaks = seq(-rg, rg, length.out = 100),
           fontsize_col = 12,
           cluster_row = FALSE,
           show_rownames = TRUE,
           show_colnames = TRUE,
           cluster_cols = TRUE,
           clustering_method = "ward.D2",
           border_color = "black",
           scale = "none",
           angle_col = 90)
}