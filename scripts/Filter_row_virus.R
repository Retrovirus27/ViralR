# Create a function to apply filters
filter_data_rows <- function(data, study, cell_type, virusgenome, virusType, sample_group) {
  # Create an initial logical filter vector, initially all TRUE
  logical_filter <- rep(TRUE, nrow(data))
  # Filter by study
  if (study != "All") {
    selected_cells_study <- which(sample_group$Study == study)
    logical_filter <- logical_filter & (1:nrow(data) %in% selected_cells_study)
  }
  # Filter by cell type
  if (cell_type != "All") {
    selected_cells <- which(sample_group$CellType == cell_type)
    logical_filter <- logical_filter & (1:nrow(data) %in% selected_cells)
  }
  # Filter by virus genome
  if (virusgenome != "All") {
    selected_cells_genome <- which(sample_group$VirusGenome == virusgenome)
    logical_filter <- logical_filter & (1:nrow(data) %in% selected_cells_genome)
  }
  if (virusType != "All") {
    selected_cells_virus <- which(sample_group$VirusType == virusType)
    logical_filter <- logical_filter & (1:nrow(data) %in% selected_cells_virus)
  }
  # Apply the final logical filter to the data set
  filtered_data <- data[logical_filter, ]
  return(filtered_data)
}