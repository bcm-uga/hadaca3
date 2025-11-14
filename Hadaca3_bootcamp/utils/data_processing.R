
# library(assertr)
library(rhdf5)
library(Matrix) 


get_omic <- function(path) {
  path_parts <- unlist(strsplit(path, "/"))
  return(path_parts[length(path_parts) - 1])
}

omic2list_name = list(mixRNA = "mix_rna" , 
mixMET =  "mix_met",
MET='ref_met',
RNA= 'ref_bulkRNA',
scRNA= 'ref_scRNA' ) 


write_data_frame <- function(name, path,data){
    h5createGroup(path, name)
    h5write(data, file = path, name = paste0(name, "/data"))

    
    if(length(colnames(data))){
      h5write(colnames(data), file = path, name = paste0(name, "/samples"))
    }
    if(length(rownames(data))){
      h5write(rownames(data), file = path, name = paste0(name, "/genes"))
    }



}


write_sparse_matrix <- function(group, path, counts, meta, data = NULL, scale_data = NULL) {
  h5createGroup(path, group)

  # Write counts
  h5createDataset(path, paste0(group, '/data'), dims = length(counts@x), storage.mode = "double")
  h5write(counts@x, path, paste0(group, "/data"))
  h5write(dim(counts), path, paste0(group, "/shape"))
  h5createDataset(path, paste0(group, '/indices'), dims = length(counts@i), storage.mode = "integer")
  h5write(counts@i, path, paste0(group, "/indices"))
  h5write(counts@p, path, paste0(group, "/indptr"))
  if (!is.null(rownames(counts))) {
    h5write(rownames(counts), path, paste0(group, "/genes"))
  }
  if (!is.null(colnames(counts))) {
    h5write(colnames(counts), path, paste0(group, "/cell"))
  }

  h5write(meta, path, paste0(group, "/meta"))

  if (!is.null(data)) {
    h5createDataset(path, paste0(group, '/normalized_data'), dims = length(data@x), storage.mode = "double")
    h5write(data@x, path, paste0(group, "/normalized_data"))
  }

}


write_hdf5 <- function(path, data_list) {
  # Create the HDF5 file
  h5createFile(path)

  for (name in names(data_list)) {

    if (name == "ref_scRNA") {
      h5createGroup(path, 'ref_scRNA/')

      for (dataset in names(data_list[[name]])) {
        group = paste0('ref_scRNA/', dataset)
        h5createGroup(path, group)

        # entry <- data_list[[name]][[dataset]]
        seurat_obj <- NULL
        seurat_field_name <- NULL
        group_seurat = group
        if(inherits(data_list[[name]][[dataset]], "Seurat")){
          seurat_obj <- data_list[[name]][[dataset]]
          seurat_field_name <- dataset
          
        }

        ##Check if there is a Seurat Object 
        for (field in names(data_list[[name]][[dataset]])) {
          if (inherits(data_list[[name]][[dataset]][[field]], "Seurat")) {
            seurat_obj <- data_list[[name]][[dataset]][[field]]
            seurat_field_name <- field
            group_seurat = paste0('ref_scRNA/', dataset,'/',field)
            # h5createGroup(path,paste0(path,group), field)
            h5createGroup(path,group_seurat)

            break
          }
        }

        if (!is.null(seurat_obj)) {
          library(Seurat)

          h5write("seurat", path, paste0(group_seurat, "/object_type"))
          h5write(seurat_field_name, path, paste0(group_seurat, "/seurat_field_name"))

          write_sparse_matrix(group_seurat, path,
            counts = GetAssayData(seurat_obj, assay = "RNA", layer = "counts"),
            meta = seurat_obj@meta.data , 
            data = GetAssayData(seurat_obj, assay = "RNA", layer = "data"), 
            scale_data= GetAssayData(seurat_obj, assay = "RNA", layer = "scale.data")
          )

        }
      
        if("counts" %in% names(data_list[[name]][[dataset]]) && "metadata" %in% names(data_list[[name]][[dataset]])) {
          write_sparse_matrix(group, path, data_list[[name]][[dataset]]$counts, data_list[[name]][[dataset]]$metadata)
        }
      }
    } else {
      write_data_frame(name, path, data_list[[name]])
    }
  }
}



read_data_frame <- function(path,name,file_structure){
    data <- h5read(file = path, name = paste0("/",name, "/data"))
    
    if(!is.null(file_structure[[name]]$samples)){
      samples <- h5read(file = path, name = paste0("/",name, "/samples"))
      colnames(data) <- samples
    }
    if(!is.null(file_structure[[name]]$cell_types)){
      cell_types <- h5read(file = path, name = paste0("/",name, "/cell_types"))
      colnames(data) <- cell_types
    }
    if(!is.null(file_structure[[name]]$genes)){
      genes <- h5read(file = path, name = paste0("/",name, "/genes"))
      rownames(data) <- genes
    }
    if(!is.null(file_structure[[name]]$CpG_sites)){
      CpG_sites <- h5read(file = path, name = paste0("/",name, "/CpG_sites"))
      rownames(data) <- CpG_sites
    }
    return(data)

}

read_sparse_matrix <- function(group,group_structure, path) {
  counts_data <- as.numeric(h5read(path, paste0(group, "/data")))
  counts_shape <- as.integer(h5read(path, paste0(group, "/shape")))
  counts_indices <- as.integer(h5read(path, paste0(group, "/indices")))
  counts_indptr <- as.integer(h5read(path, paste0(group, "/indptr")))
  gene_names <- as.character(h5read(path, paste0(group, "/genes")))
  cell_names <- as.character(h5read(path, paste0(group, "/cell")))

  counts <- new("dgCMatrix",
                x = counts_data,
                i = counts_indices,
                p = counts_indptr,
                Dim = counts_shape,
                Dimnames = list(gene_names, cell_names))

  meta <- h5read(path, paste0(group, "/meta"))
  meta <- as.data.frame(meta, stringsAsFactors = FALSE)
  rownames(meta) <- cell_names

  # Detect if the original object was Seurat
  is_seurat <- FALSE
  # if (paste0(group, "/object_type") %in% h5ls(path, recursive = TRUE)$name) {
  if ( "object_type" %in% names(group_structure)) {
    object_type <- h5read(path, paste0(group, "/object_type"))
    is_seurat <- object_type == "seurat"
  }

  if (is_seurat) {
    library(Seurat)
    seurat_obj <- CreateSeuratObject(counts = counts, meta.data = meta)
    DefaultAssay(seurat_obj) <- "RNA"
    if ("normalized_data" %in% names(group_structure)) {
      data <- counts
      data@x <- as.numeric(h5read(path, paste0(group, "/normalized_data")))
      seurat_obj[["RNA"]] <- SetAssayData(seurat_obj[["RNA"]], layer = "data", new.data = data)
    }

    if ("scale_data" %in% names(group_structure)) {
      scale_values <- as.numeric(h5read(path, paste0(group, "/scale_data")))
      scale_data <- counts
      scale_data@x <- scale_values
      seurat_obj[["RNA"]] <- SetAssayData(seurat_obj[["RNA"]], layer = "scale.data", new.data = scaled_data)

    }

    return(seurat_obj)
  } else {
    return(list(counts = counts, metadata = meta))
  }
}

read_hdf5 <- function(path) {
  file_structure <- h5dump(path, load = FALSE)
  group_names <- names(file_structure)
  data_list <- list()

  for (name in group_names) {
    if (name == "ref_scRNA") {
      ref_scRNA <- list()

      for (dataset in names(file_structure[[name]])) {
        seuratobj_or_counts_n_metadata <- read_sparse_matrix(paste0('ref_scRNA/', dataset), file_structure[[name]][[dataset]] , path)
        
        ## check if there is another data inside here !  TODO change this with a metadata list in the root of this file... 
        expected_names <- c("cell", "data", "genes", "indices", "indptr", "meta", "shape")
        actual_names <- names(file_structure[[name]][[dataset]])
        unexpected_names = actual_names[!actual_names %in% expected_names]

        for(field in unexpected_names ){
          seuratobj_or_counts_n_metadata[[field]] = read_sparse_matrix(paste0('ref_scRNA/', dataset,'/',field), file_structure[[name]][[dataset]][[field]] , path)
        }
        ref_scRNA[[dataset]] = seuratobj_or_counts_n_metadata
      }

      data_list[[name]] <- ref_scRNA
    } else {
      data_list[[name]] <- read_data_frame(path, name, file_structure)
    }
  }

  return(data_list)
}