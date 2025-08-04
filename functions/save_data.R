### Save the data ===========================

write_file <- function(filename, dataset, title="Rostock running"){
  
  # Create the file
  file <- file.path("data/", paste0(filename, ".gpx"))
  
  # Create time format
  format_time <- function(time) {
    if(!is.POSIXct(time)) stop("Must be character")
    paste0(date(time), "T", strftime(time, format="%H:%M:%S"), ".000Z" )
  }
  
  # Create the header
  header <- paste('<?xml version="1.0" encoding="UTF-8"?>',
                  '<gpx creator="Garmin Connect" version="1.1"',
                  '\txsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/11.xsd"',
                  '\txmlns:ns3="http://www.garmin.com/xmlschemas/TrackPointExtension/v1"',
                  '\txmlns="http://www.topografix.com/GPX/1/1"',
                  '\txmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ns2="http://www.garmin.com/xmlschemas/GpxExtensions/v3">',
                  '\t<metadata>',
                  '\t\t<link href="connect.garmin.com">',
                  '\t\t\t<text>Garmin Connect</text>',
                  '\t\t</link>',
                  paste0('\t<time>', format_time(dataset$time[1]), '</time>'),
                  '\t</metadata>',
                  '\t<trk>',
                  paste0('\t\t<name>', title, '</name>'),
                  '\t\t<type>running</type>',
                  '\t\t<trkseg>\n',
                  sep="\n")
  
  cat(header, file=file)
  
  print(nrow(dataset))
  # Write a tracking points
  lapply(1:nrow(dataset), function(i) { 
    cat(
      paste0('\t\t\t<trkpt lat="', dataset$latitude[i], '" lon="', dataset$longitude[i], '">'),
      paste0('\t\t\t\t<ele>', dataset$altitude[i], '</ele>'),
      paste0('\t\t\t\t<time>', format_time(dataset$time[i]), '</time>'),
      '\t\t\t\t<extensions>',
      '\t\t\t\t\t<ns3:TrackPointExtension>',
      paste0('\t\t\t\t\t\t<ns3:hr>', dataset$heart_rate[i], '</ns3:hr>'),
      paste0('\t\t\t\t\t\t<ns3:cad>', dataset$cadence_running[i], '</ns3:cad>'),
      '\t\t\t\t\t</ns3:TrackPointExtension>',
      '\t\t\t\t</extensions>',
      "\t\t\t</trkpt>",
      sep="\n", file=file, append=TRUE)
  })
  
  
  # Create the footer
  cat('\t\t</trkseg>', '\t</trk>', '</gpx>', sep="\n", file=file, append=TRUE)
  
  
}


### END ############################################