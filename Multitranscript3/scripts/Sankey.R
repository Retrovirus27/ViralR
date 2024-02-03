# Function map5 to create a Sankey diagram using ggplot2

map5 <- function(fcs, gene, cell_type, study, virusgenome, virus_type, FC, sample_group) {
  FC <- as.numeric(FC)
  SP_m <- fcs[row.names(fcs) %in% gene,]
  
  # Set values in SP_m to 0 if they have absolute value less than FC
  SP_m[abs(SP_m) < FC] <- 0
  
  # Filter the columns of SP_m using the provided criteria
  data_filtered <- filter_data_columns(SP_m, study, cell_type, virusgenome, virus_type, sample_group)
  
  # Use the rownames() function to get gene names
  gene_names <- rownames(data_filtered)
  
  # Use the mutate_all() function to modify all cells
  # Apply the ifelse() function to add the gene name if the fold change is not equal to 0
  data_with_gene_names <- data_filtered %>%
    mutate_all(~ifelse(. != 0, gene_names, .))
  
  # Convert the matrix into a data frame
  data_frame <- as.data.frame(data_with_gene_names)
  
  # Perform the "unstack" operation
  melted_data <- data.frame(
    Condition = rep(colnames(data_frame), each = nrow(data_frame)),
    Gene = unlist(data_frame)
  )
  
  # Filter rows that do not have gene names assigned
  melted_data2 <- melted_data[melted_data$Gene != "0", ]
  
  df <- melted_data2 %>%
    make_long(Condition, Gene)
  
  ggplot(df, aes(x = x, 
                 next_x = next_x, 
                 node = node, 
                 next_node = next_node,
                 fill = factor(node),
                 label = node)) +
    geom_sankey(flow.alpha = 0.5, node.color = 1) +
    geom_sankey_label(size = 3.5, color = 1, fill = "white") +
    scale_fill_viridis_d() +
    theme_sankey(base_size = 16) +
    theme(legend.position = "none", axis.text.x = element_blank(), axis.title.x = element_blank())
}