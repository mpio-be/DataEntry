

# local
    require(sysmanager); push_github_all('DataEntry')
    devtools::install_github("jrowen/rhandsontable")
    

# server
    require(sysmanager);install_github('valcu/DataEntry', auth_token = github_pat(TRUE) )
    sysmanager::restart_shinyServer()
    
    # test