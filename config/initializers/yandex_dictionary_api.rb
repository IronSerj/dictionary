$api = YandexDictionaryApi::ApiInterface.new('dict.1.1.20140904T085142Z.bc794363dea5e8da.bcafbef2c018fc447d8de5c67ff8e2dd7f57481f')
$langs = $api.get_langs
