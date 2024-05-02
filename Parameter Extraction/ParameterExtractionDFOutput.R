# Combine all extracted param data
all_params <- rbind(df_ideal_7iron_male_sharable,
                    df_ideal_7iron_female_sharable,
                    df_ideal_8iron_male_sharable,
                    df_ideal_8iron_female_sharable,
                    df_ideal_9iron_male_sharable,
                    df_ideal_9iron_female_sharable,
                    df_ideal_driver_male_sharable,
                    df_ideal_driver_female_sharable,
                    df_ideal_pw_male_sharable,
                    df_ideal_pw_female_sharable)

colnames(all_params)

write.csv(all_params, "Extracted_CHPs.csv")

# Separated df for actual params
param_real <- dplyr::select(all_params,
                     Club,
                     Shot_Shape,
                     Sex,
                     Club_Path_Angle,
                     Lie_Angle,
                     Attack_Angle,
                     Club_Speed,
                     Shaft_Lean,
                     Face_Angle,
                     Data_Points)

# Separated df for intervals
param_confid <- dplyr::select(all_params,
                              Club,
                              Shot_Shape,
                              Sex,
                              CPA_LB,
                              CPA_UB,
                              LA_LB,
                              LA_UB,
                              AA_LB,
                              AA_UB,
                              CS_LB,
                              CS_UB,
                              SL_LB,
                              SL_UB,
                              FA_LB,
                              FA_UB)
