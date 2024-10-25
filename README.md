# Netflix vs. Disney+ Streaming Analysis

![sci-fi-movies-and-series](https://github.com/user-attachments/assets/4b75ed95-3ff3-478a-a8e6-1b7e649e9f93)
![share-default 4005eb421841eb4a612afd84f83bdd29](https://github.com/user-attachments/assets/c232da82-17dd-4625-aedb-655f09002675)

## Project Overview
This project provides a comparative analysis of content on *Netflix* and *Disney+*, exploring both platforms' strategies, global reach, and content trends. The analysis examines content diversity, age demographics, and international representation in actors and directors, ultimately proposing a data-driven approach for creating a new streaming platform in 2024 or 2025.

## Dataset Information
- *Netflix Dataset*: [Netflix Movies and TV Shows on Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)
- *Disney+ Dataset*: [Disney+ Movies and TV Shows on Kaggle](https://www.kaggle.com/datasets/shivamb/disney-movies-and-tv-shows)
- Additional dataset for Netflix subscription prices by country was also incorporated.

## Tools Used
- *Excel and Power BI* for data preprocessing and visualization
- *PostgreSQL* for data modeling and query optimization
- *Power BI* for interactive dashboard creation and insights generation

## Analysis
The project addresses questions about content availability, genre diversity, and user demographics. Key insights include:
- *Country-wise content distribution* and *genre diversity*
- *Top actors, directors, and **genre-based preferences*
- *Age group distribution* across content and its alignment with target audiences
- *Year-over-year content growth* and variations between TV shows and movies on each platform

## Data Model
Normalized tables were created in PostgreSQL, with show_id as the primary key connecting multiple related tables for cast, country, director, and genre information. Data was cleaned, deduplicated, and optimized for efficient querying.

## Key Findings
- *Top Content-Producing Countries*: U.S., India, and Japan for Netflix; U.S. and regional markets for Disney+.
- *Primary Audience*: Netflix's content leans towards mature audiences (TV-MA), while Disney+ targets a broader family-friendly demographic.
- *Genre and Duration Insights*: Dominance of specific genres on each platform and an audience preference for movies between 90–120 minutes.

## Future Platform Recommendations
Based on the findings, we suggest:
1. *Regional Content Expansion*: Prioritize emerging markets like South Korea and Spain.
2. *Age Group Diversification*: Increase youth-oriented and family-friendly content.
3. *Localized Recommendations*: Tailor content based on popular genres in each country.
4. *Short-Form Content*: Provide content options under 60 minutes for high engagement.

## Setup and Installation
1. Clone the repository:  
   bash
   git clone https://github.com/your-username/repo-name
   
2. Ensure PostgreSQL and Power BI are installed.
3. Load the provided .sql files to create the database schema.
4. Access the Power BI dashboard for interactive visualizations.

## Contributors
- *Ahmed Hosny*
- *Abdulfattah Gamal*

Supervised by *Eng. Marwan Mokhtar*

--- 

This Markdown should make the README.md file easy to read and follow on GitHub.
