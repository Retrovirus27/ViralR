# Create a function to apply filters to columns
filter_data_columns <- function(data, study, cell_type, virusgenome, virusType, sample_group) {
  # Create an initial logical filter vector, initially all TRUE
  logical_filter <- rep(TRUE, ncol(data))
  # Filter by study
  if (study != "All") {
    selected_columns_study <- which(sample_group$Study == study)
    logical_filter <- logical_filter & (1:ncol(data) %in% selected_columns_study)
  }
  # Filter by cell type
  if (cell_type != "All") {
    selected_columns <- which(sample_group$CellType == cell_type)
    logical_filter <- logical_filter & (1:ncol(data) %in% selected_columns)
  }
  # Filter by virus genome
  if (virusgenome != "All") {
    selected_columns_genome <- which(sample_group$VirusGenome == virusgenome)
    logical_filter <- logical_filter & (1:ncol(data) %in% selected_columns_genome)
  }
  if (virusType != "All") {
    selected_columns_virus <- which(sample_group$VirusType == virusType)
    logical_filter <- logical_filter & (1:ncol(data) %in% selected_columns_virus)
  }
  # Apply the final logical filter to the data set
  filtered_data <- data[, logical_filter]
  return(filtered_data)
}