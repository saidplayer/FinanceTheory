import requests,datetime,json

def get_options():
    for d in range(0,31):
        the_day = datetime.date.today() + datetime.timedelta(days = d)
        if (the_day.weekday() == 3 and the_day.day > 14 and the_day.day < 22):
            closest_option_date = the_day
            break

    html_code = requests.get("https://asx.api.markitdigital.com/asx-research/1.0/derivatives/equity/BHP/options/expiry-groups?callsPuts=calls&showOpenInterestOnly=false&showTheoreticalPricesOnly=false&styles=european&includeLepoToressOptions=false&expiryDates[]="
     + str(closest_option_date)).text

    options_data = json.loads(html_code)
    options = options_data["data"]["items"][0]["exerciseGroups"]

    option_list = []
    for option in options:
        if option["call"]["volume"] > 0:
            option_list.append([option["priceExercise"],option["call"]["priceLast"]])

    return closest_option_date, option_list

print(get_options())