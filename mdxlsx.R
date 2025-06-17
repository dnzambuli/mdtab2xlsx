library(writexl)

#' @title convert
#' @description Converts specified columns of a dataframe to user-defined types.
#' @param df A dataframe whose column types are to be converted.
#' @param col_types A named list where names are the column names to be converted
#'   and values are the target R data types (e.g., "numeric", "character", "Date", "factor", "integer").
#'   For "Date" conversion, ensure the original column is in a recognizable date format.
#' @return The dataframe with the specified columns converted to the new types.
#' @examples
#' # Create a sample dataframe
#' sample_df <- data.frame(
#'   ID = c(1, 2, 3),
#'   Name = c("Alice", "Bob", "Charlie"),
#'   Age = c("25", "30", "35"), # Stored as character initially
#'   StartDate = c("2023-01-15", "2023-02-20", "2023-03-25"), # Stored as character
#'   Category = c(1, 2, 1), # Stored as numeric initially
#'   stringsAsFactors = FALSE
#' )
#'
#' # Define the desired column types
#' desired_types <- list(
#'   Age = "numeric",
#'   StartDate = "Date",
#'   Category = "factor"
#' )
#'
#' # Convert the columns
#' converted_df <- convert(sample_df, desired_types)
#' print(converted_df)
#' str(converted_df)
#'
#' # Example usage within my_func
#' my_func <- function(file_path, col_types_list) {
#'   # Simulate reading a file into a dataframe
#'   # In a real scenario, you would use read.csv(), read_excel(), etc.
#'   if (file_path == "dummy_data.csv") {
#'     df <- data.frame(
#'       ItemID = c("A001", "A002", "A003", "A004"),
#'       Price = c("10.50", "20.00", "5.75", "12.20"), # Character
#'       Quantity = c(100, 250, 75, 180), # Numeric
#'       OrderDate = c("2024-01-01", "2024-01-05", "2024-01-10", "2024-01-15"), # Character
#'       IsAvailable = c("TRUE", "FALSE", "TRUE", "TRUE"), # Character
#'       stringsAsFactors = FALSE
#'     )
#'     message(paste("Loaded dummy data from:", file_path))
#'   } else {
#'     stop("File not found or not supported in this example.")
#'   }
#'
#'   # Call the convert function
#'   df_converted <- convert(df, col_types_list)
#'
#'   return(df_converted)
#' }
#'
#' # Define column types for my_func example
#' func_col_types <- list(
#'   Price = "numeric",
#'   OrderDate = "Date",
#'   IsAvailable = "logical"
#' )
#'
#' # Run my_func
#' result_df <- my_func("dummy_data.csv", func_col_types)
#' print(result_df)
#' str(result_df)
convert <- function(df, col_types) {
  # Input validation
  if (!is.data.frame(df)) {
    stop("Error: 'df' must be a dataframe.")
  }
  if (!is.list(col_types) || is.null(names(col_types))) {
    stop("Error: 'col_types' must be a named list mapping column names to types.")
  }

  # Iterate through the named list of desired types
  for (col_name in names(col_types)) {
    target_type <- col_types[[col_name]]

    # Check if the column exists in the dataframe
    if (!col_name %in% colnames(df)) {
      warning(paste0("Warning: Column '", col_name, "' not found in the dataframe. Skipping conversion for this column."))
      next # Skip to the next column
    }

    # Perform type conversion based on the specified target type
    tryCatch({
      if (target_type == "numeric") {
        df[[col_name]] <- as.numeric( gsub("[^0-9.-]", "", df[[col_name]]))
      } else if (target_type == "character") {
        df[[col_name]] <- as.character(df[[col_name]])
      } else if (target_type == "integer") {
        df[[col_name]] <- as.integer(gsub("[^0-9.-]", "", df[[col_name]]))
      } else if (target_type == "logical") {
        # as.logical handles "TRUE"/"FALSE" strings
        df[[col_name]] <- as.logical(df[[col_name]])
      } else if (target_type == "Date") {
        # as.Date handles various date formats, but consistent input is best
        df[[col_name]] <- as.Date(df[[col_name]])
      } else if (target_type == "factor") {
        df[[col_name]] <- as.factor(df[[col_name]])
      } else {
        warning(paste0("Warning: Unsupported target type '", target_type, "' for column '", col_name, "'. Skipping conversion."))
      }
    }, error = function(e) {
      warning(paste0("Error converting column '", col_name, "' to type '", target_type, "': ", e$message, ". Column type remains unchanged."))
    })
  }

  return(df)
}


#' @title mdxlsx
#' @description Converts a markdown file to excel
#' @param markdown_file a markdown table stored in a .md file
#' @param col_types A named list where names are the column names to be converted and values are the target R data types (e.g., "numeric", "character", "Date", "factor", "integer").
#'   For "Date" conversion, ensure the original column is in a recognizable date format.
#' @param file_name the file name of the desired excel file.
#' Do not include '.xlsx' or '.csv'
#' @return The excel file
#' @examples
#' example.r
#'
mdxlsx = function(markdown_file, col_types, file_name){
  cat("\n______________________\n")
  cat("Converting: ", markdown_file)
  cat("\n______________________\n")
  #  read the markdown
  data = read.table(markdown_file, sep = "|", skip = 0, strip.white = TRUE, fill = TRUE)

  # get the data title
  data_names = data[1,]
  data = data[3:nrow(data),]
  colnames(data) = data_names
  regex_pattern = "NA(?:\\..*)?"
  columns_to_keep <- grep(regex_pattern, colnames(data), invert = TRUE, value = TRUE)
  data = data[, columns_to_keep]
  df_cor_col = convert(data, col_types)
  write_xlsx(df_cor_col, paste0(file_name, ".xlsx"))
  cat("\n______________________\n")
  cat("Your file has been written to: ", paste0(file_name, ".xlsx"))
  cat("\n______________________\n")
}
