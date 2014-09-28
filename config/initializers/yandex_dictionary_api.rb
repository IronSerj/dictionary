$api = YandexDictionaryApi::ApiInterface.new(ENV["API_KEY"])
$langs = $api.get_langs
