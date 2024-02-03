# Function map6 to create a pair of network plots for upregulated and downregulated genes

map6 <- function(fcs, gene, cell_type, study, virusgenome, virus_type, FC, sample_group) {
  SP_m <- fcs[row.names(fcs) %in% gene,]
  
  # Set values in SP_m to 0 if they have absolute value less than FC
  SP_m[abs(SP_m) < FC] <- 0
  
  data_matrix <- filter_data_columns(SP_m, study, cell_type, virusgenome, virus_type, sample_group)
  
  # Create a data frame for negative numbers
  df_negativos <- data_matrix
  df_negativos[df_negativos >= 0] <- NA
  
  # Create a data frame for positive numbers
  df_positivos <- data_matrix
  df_positivos[df_positivos <= 0] <- NA
  
  # Replace NA with 0 in both data frames
  df_negativos[is.na(df_negativos)] <- 0
  df_positivos[is.na(df_positivos)] <- 0
  
  # Divide the graphics window into two columns
  par(mfrow = c(1, 2))
  
  # Define the network plots for positive and negative genes
  plot_positivos <- plotweb(abs(df_positivos), text.rot = 90, col.low = "gray", col.high =
                              "black", labsize = 1.5, 
                            y.width.low = 0.01, y.width.high = 0.01, 
                            col.interaction = adjustcolor('red', alpha.f = 0.5))
  title(main = "Upregulated genes", sub = NULL, xlab = NULL, ylab = NULL)
  
  plot_negativos <- plotweb(abs(df_negativos), text.rot = 90, col.low = "gray", col.high =
                              "black", labsize = 1.5, 
                            y.width.low = 0.01, y.width.high = 0.01, 
                            col.interaction = adjustcolor('blue', alpha.f = 0.5))
  title(main = "Downregulated genes", sub = NULL, xlab = NULL, ylab = NULL)
}