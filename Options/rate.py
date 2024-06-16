import requests

def risk_free_rate():
    my_headers = {"user-agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36" }
    html_code = requests.get("https://ycharts.com/indicators/1_year_treasury_rate", headers = my_headers).text

    html_code = html_code.split('<td class="text-right">')

    for i in range(1,11):
        r_text = html_code[i]
        r_index = r_text.find("%")
        print(r_text[r_index-4:r_index])

risk_free_rate()