# R script for "carob"



carob_script <- function(path) {
  
  "
  The present data is from a long-term trial set at Msekera Research Station in Zambia to monitor and evaluate the long-term effects of conservation agriculture practices on soil quality, soil water dynamics, weeds, pests/diseases, and crop yield. This trial was conducted from 2012 to 2020. The ten treatments including control were:
  
T1: Control plot 1 (CPM1): traditional farmers practice mouldboard plough on the flat, maize as a sole crop, no residue retention, stubble incorporated into the row for the following season.
T2: Control plot 2 (CPM2); ridge and furrow system dug by hand, maize as a sole crop, no residue retention, stubble incorporated into the row for the following season
T3: Basins (BAM), residue retention on the surface, maize as a sole crop
T4: Dibble stick (DISM), residue retention on the surface, maize as a sole crop
T5: Direct seeder (DSM), residue retention on the surface, maize as a sole crop
T6: Direct seeding maize/cowpea intercropping (DS-M/C), 90cm rows, residue retention on the surface
T7: Direct seeding cowpea (Cowpea-maize rotation) (DS-MC), residue retention on the surface
T8:Direct seeding maize (Maize-cowpea rotation) (DS-CM), residue retention on the surface
T9:Direct seeding soya (Soybean-maize rotation) (DS-MS), residue retention on the surface
T10: Direct seeding maize (Maize-soybean rotation) (DS-SM), residue retention on the surface"
  
  uri <- "doi:10.7910/DVN/Z7M0AV"
  group <- "conservation_agriculture"
  ff <- carobiner::get_data(uri, path, group)
 
  dset <- data.frame(
  	carobiner::read_metadata(uri, path, group, major=1, minor=2),
    project=NA,
    publication= NA,
    data_institute = "CIMMYT",
    data_type="experiment",
    carob_contributor="Fredy Chimire",
    carob_date="2024-1-16"
  )
  
  
  
  f <- ff[basename(ff) == "AR_ZAM_CIMMYT_Msekera_LT trial_2020.csv"]
  
  # Select sheet with revised data from the excel file 
  r <- read.csv(f)
  
  d <- data.frame(country=r$County, harvest_date=r$year, rep=r$Rep, 
			crop=r$Crop, treatment=r$Treatdesc, adm2=r$District, 
			location=r$Location, dmy_total = r$Biomass, yield = r$Grain)
  
  # for first dataset
  
  
  d$is_survey <- FALSE
  d$on_farm <- TRUE
  d$N_fertilizer <- 10 
  d$P_fertilizer <- 20
  d$K_fertilizer <- 10
     
  d$yield_part <- "grain"
  
	d$crop <- tolower(d$crop)
	d$crop <- gsub("soyabeans", "soybean", d$crop)
	d$harvest_date <- as.character(d$harvest_date)
	d$yield <- as.numeric(gsub(",", "", d$yield))
	d$dmy_total <- as.numeric(gsub(",", "", d$dmy_total))

  
  # https://www.findlatitudeandlongitude.com/l/Msekera+Chipata+Zambia/5548305/
  d$latitude <- -13.64451
  d$longitude <- 32.6447
  
  carobiner::write_files(dset, d, path=path)
}


