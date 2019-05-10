

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


context("UI elements and helpers")

    test_that("js functions", {

     expect_type( boostrap_table( data.table(x = 1, y = 'a') ), "character" )
     expect_s3_class( js_insertMySQLTimeStamp(),          "html" )
     expect_s3_class( jquery_change_by_id(1,2),          "html" )
     
     expect_s3_class( useNavbar(),          "shiny.tag" )
     


    })


