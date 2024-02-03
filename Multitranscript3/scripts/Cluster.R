# Function map2 to create a heatmap using pheatmap

map2 <- function(fcs, gene, cell_type, study, virusgenome, virus_type, sample_group) {
  SP_m <- fcs
  
  # Set row names of sample_group to match column names of SP_m
  row.names(sample_group) <- colnames(SP_m)
  
  # Filter the columns of SP_m using the provided criteria
  data_filtered <- filter_data_columns(SP_m, study, cell_type, virusgenome, virus_type, sample_group)
  
  # Create a heatmap using pheatmap
  out <- pheatmap(na.omit(data_filtered),
                  cluster_row = FALSE,
                  cluster_cols = TRUE,
                  clustering_distance_cols = "euclidean")
  
  # Plot the dendrogram for columns
  plot(out$tree_col)
}