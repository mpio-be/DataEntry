

context("Functions returning one value")

    test_that("The correct class or type is returned", {

    expect_s3_class( strp_date_or_time("2018-03-17"),          "POSIXct" )
    expect_s3_class( strp_date_or_time("2018-03-17 10:20"),    "POSIXct" )
    expect_s3_class( strp_date_or_time("2018-03-17 10:20:30"), "POSIXct" )


    })

context("Functions returning data.table-s")

    test_that("DT is returned", {

    x = data.table::data.table(x = 1:40, y = 1:40, 
    z = rep(letters, 40, TRUE), q = rep(letters, 40, TRUE))
    x[1:10,z := 'NA']

    expect_s3_class( meltall(x) , "data.table" )

    cleaner(x)



    })

context("Functions for validation")

    test_that("validators", {

    # validators should return 3 columns:
    VN = c("rowid", "variable", "reason")

    # is.na    
    x = data.table(v1 = c(1,2, NA, NA), v2  = c(1,2, NA, NA) )
    expect_identical( names(is.na_validator(x)), VN)

    #POSIXct
    x = data.table(
    v1 = c(NA, NA, as.character(Sys.time() - 3600*24*10 )  ) ,
    v2 = c('2016-11-23 25:23', as.character(Sys.time() -100) ,as.character(Sys.time()+100)))
    o = POSIXct_validator(x)

    expect_identical( names(is.na_validator(x)), VN)
    expect_equal(nrow(o), 2)

    # hh:mm
    o = hhmm_validator( data.table(v1 = c('02:04' , '16:56'), v2= c('24:04' , NA)))
    expect_identical( names(is.na_validator(x)), VN)
    expect_equal(nrow(o), 1)

    # datetime
    o = datetime_validator( data.table(v1 = c('2017-07-27 00:00' , '2017-01-21')) )
    expect_identical( names(is.na_validator(x)), VN)
    expect_equal(nrow(o), 1)

    # time-order
    x = data.table(v1 = c('10:10' , '16:30', '02:08'  ) )
    v = data.table(v2 = c('10:04' , '16:40', '01:55'  ) )
    o = time_order_validator(x, v)
    expect_identical( names(is.na_validator(x)), VN)
    expect_equal(nrow(o), 1)

    # interval
    x = data.table(box = c(0, 1, 100, 300))
    v = data.table(variable = 'box', lq = 1, uq = 277 )
    o = interval_validator(x,v)
    expect_identical( names(is.na_validator(x)), VN)
    expect_equal(nrow(o), 2)

    # nchar
    x = data.table(v1 = c('x', 'xy', 'x')  , v2 = c('xx', 'x', 'xxx')  )
    v = data.table(variable = c('v1', 'v2'), n = c(1, 2) )
    o = nchar_validator(x, v)
    expect_identical( names(is.na_validator(x)), VN)
    expect_equal(nrow(o), 3)

    #is.element
    x = data.table(v1 = c('A', 'B', 'C')  , v2 = c('ZZ', 'YY', 'QQ')  )
    v = data.table(variable = c('v1', 'v2'), 
    set = c( list( c('A', 'C') ), list( c('YY')  )) )
    o = is.element_validator(x, v)
    expect_equal(nrow(o), 3)

    # is.duplicate
    x = data.table(v1 = c('A', 'B', 'C')  , v2 = c('ZZ', 'YY', 'QQ')  )
    v = data.table(variable = c('v1', 'v2'), 
    set = c( list( c('A', 'C') ), list( c('YY')  )) )
    o = is.duplicate_validator(x, v)
    expect_equal(nrow(o), 3)

    #is.identical
    x = data.table(v1 = 1:3  , v2 = c('a', 'b', 'c')  )
    v = data.table(variable = c('v1', 'v2'),  x = c(1, 'd'))
    o = is.identical_validator(x, v)
    expect_equal(nrow(o), 5)

    #combo_validator
    x = data.table(UL = c('M', 'M')  , LL = c('G,DB', 'G,P'), 
    UR = c('Y', 'Y'), LR = c('R', 'G') )
    o =  combo_validator(x, validSet  = colorCombos() )
    expect_equal(nrow(o), 1)


    })

context("UI elements and helpers")

    test_that("js functions", {

     expect_type( boostrap_table( data.table(x = 1, y = 'a') ), "character" )
     expect_s3_class( js_insertMySQLTimeStamp(),          "html" )
     expect_s3_class( jquery_change_by_id(1,2),          "html" )
     
     expect_s3_class( useNavbar(),          "shiny.tag" )
     


    })


