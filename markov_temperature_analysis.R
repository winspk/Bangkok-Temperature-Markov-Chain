library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
library(expm)
library(DiagrammeR)
library(markovchain)

cleaned_data <- read_csv("cleaned_temperature_data.csv", show_col_types = FALSE) %>%
  arrange(Date) %>%
  mutate(
    State = factor(
      State,
      levels = c("เย็น", "ปานกลาง", "ร้อน")
    )
  )

# 2. คำนวณตารางจำนวนครั้ง (Count Matrix) และเมทริกซ์ความน่าจะเป็น (Transition Matrix P)
state_from <- cleaned_data$State[1:(nrow(cleaned_data) - 1)]
state_to   <- cleaned_data$State[2:nrow(cleaned_data)]

count_matrix <- table(From = state_from, To = state_to)
P_matrix     <- prop.table(count_matrix, margin = 1)
P_mat        <- as.matrix(P_matrix)

# 6. แสดงผลลัพธ์
cat("=== สรุปข้อมูลที่คลีนเรียบร้อยแล้ว ===\n")
cat("จำนวนวันทั้งหมดที่มีข้อมูล:", nrow(cleaned_data), "วัน\n\n")

cat("=== ตารางจำนวนครั้งการเปลี่ยนสถานะ (Count Matrix) ===\n")
print(count_matrix)

cat("\n=== เมทริกซ์ความน่าจะเป็นการเปลี่ยนสถานะ (Transition Probability Matrix P) ===\n")
print(round(P_matrix, 4))

#----------------------3.2.2-----------------------------------------
grViz("
digraph markov {
  rankdir=LR;
  node [shape = ellipse, style = filled, fillcolor = '#FFFACD'];

  # จากสถานะ 'เย็น'
  'เย็น (< 28.5°C)' -> 'เย็น (< 28.5°C)' [label = '0.7589'];
  'เย็น (< 28.5°C)' -> 'ปานกลาง (28.5-30.5°C)' [label = '0.2372'];
  'เย็น (< 28.5°C)' -> 'ร้อน (> 30.5°C)' [label = '0.0040'];

  # จากสถานะ 'ปานกลาง'
  'ปานกลาง (28.5-30.5°C)' -> 'เย็น (< 28.5°C)' [label = '0.1295'];
  'ปานกลาง (28.5-30.5°C)' -> 'ปานกลาง (28.5-30.5°C)' [label = '0.7076'];
  'ปานกลาง (28.5-30.5°C)' -> 'ร้อน (> 30.5°C)' [label = '0.1629'];

  # จากสถานะ 'ร้อน'
  'ร้อน (> 30.5°C)' -> 'เย็น (< 28.5°C)' [label = '0.0147'];
  'ร้อน (> 30.5°C)' -> 'ปานกลาง (28.5-30.5°C)' [label = '0.2574'];
  'ร้อน (> 30.5°C)' -> 'ร้อน (> 30.5°C)' [label = '0.7279'];
}
")

#-----------------------------3.2.3----------------------------------------
P1   <- P_mat %^% 1
P7   <- P_mat %^% 7
P30  <- P_mat %^% 30
P365 <- P_mat %^% 365

cat("\n=== P^7 ===\n")
print(round(P7, 4))
cat("\n=== P^30 ===\n")
print(round(P30, 4))
cat("\n=== P^365 ===\n")
print(round(P365, 4))

#--------------------------------------3.2.4----------------------------------------
state_name <- c("เย็น", "ปานกลาง", "ร้อน")

p <- matrix(
  c(0.7589, 0.2372, 0.0040,
    0.1295, 0.7076, 0.1629,
    0.0147, 0.2574, 0.7279),
  nrow = 3, byrow = TRUE,
  dimnames = list(state_name, state_name)
)

p <- p / rowSums(p)

mcP <- new("markovchain", 
           states = state_name, 
           byrow = TRUE, 
           transitionMatrix = p, 
           name = "Temperature Steady State")
steady_state <- steadyStates(mcP)

round(steady_state, 4)