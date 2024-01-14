import std/os
import std/json
import std/httpclient

proc main() = 
    var client = newHttpClient()
    var data = newMultipartData()
    let settings_file = "settings.json"
    let settings = json.parseFile(settings_file)
    let webhook_url = settings["webhook"].getStr()
    let username = settings["username"].getStr()
    let message = settings["message"].getStr()
    let iterations = settings["iterations"].getInt() # Convert JsonNode to integer
    let delay = settings["delay"].getInt()

    data["username"] = username
    data["content"] = message

    for i in countup(1, iterations):
        try:
            echo client.postContent(webhook_url, multipart=data)
        except ValueError:
            echo "Error: Invalid webhook URL or other WEBHOOK error"
        sleep(delay)

main()
quit()

#my compile options = nim c -d:SSL -d:release --opt:speed --app:console --threads:on main.nim