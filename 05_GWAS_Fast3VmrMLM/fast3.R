library("Fast3VmrMLM")

Fast3VmrMLM(
  fileGen = "file_path/your_file",
  filePhe = "file_path/phenotype.csv",
  filePS = "file_path/PCA.csv",
  PopStrType = "PC",
  fileOut = "file_path/result/",
  trait = 1,
  svrad = 2e+4,        
  svpal = 0.01,
  svmlod = 3,
  DrawPlot = TRUE,
  Plotformat = "*.tiff" 
)