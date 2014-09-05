class DictionaryController < ApplicationController
	API_KEY = "dict.1.1.20140904T085142Z.bc794363dea5e8da.bcafbef2c018fc447d8de5c67ff8e2dd7f57481f".freeze

	def index
	$api = YandexDictionaryApi::ApiInterface.new(API_KEY)
	@langs = $api.get_langs

  end

	def interpret
		prms = Hash.new
		prms["lang"] = params[:interpretation][:lang]
		prms["text"] = params[:interpretation][:text]
		$api = YandexDictionaryApi::ApiInterface.new(API_KEY) if $api == nil
		response = $api.lookup(prms)

		@lang = params[:interpretation][:lang]
		@text = params[:interpretation][:text]
		@interpretation = self.read_json_intp_response(response)
		render 'interpretation'
	end

	protected

	def read_json_intp_response(hash)
		str_res = ""
		hash.each_pair do |key, value|
			if value.is_a? Array
				case key
				when "def"
					str_res += "\nArticle: "
				when "tr"
					str_res += "\nTranslations: "
				when "syn"
					str_res += "\nSynonyms: "
				when "mean"
					str_res += "\nMeans: "
				when "ex"
					str_res += "\nExamples: "
				end
				str_res += self.read_response_array(value)
			else
				
				str_res += "#{value} "
			end
		end
		str_res
	end

	def read_response_array(array)
		str_res = ""
		array.each do |hash|
			str_res += read_json_intp_response(hash)
		end
		str_res
	end

end

