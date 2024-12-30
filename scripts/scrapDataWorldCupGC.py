"""
Scraping historical world cup general classification results from https://www.skokinarciarskie.pl/.
Saving each season as .csv in "data/worldCupGC/".
"""

import requests
import csv
from bs4 import BeautifulSoup
import re




def scrapSeason(startingYear):
    url = f"https://www.skokinarciarskie.pl/puchar-swiata-w-skokach-narciarskich,{str(startingYear)}/{str(startingYear+1)}"
    csv_filename = f"../data/worldCupGC/season{str(startingYear)}_{str(startingYear+1)}.csv"
    print(csv_filename)

    response = requests.get(url)

    if response.status_code == 200:
        soup = BeautifulSoup(response.text, "html.parser")

        # Find all tables on the page
        tables = soup.find_all("table")

        # Safety check: make sure there's more than one table
        # (the user mentioned "the second table" is the one we want).
        if len(tables) < 2:
            print("Error: The page does not contain at least two tables!")
            return

        # Select the second table
        target_table = tables[1]

        # Find all rows in the chosen table
        rows = target_table.find_all("tr")

        # Open CSV file for writing
        with open(csv_filename, "w", newline="", encoding="utf-8") as csvfile:
            writer = csv.writer(csvfile)
            # Write header row
            writer.writerow(["Position", "Competitor", "Country", "Points", "Gap"])

            for row in rows:
                # Skip the row if it's the table header (has class 'naglowek')
                if "naglowek" in row.get("class", []):
                    continue

                # Extract all <td> cells
                tds = row.find_all("td")
                if len(tds) < 5:
                    continue  # skip any rows that don't have enough columns

                # Position
                position = tds[0].get_text(strip=True)

                # Competitor
                competitor = tds[1].get_text(strip=True)

                # Flag image link
                flag_img = tds[2].find("img")
                flag_link = flag_img["src"] if flag_img else ""

                # Extract country name via regex
                # We assume that the link always has the pattern "...flagi_male/<country>.gif"
                match = re.search(r"flagi_male/(.*?)\.gif", flag_link)
                country_name = match.group(1) if match else ""

                # Points
                points = tds[3].get_text(strip=True)

                # Gap
                gap = tds[4].get_text(strip=True)

                writer.writerow([position, competitor, country_name, points, gap])

        print(f"CSV file '{csv_filename}' has been successfully created!")
    else:
        print(f"Error while retrieving the page. Response code: {response.status_code}")

def main():
    #1994 first world cup points to Adam Małysz
    for year in range(1994, 2025):
        scrapSeason(year)

if __name__ == "__main__":
    main()
