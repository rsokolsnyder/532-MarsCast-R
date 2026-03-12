# MarsCast
An interactive dashboard for exploring the weather patterns on Mars. Data was
collected by the NASA Curiosity Rover between August 7, 2012 and February 27, 2018.

## Installation
1. Ensure you have R installed on your system.

2. Clone the repository
Open a terminal window in the direction of your choice. Run:
```
git clone https://github.com/rsokolsnyder/532-MarsCast-R.git
cd 532-MarsCast-R
```
3. Install Dependencies
Open an R session and run the following command to install the required libraries:

```
install.packages(c("shiny", "bslib", "dplyr", "ggplot2", "tidyr")
```

4. Run the dashboard
From the RConsole, run the following commands:

```
library(shiny)
runApp('src')
```
