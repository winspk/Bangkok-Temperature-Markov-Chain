# Bangkok Temperature Change Analysis Using Markov Chain

An applied stochastic modeling project analyzing **974 days** of daily mean temperature in **Bangkok, Thailand** (January 1, 2024 – August 31, 2026) using a **Discrete-Time Markov Chain (DTMC)** in **R**.

> *Group coursework report for `01422485` Stochastic Operations Research, B.Sc. in Statistics (2022 curriculum), Semester 1, Academic Year 2026, Kasetsart University. The full Thai report PDF is included in this repository.*

---

## 1. Problem, Objectives & Dataset
* **Background & Purpose:** Examines daily mean temperature transitions in Bangkok—an urban area experiencing urban heat island effects—to model state persistence, multi-step transition probabilities, and long-term equilibrium behavior.
* **Dataset:** Historical daily mean temperature time series for Bangkok, Thailand, covering **974 days** from **January 1, 2024 to August 31, 2026** (sourced from `wunderground.com`).
* **Temperature States:**
  * **Cool (`เย็น`):** Mean daily temperature < 28.5°C
  * **Moderate (`ปานกลาง`):** Mean daily temperature 28.5°C – 30.5°C
  * **Hot (`ร้อน`):** Mean daily temperature > 30.5°C
* **Tools & Packages:** RStudio (`dplyr`, `rlang`, `DiagrammeR`, `expm`, `markovchain`).

---

## 2. Transition Count & Probability Matrix (n = 1 Day)

Using current state (`State`) and next-day state (`lead()` / next day), the observed transition counts and 1-step transition probability matrix **P** are:

### Transition Count Matrix
| From \ To (Next Day) | Cool | Moderate | Hot | Total |
| :--- | :---: | :---: | :---: | :---: |
| **Cool** | 192 | 60 | 1 | 253 |
| **Moderate** | 58 | 317 | 73 | 448 |
| **Hot** | 4 | 70 | 198 | 272 |
| **Total** | 254 | 447 | 272 | 973 |

### 1-Step Transition Probability Matrix (P¹)
| From \ To (Next Day) | Cool | Moderate | Hot |
| :--- | :---: | :---: | :---: |
| **Cool** | 0.7589 | 0.2372 | 0.0040 |
| **Moderate** | 0.1295 | 0.7076 | 0.1629 |
| **Hot** | 0.0147 | 0.2574 | 0.7279 |

### Key Short-Term Findings (1-Day)
* **Strong day-to-day persistence:** Each state has the highest probability of remaining in the same state the next day (**Cool: 75.89%**, **Hot: 72.79%**, **Moderate: 70.76%**).
* **Low probability of extreme jumps:** Direct one-day transitions between opposite extremes are rare (**Cool -> Hot: 0.40%**, **Hot -> Cool: 1.47%**).

---

## 3. n-Step Transition Probabilities (n = 7, 30, 365 Days)

Computing **Pⁿ** in R (`expm`) shows how initial state influence fades as the forecast horizon grows:

* **At n = 7 days:** Moderate is the most likely state across all starting conditions (**45.22% – 46.12%**), while initial state differences are still visible (e.g., 7-day Hot probability is **21.76%** from Cool, **28.21%** from Moderate, and **32.97%** from Hot).
* **At n = 30 and n = 365 days:** Row probabilities converge closely, indicating that long-term state probabilities become largely independent of the starting state. At **n = 365**, probabilities are approximately **Moderate: ~46.3%**, **Hot: ~28.1%**, and **Cool: ~26.6%**.

---

## 4. Steady-State Probability (π)

Solving **π = πP** with sum of probabilities equal to 1 using `markovchain` yields the long-run equilibrium distribution:

| State | Steady-State Probability | Share (%) |
| :--- | :---: | :---: |
| **Cool (`เย็น`)** | 0.2632 | 26.32% |
| **Moderate (`ปานกลาง`)** | 0.4585 | 45.85% |
| **Hot (`ร้อน`)** | 0.2784 | 27.84% |

In the long run, Bangkok's daily mean temperature is most likely to be **Moderate (45.85%)**, followed by **Hot (27.84%)** and **Cool (26.32%)**, with **Hot + Moderate** accounting for **73.69%** combined.

---

## 5. Practical Applications, Limitations & Future Work
* **Applications:**
  * *Public Health & Alerting:* Support heatstroke warnings and protection for vulnerable groups (elderly, chronic patients, outdoor workers) given the **73.69%** combined long-run share of Hot and Moderate states and Hot persistence.
  * *Urban Planning & Environment:* Inform green spaces, shade trees, and energy-efficient building design to mitigate urban heat island effects.
  * *Business & Retail:* Guide inventory planning (e.g., cold beverages, cooling products), promotions, and outdoor scheduling based on daily weather transition probabilities.
* **Limitations:**
  * Assumes stationary transition probabilities across all 974 days without separating seasons or climate phenomena (such as El Niño or La Niña).
  * Relies on daily mean temperature, which can mask intraday temperature swings (such as hot afternoons followed by heavy rain and cooling in the evening).
  * Scope is limited to Bangkok and does not directly represent other regions of Thailand.
* **Future Work:** Incorporate additional meteorological variables (humidity, rainfall, wind speed, heat index), build seasonal transition matrices (summer, rainy, winter), compare against other time-series forecasting models, and expand to other regions.
