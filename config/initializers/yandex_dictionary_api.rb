$api = YandexDictionaryApi::ApiInterface.new(Rails.application.secrets[:yandex_dictionary_api_key])
$langs = $api.get_langs
