# Read in .CSVs
#setwd("/Users/zachstrennen/github_revamp/Capstone-SquareFace/Data Cleaning")
df_jan <- read_csv("Input Data/January 2024 TMAN fixed.csv")
df_feb <- read_csv("Input Data/February 2024 TMAN fixed.csv")
#setwd("/Users/zachstrennen/Documents/SquareFace_official_repo/2024-cmu/Data Cleaning/")
# Combine data
df <- rbind(df_jan, df_feb)
table(filter(df, Club == "Unknown Club")$Player)
males <- c(
    "Andrew", "Brian Xu", "Daniel Rodgers", "David Zhang", "Folker",
    "Hank", "Jack Sonne", "Jay Saluja", "Justin Chan", "Justin Luan",
    "Ryan Dannegger", "Simulation Player", "Stephen Dai", "Steven Shea"
)

df <- df %>%
    mutate(Sex = ifelse(Player %in% males, "Male", "Female"))

# Define standard clubs
st_club <- c(
  "4 Iron", "5 Iron", "6 Iron", "7 Iron", "8 Iron", "9 Iron",
  "Pitching Wedge", "Driver"
)

# df with only standard clubs
df_st_club <- filter(df, Club %in% st_club)

# Add a shaft_lean column
df_st_club <- mutate(df_st_club, shaft_lean = 0)

# Calculate Shaft Lean for all clubs in standard set
df_st_club <- df_st_club %>%
  mutate(shaft_lean = ifelse(Club == "Driver", 10.5 - `Dyn. Loft`,
    ifelse(Club == "4 Iron", 22 - `Dyn. Loft`,
      ifelse(Club == "5 Iron", 25 - `Dyn. Loft`,
        ifelse(Club == "6 Iron", 29 - `Dyn. Loft`,
          ifelse(Club == "7 Iron", 33 - `Dyn. Loft`,
            ifelse(Club == "8 Iron", 37 - `Dyn. Loft`,
              ifelse(Club == "9 Iron", 41 - `Dyn. Loft`,
                45 - `Dyn. Loft`
              )
            )
          )
        )
      )
    )
  ))

# Select response and predictor variables and omit NA values
df_st_club <- dplyr::select(df_st_club, "Club", "Club Speed", "Attack Angle", "Swing Plane", "Face Angle", "Club Path", "shaft_lean", "Max Height - Height", "Max Height - Side", "Max Height - Dist.", "Carry Flat - Length", "Carry Flat - Side", "Est. Total Flat - Length", "Est. Total Flat - Side", "Player", "Sex") %>%
    na.omit()

# ORIGINALLY 15
# The next few lines limit the data via our "good shot" criteria
df_st_club <- df_st_club %>%
  filter(!(Club == "Driver" & `Est. Total Flat - Side` > 15))

df_st_club <- df_st_club %>%
  filter(!(Club == "Driver" & `Est. Total Flat - Side` < -15))

df_st_club <- df_st_club %>%
    filter(!(Club == "Driver" & `Est. Total Flat - Length` > 310))

df_st_club <- df_st_club %>%
    filter(!(Club == "Driver" & `Est. Total Flat - Length` < 280))

df_st_club <- df_st_club %>%
  filter(!(Club == "9 Iron" & `Est. Total Flat - Side` > 5))

df_st_club <- df_st_club %>%
  filter(!(Club == "9 Iron" & `Est. Total Flat - Side` < -5))

df_st_club <- df_st_club %>%
  filter(!(Club == "8 Iron" & `Est. Total Flat - Side` > 5))

df_st_club <- df_st_club %>%
  filter(!(Club == "8 Iron" & `Est. Total Flat - Side` < -5))

df_st_club <- df_st_club %>%
  filter(!(Club == "7 Iron" & `Est. Total Flat - Side` > 7.5))

df_st_club <- df_st_club %>%
  filter(!(Club == "7 Iron" & `Est. Total Flat - Side` < -7.5))

df_st_club <- df_st_club %>%
  filter(!(Club == "6 Iron" & `Est. Total Flat - Side` > 7.5))

df_st_club <- df_st_club %>%
  filter(!(Club == "6 Iron" & `Est. Total Flat - Side` < -7.5))

df_st_club <- df_st_club %>%
  filter(!(Club == "5 Iron" & `Est. Total Flat - Side` > 10))

df_st_club <- df_st_club %>%
  filter(!(Club == "5 Iron" & `Est. Total Flat - Side` < -10))

df_st_club <- df_st_club %>%
  filter(!(Club == "4 Iron" & `Est. Total Flat - Side` > 10))

df_st_club <- df_st_club %>%
  filter(!(Club == "4 Iron" & `Est. Total Flat - Side` < -10))

df_st_club <- df_st_club %>%
  filter(!(Club == "Pitching Wedge" & `Est. Total Flat - Side` > 5))

df_st_club <- df_st_club %>%
  filter(!(Club == "Pitching Wedge" & `Est. Total Flat - Side` < -5))

# Filter out shots that do not go far
#df_st_club <- filter(df_st_club, !(
#    Club == "Driver" & `Est. Total Flat - Length` < quantile(
#        filter(
#            df_st_club, Club == "Driver"
#        )$`Est. Total Flat - Length`, 0.15
#    )
#))


# Filter out Driver shots that go too far
#df_st_club <- filter(df_st_club, !(
#    Club == "Driver" & `Est. Total Flat - Length` > quantile(
#        filter(
#            df_st_club, Club == "Driver"
#        )$`Est. Total Flat - Length`, 0.95
#    )
#))

# Filter out shots that do not go far for Irons
df_st_club <- filter(df_st_club, !(
    Club == "9 Iron" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "9 Iron"
        )$`Est. Total Flat - Length`, 0.10
    )
))

df_st_club <- filter(df_st_club, !(
    Club == "8 Iron" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "8 Iron"
        )$`Est. Total Flat - Length`, 0.10
    )
))

df_st_club <- filter(df_st_club, !(
    Club == "7 Iron" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "7 Iron"
        )$`Est. Total Flat - Length`, 0.10
    )
))

# Filter out Driver shots that go too far
df_st_club <- filter(df_st_club, !(
    Club == "7 Iron" & `Est. Total Flat - Length` > quantile(
        filter(
            df_st_club, Club == "7 Iron"
        )$`Est. Total Flat - Length`, 0.95
    )
))

df_st_club <- filter(df_st_club, !(
    Club == "6 Iron" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "6 Iron"
        )$`Est. Total Flat - Length`, 0.10
    )
))

df_st_club <- filter(df_st_club, !(
    Club == "5 Iron" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "5 Iron"
        )$`Est. Total Flat - Length`, 0.10
    )
))

df_st_club <- filter(df_st_club, !(
    Club == "4 Iron" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "4 Iron"
        )$`Est. Total Flat - Length`, 0.10
    )
))

df_st_club <- filter(df_st_club, !(
    Club == "Pitching Wedge" & `Est. Total Flat - Length` < quantile(
        filter(
            df_st_club, Club == "Pitching Wedge"
        )$`Est. Total Flat - Length`, 0.10
    )
))


# Remove shots with wrong curve
#df_st_club <- filter(df_st_club, (
#    !(abs(`Carry Flat - Side`) <= abs(`Est. Total Flat - Side`) &
#          abs(`Est. Total Flat - Side`) > 10
#    )))

table(df_st_club$Sex)

write_csv(df_st_club, "/Users/zachstrennen/Documents/SquareFace_official_repo/2024-cmu/Data Cleaning/Output Data/Cleaned_Standard_Clubs.csv")

# Side model
side_final <- gam::gam(`Max Height - Side` ~
                                  gam::s(`Club Speed`) +
                                  gam::s(`Attack Angle`) +
                                  gam::s(`Swing Plane`) +
                                  gam::s(`Face Angle`) +
                                  gam::s(`Club Path`) +
                                  gam::s(shaft_lean), data = df_st_club)

predicted_values <- predict(side_final, newdata = df_st_club)

# Calculate the MSE
actual_values <- df_st_club$`Max Height - Side`
mean((actual_values - predicted_values)^2)

df_driver_lim <- filter(df_st_club, Club == "7 Iron" & Sex == "Male")

# Side model
height_final <- gam::gam(`Max Height - Height` ~
                           gam::s(`Club Speed`) +
                           gam::s(`Attack Angle`) +
                           gam::s(`Swing Plane`) +
                           gam::s(`Face Angle`) +
                           gam::s(`Club Path`) +
                           gam::s(shaft_lean), data = df_driver_lim)

predicted_values <- predict(height_final, newdata = df_driver_lim)

# Calculate the MSE
actual_values <- df_driver_lim$`Max Height - Height`
mean((actual_values - predicted_values)^2)

# Create a new data frame that keeps all club types and drops useless parameters
df_all <- df[, -which(names(df) %in% c(
  "Date",
  "TMD No",
  "TMD Filename",
  "Ball",
  "Spin Rate Type",
  "Use In Stat",
  "Tags",
  "Condition",
  "Email"
))]



# Get rid rows with NA values
df_all <- na.omit(df_all)

# Calculate shaft_lean for known clubs
df_all <- df_all %>%
  mutate(shaft_lean = ifelse(Club == "Driver", 10.5 - `Dyn. Loft`,
    ifelse(Club == "4 Iron", 22 - `Dyn. Loft`,
      ifelse(Club == "5 Iron", 25 - `Dyn. Loft`,
        ifelse(Club == "6 Iron", 29 - `Dyn. Loft`,
          ifelse(Club == "7 Iron", 33 - `Dyn. Loft`,
            ifelse(Club == "8 Iron", 37 - `Dyn. Loft`,
              ifelse(Club == "9 Iron", 41 - `Dyn. Loft`,
                ifelse(Club == "Pitching Wedge", 45 - `Dyn. Loft`,
                  NA
                )
              )
            )
          )
        )
      )
    )
  ))
df_all
write_csv(df_all, "Output Data/Cleaned_All_Clubs.csv")
df$`Est. Total Flat - Length`

ggplot(df, aes(x=`Est. Total Flat - Side`, y=`Est. Total Flat - Length`)) + 
    geom_point(alpha=0.2, col="red") +
        ylim(0,400) +
        xlim(-160,160) +
    labs(title="The Final Position of a Ball for All Shots in the Data",
         x= "Final Side Distance from Target (yds)",
         y= "Total Length Traveled Forward (yds)") +
    theme_bw()

ggplot(df_st_club, aes(x=`Est. Total Flat - Side`, y=`Est. Total Flat - Length`)) + 
    geom_point(alpha=0.2, col="green") +
    ylim(0,400) +
    xlim(-160,160) +
    labs(title="The Final Position of a Ball for \"Good Shots\" Only",
         x= "Final Side Distance from Target (yds)",
         y= "Total Length Traveled Forward (yds)")+
    theme_bw()
