$api = YandexDictionaryApi::ApiInterface.new(Constants::API_KEY)
$langs = $api.get_langs
