library(tidyverse)
library(caret)


# Load in Trackman Golf Data
data1 <- read.csv("~/Downloads/SquareFace/SquareFace_repo/Capstone-SquareFace/data/January.csv", skip = 1, header = TRUE)
data2 <- read.csv("~/Downloads/SquareFace/SquareFace_repo/Capstone-SquareFace/data/February.csv", skip = 1, header = TRUE)
tman_data <- rbind(data1, data2)


# Remove Unnecessary Variables
tman_data <- subset(tman_data, select = -c(TMD.No, TMD.Filename, Email, Condition, Tags, Ball, Use.In.Stat))
tman_data <- tman_data[-1, ]


# Convert Variables to Numeric
tman_data$Club.Speed <- as.numeric(tman_data$Club.Speed)
tman_data$Attack.Angle <- as.numeric(tman_data$Attack.Angle)
tman_data$Swing.Plane <- as.numeric(tman_data$Swing.Plane)
tman_data$Face.Angle <- as.numeric(tman_data$Face.Angle)
tman_data$Club.Path <- as.numeric(tman_data$Club.Path)
tman_data$Max.Height...Dist. <- as.numeric(tman_data$Max.Height...Dist.)
tman_data$Max.Height...Height <- as.numeric(tman_data$Max.Height...Height)
tman_data$Club <- as.factor(tman_data$Club)
tman_data <- na.omit(tman_data)

levels(tman_data$Club)

# Standard Club Set 
# Removed 3 Wood, 5 Wood because out of Scope
st_club <- c("3 Wood", "5 Wood", "4 Iron", "5 Iron", "6 Iron", "7 Iron", "8 Iron", "9 Iron",
             "Pitching Wedge", "Driver")


# Split Data 
# DF of only Unknown Clubs
tman_unknown_club_data <- tman_data %>%
  filter(Club ==  "Unknown Club")

# DF of Standard Club Set
tman_st_club_data <- tman_data %>%
  filter(Club %in% st_club) %>%
  mutate(club_type = case_when(Club == "Driver" ~ 0,
                               Club == "3 Wood" ~ 1,
                               Club == "5 Wood" ~ 2,
                               Club == "Pitching Wedge" ~ 3,
                               Club == "4 Iron" ~ 4,
                               Club == "5 Iron" ~ 5,
                               Club == "6 Iron" ~ 6,
                               Club == "7 Iron" ~ 7,
                               Club == "8 Iron" ~ 8,
                               Club == "9 Iron" ~ 9),
         player_id = case_when(Player == "Alexis Sudjianto" ~ 1,
                               Player == "Daniel Rodgers" ~ 2,
                               Player == "Jay Saluga" ~ 3,
                               Player == "Ryan Dannegger" ~ 4,
                               Player == "Stephen Dai" ~ 5,
                               Player == "Andrew" ~ 6,
                               Player == "David Zhang" ~ 7,
                               Player == "Justin Chan" ~ 8,
                               Player == "Samantha Wang" ~ 9,
                               Player == "Steven Shea" ~ 10,
                               Player == "Ashley Liu" ~ 11,
                               Player == "Folker" ~ 12,
                               Player == "Justin Luan" ~ 13,
                               Player == "Sense sangkagoon" ~ 14,
                               Player == "Bli" ~ 15,
                               Player == "Hank" ~ 16,
                               Player == "Kaylin Yeoh" ~ 17,
                               Player == "Simulator Player" ~ 18,
                               Player == "Brian Xu" ~ 19,
                               Player == "Jack Sonne" ~ 20,
                               Player == "Nikita Jadhav" ~ 21,
                               Player == "Sriya" ~ 22))


# Check for missing values
tman_st_club_data <- na.omit(tman_st_club_data)


levels(as.factor(tman_data$Player))

# Make new Variable club_type a factor
tman_st_club_data$club_type <- as.factor(tman_st_club_data$club_type)

# Check number of levels
levels(tman_st_club_data$club_type)





library(randomForest)

# Train the Random Forest model
set.seed(12)
rf_model <- randomForest(club_type ~ `Max.Height...Dist.` + `Max.Height...Height` + 
                           Ball.Speed + Club.Speed + Attack.Angle +
                           Dynamic.Lie + Dyn..Loft + player_id , 
                         data = tman_st_club_data, ntree = 500)



rf_confusion_mat <- rf_model$confusion
rf_error <- rf_model$err.rate

varImpPlot(rf_model, main = "Club Classification Variable Importance")

# View the summary of the model
print(rf_model)
rf_model$importance

# Classify Unknown Club Types
rf_preds <- predict(rf_model, newdata = tman_unknown_club_data)

# Number of each club classified
table(rf_preds)

rf_model$votes
#tman_unknown_club_data$pred_club_type <- rf_preds





# XGBoost Model

library(xgboost)

tman_st_club_data <- tman_st_club_data %>%
  select(c(club_type, Max.Height...Dist., Max.Height...Height, Ball.Speed, Club.Speed, 
           Attack.Angle, Dynamic.Lie, Dyn..Loft, player_id))

tman_st_club_data$club_type <- as.numeric(tman_st_club_data$club_type)-1
tman_st_club_data$Max.Height...Dist. <- as.numeric(tman_st_club_data$Max.Height...Height)
tman_st_club_data$Max.Height...Dist. <- as.numeric(tman_st_club_data$Max.Height...Dist.)
tman_st_club_data$Ball.Speed <- as.numeric(tman_st_club_data$Ball.Speed)
tman_st_club_data$Club.Speed <- as.numeric(tman_st_club_data$Club.Speed)
tman_st_club_data$Attack.Angle <- as.numeric(tman_st_club_data$Attack.Angle)
tman_st_club_data$Dynamic.Lie <- as.numeric(tman_st_club_data$Dynamic.Lie)
tman_st_club_data$Dyn..Loft <- as.numeric(tman_st_club_data$Dyn..Loft)
tman_st_club_data$player_id <- as.numeric(tman_st_club_data$player_id)


# Convert data to matrix format
xgb_matrix <- xgb.DMatrix(data = as.matrix(tman_st_club_data[, !(names(tman_st_club_data) == "club_type")]),
                          label = tman_st_club_data$club_type)

# Train XGBoost model
xgb_model <- xgboost(data = xgb_matrix, 
                     booster = "gbtree",  # Use tree-based booster
                     objective = "multi:softmax",  # Multiclass classification
                     num_class = length(unique(tman_st_club_data$club_type)),  # Number of classes
                     nrounds = 500,  # Number of boosting rounds
                     verbose = TRUE)  # Print progress

plot(xgb_model)


# Make predictions
predictions <- predict(xgb_model, xgb_matrix)



# Create confusion matrix
conf_matrix <- table(Actual = tman_st_club_data$club_type, Predicted = predictions)

conf_matrix

# Example for classification report
classification_report <- caret::confusionMatrix(data = factor(tman_st_club_data$club_type, levels = levels(factor(tman_st_club_data$club_type))), reference = factor(tman_st_club_data$club_type))
print("Classification Report:")
print(classification_report)









