##################### LOAD PACKAGES  ##############################
library(foreach)
library(doParallel)
library(Matrix)

##################### COMPUTE SELECT ##############################
compute_server='LOCAL'

if(length(commandArgs(TRUE))==5){
  compute_server=(commandArgs(TRUE))[5]
  print(length(commandArgs(TRUE)))
}

print(paste('Compute Server',compute_server))

if(compute_server=='LOCAL'){
  working_dir='C:/Users/davev/Documents/UofT/Computing/20240214 Computing Presentation/Example R Files'
  results_dir='C:/Users/davev/Documents/UofT/Computing/20240214 Computing Presentation/Example R Files/SimResults'
  job_num='ALL'
  ncores=4
  
  setwd(working_dir)
  source('ExampleHelper.R')
  
}else{
  if(compute_server=='NIAGARA'){
    working_dir='/gpfs/fs0/scratch/j/junpark/dveitch/Example'
    results_dir='/gpfs/fs0/scratch/j/junpark/dveitch/Example/SimResults'
  }else if(compute_server=='CEDARSCRATCH'){
    working_dir='/scratch/dveitch/Example'
    results_dir='/scratch/dveitch/Example/SimResults' 
    real_data_dir='/scratch/dveitch/Brain/RealData'
  }else if(compute_server=='CEDARLOGIN'){
    working_dir='/scratch/dveitch/Example'
    results_dir='/scratch/dveitch/Example/SimResults' 
    real_data_dir='/scratch/dveitch/Brain/RealData'
  }else if(compute_server=='MERCURY'){
    working_dir='/u/veitch/Example'
    results_dir=paste(working_dir,'/SimResults',sep='')  
  }  
  
  # Unpack Arguments Being Passed Into R, here there are 5 arguments
  # args[1] - name of function to run
  # args[2] - job number, or 'ALL'; used to specify
  # args[3] - number of cores to parallelize across
  # args[4] - total nodes to use (only for Niagara), set to 1
  # args[5] - name of compute server (e.g. 'NIAGARA', 'CEDAR', 'MERCURY')
  args=(commandArgs(TRUE))
  print('Args Passed')
  print(args)
  function_call=as.character(args[1])
  if(as.character(args[2])=='ALL'){
    job_num=as.character(args[2])
  }else{
    job_num=as.numeric(args[2])
  }
  ncores=as.numeric(args[3])
  total_nodes_to_use=as.numeric(args[4])
  print(paste(function_call,'function name'))
  print(paste(job_num,'job number'))
  print(paste(ncores,'number of cores'))
  print(paste(total_nodes_to_use,'total nodes for whole job'))
  registerDoParallel(cores=ncores)# Shows the number of Parallel Workers t requested.
  print(paste('actual workers',as.character(getDoParWorkers()))) # you can compare with the number of actual workers
  print(working_dir)
  setwd(working_dir)
  source('ExampleHelper.R')
  
  print('loaded helper functions')
}

##################### EXAMPLE SIMULATION ##############################
ex_simulation<-function(job_num,results_dir,working_dir){
 
  if(job_num=='ALL'){
    start_seed=999
  }else{stat_seed=job_num}
  
  cl <- parallel::makeCluster(ncores,outfile="")
  doParallel::registerDoParallel(cl)
  
  experiment_results=foreach(i=1:10, .packages = c('Matrix'),.combine='rbind')%dopar%{
                               set.seed(i+job_num)
                               setwd(working_dir)
                               source('ExampleHelper.R')
                               x=sim_normal_rv(1,5)
                               
                               x
                             }
  parallel::stopCluster(cl)
  
  setwd(results_dir)
  write.csv(experiment_results, file = paste(function_call,'-reject-',sprintf("%05d",job_num),'.csv',sep=''))
}

###################### RUN CODE ##############################
do.call(function_call,list(job_num,results_dir,working_dir))
